module decoder
(
    input logic [31:0] command,
    output logic write_enable_mem,
    output logic [2:0] funct3,
    output logic cond_jump,
    output logic ucond_jump,
    output logic  mux_a,
    output logic  mux_b,
    output logic [1:0] data_mux,
    output logic write_enable_reg,
    output logic [3:0] opcode_from_decoder_for_ALU
);

logic [6:0] opcode;

assign opcode = command[6:0];

localparam logic [6:0] B = 7'b1100011;
localparam logic [6:0] I_A = 7'b0010011;
localparam logic [6:0] I_L = 7'b0000011;
localparam logic [6:0] I_J = 7'b1100111;
localparam logic [6:0] J = 7'b1101111;
localparam logic [6:0] R = 7'b0110011;
localparam logic [6:0] S = 7'b0100011;
localparam logic [6:0] U_I = 7'b0110111;
localparam logic [6:0] U_IPC = 7'b0010111;


always_comb
begin
    write_enable_mem = 0;
    funct3 = 3'b000;
    cond_jump = 0;
    ucond_jump = 0;
    mux_a = 0;
    mux_b = 0;
    data_mux = 0;
    write_enable_reg = 0;
    write_enable_mem = 0;
    opcode_from_decoder_for_ALU = 4'b0000;

    unique case(opcode)

    B : begin
        opcode_from_decoder_for_ALU = 4'b0000;
        mux_a = 1'b1;
        mux_b = 1'b1;
        cond_jump = 1'b1;
        funct3 = command[14:12];
    end

    I_A : begin 
        opcode_from_decoder_for_ALU = (command[14:12] == 3'b101) ? {command[14:12], command[30]} : {command[14:12], 1'b0};
        mux_a = 0;
        mux_b = 1;
        write_enable_reg = 1;
        data_mux = 2'b00;
    end

    I_L : begin
        opcode_from_decoder_for_ALU = 4'b0000;
        mux_a = 0;
        mux_b = 1;
        write_enable_reg = 1;
        data_mux = 2'b01;
        funct3 = command[14:12];
    end

    I_J : begin
        opcode_from_decoder_for_ALU = 4'b1111;
        mux_a = 0;
        mux_b = 1;
        write_enable_reg = 1;
        data_mux = 2'b10;
        ucond_jump = 1;
    end

    J : begin
        opcode_from_decoder_for_ALU = 4'b0000;
        mux_a = 1;
        mux_b = 1;
        write_enable_reg = 1;
        data_mux = 2'b10;
        ucond_jump = 1;
    end

    R : begin
        opcode_from_decoder_for_ALU = {command[14:12], command[30]};
        mux_a = 0;
        mux_b = 0;
        write_enable_reg = 1;
        data_mux = 2'b00;
    end

    S : begin
        opcode_from_decoder_for_ALU = 4'b0000;
        mux_a = 0;
        mux_b = 1;
        write_enable_mem = 1;
        funct3 = command[14:12];
    end

    U_I : begin
        opcode_from_decoder_for_ALU = 4'b0000;
        write_enable_reg = 1;
        data_mux = 2'b11;
    end

    U_IPC : begin
        opcode_from_decoder_for_ALU = 4'b0000;
        mux_a = 1;
        mux_b = 1;
        write_enable_reg = 1;
        data_mux = 2'b00;
    end

    default ;

    endcase
end




    


endmodule