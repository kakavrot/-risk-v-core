module ALU
(
    input logic [31:0] A_operand,
    input logic [31:0] B_operand,
    input logic [3:0] opcode_from_decoder,
    output logic [31:0] ALU_result
);

localparam logic [3:0] match_ADD = 4'b0000;
localparam logic [3:0] match_SUB = 4'b0001;
localparam logic [3:0] SLL = 4'b0010;
localparam logic [3:0] SLT = 4'b0100;
localparam logic [3:0] SLTU = 4'b0110;
localparam logic [3:0] XOR = 4'b1000;
localparam logic [3:0] SRL = 4'b1010;
localparam logic [3:0] SRA = 4'b1011;
localparam logic [3:0] OR = 4'b1100;
localparam logic [3:0] AND = 4'b1110;


logic [31:0] ALU_wire;
logic [4:0] shamt;
assign shamt = B_operand[4:0];

always_comb
begin

    

   case(opcode_from_decoder)

    match_ADD : ALU_wire = A_operand + B_operand;
        
    match_SUB : ALU_wire = A_operand - B_operand;

    SLL : ALU_wire = A_operand << shamt;

    SLT : ALU_wire = ($signed(A_operand) < $signed(B_operand)) ? 32'b1 : 32'b0;

    SLTU : ALU_wire = (A_operand < B_operand) ? 32'b1 : 32'b0;

    XOR : ALU_wire = A_operand ^ B_operand;

    SRL : ALU_wire = A_operand >> shamt;

    SRA : ALU_wire = ($signed(A_operand)) >>> shamt;

    OR : ALU_wire = A_operand | B_operand;

    AND : ALU_wire = A_operand & B_operand;

    default : ALU_wire = 32'd0;

   endcase
end

assign ALU_result = ALU_wire;

endmodule 