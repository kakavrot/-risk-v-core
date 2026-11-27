module top
(
    input logic clk,
    input logic rst_n
);

logic [31:0] counter_command;
logic [31:0] counter_plus_4;
logic [31:0] counter_from_alu;
logic load_flag_o;
logic [31:0] command;
logic [4:0] read_addr_0;
logic [4:0] read_addr_1;
logic [4:0] write_addr;
logic [31:0] imm;
logic [2:0] funct3_S; 
logic [31:0] read_data_0;
logic [31:0] read_data_1;
logic write_enable_mem;
logic [2:0] funct3_D;
logic cond_jump;
logic ucond_jump;
logic  mux_a;
logic  mux_b;
logic [1:0] data_mux;
logic write_enable_reg;
logic [3:0] opcode_from_decoder_for_ALU;
logic [31:0] write_data;
logic [31:0] read_data_mem;
logic [31:0] mux_data_out;
logic [31:0] alu_result;
logic [31:0] mux_a_out;
logic [31:0] mux_b_out;
logic [31:0] A_operand;
logic [31:0] B_operand;
logic [3:0] opcode_from_decoder;
logic [31:0] ALU_result;
logic load_flag_ALU;

program_counter program_counter_0
(
    .clk (clk),
    .rst_n (rst_n),
    .counter_from_alu (ALU_result),
    .load_flag (load_flag_o),
    .counter_plus_4 (counter_plus_4),
    .counter_command (counter_command)
);

rom rom_0
(
    .addr_command (counter_command),
    .command (command)
);

instruction_slicer instruction_slicer_0
(
    .instruction (command),
    .read_addr_0 (read_addr_0),
    .read_addr_1 (read_addr_1),
    .write_addr (write_addr),
    .imm (imm),
    .funct3 (funct3_S)
);

reg_file reg_file_0
(
    .clk (clk),
    .rst_n (rst_n),
    .write_enable (write_enable_reg),
    .read_addr_0 (read_addr_0),
    .read_addr_1 (read_addr_1),
    .write_addr (write_addr),
    .inp_data (mux_data_out),
    .read_data_0 (read_data_0),
    .read_data_1 (read_data_1)
);

decoder decoder_0
(
    .command (command),
    .write_enable_mem (write_enable_mem),
    .funct3 (funct3_D),
    .cond_jump (cond_jump),
    .ucond_jump (ucond_jump),
    .mux_a (mux_a),
    .mux_b (mux_b),
    .data_mux (data_mux),
    .write_enable_reg (write_enable_reg),
    .opcode_from_decoder_for_ALU (opcode_from_decoder_for_ALU)
);

mem mem_0
(
    .clk (clk),
    .funct3 (funct3_D),
    .write_enable (write_enable_mem),
    .read_data (read_data_mem),
    .write_data (read_data_1),
    .addr (ALU_result)
);


assign mux_data_out = (data_mux == 2'b00) ? ALU_result :
                      (data_mux == 2'b01) ? read_data_mem :
                      (data_mux == 2'b10) ? counter_plus_4 :
                      (data_mux == 2'b11) ? imm : 32'd0;

assign mux_a_out = (!mux_a) ? read_data_0 :
                   (mux_a) ? counter_command : 32'd0;

assign mux_b_out = (!mux_b) ? read_data_1 :
                   (mux_b) ? imm : 32'd0;

ALU ALU_0
(
    .A_operand (mux_a_out),
    .B_operand (mux_b_out),
    .opcode_from_decoder (opcode_from_decoder_for_ALU),
    .ALU_result (ALU_result)
);

ALU_BRANCH ALU_BRANCH_0
(
    .A_operand (read_data_0),
    .B_operand (read_data_1),
    .funct3 (funct3_S),
    .load_flag (load_flag_ALU)
);

assign load_flag_o = (load_flag_ALU & cond_jump) | ucond_jump;

endmodule