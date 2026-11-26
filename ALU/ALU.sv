module ALU
(
    input logic [31:0] A_operand,
    input logic [31:0] B_operand,
    input logic [4:0] opcode_from_decoder,
    output logic [31:0] ALU_result
);

localparam logic [4:0] match_ADD = 5'b00000;
localparam logic [4:0] match_SUB = 5'b00001;
localparam logic [4:0] SLL = 5'b00010;
localparam logic [4:0] SLT = 5'b00100;
localparam logic [4:0] SLTU = 5'b00110;
localparam logic [4:0] XOR = 5'b01000;
localparam logic [4:0] SRL = 5'b01010;
localparam logic [4:0] SRA = 5'b01011;
localparam logic [4:0] OR = 5'b01100;
localparam logic [4:0] AND = 5'b01110;
localparam logic [4:0] SLLI = 5'b10010;
localparam logic [4:0] SRLI = 5'b11010;
localparam logic [4:0] SRAI = 5'b11011;

logic [31:0] ALU_wire;
logic [4:0] shamt;
assign shamt = B_operand[4:0];

always_comb
begin

    

   case(opcode_from_decoder)

    match_ADD : ALU_wire = A_operand + B_operand;
        
    match_SUB : ALU_wire = A_operand - B_operand;

    SLL, SLLI : ALU_wire = A_operand << shamt;

    SLT : ALU_wire = ($signed(A_operand) < $signed(B_operand)) ? 32'b1 : 32'b0;

    SLTU : ALU_wire = (A_operand < B_operand) ? 32'b1 : 32'b0;

    XOR : ALU_wire = A_operand ^ B_operand;

    SRL, SRLI : ALU_wire = A_operand >> shamt;

    SRA, SRAI : ALU_wire = ($signed(A_operand)) >>> shamt;

    OR : ALU_wire = A_operand | B_operand;

    AND : ALU_wire = A_operand & B_operand;

    default : ALU_wire = 32'd0;

   endcase
end

assign ALU_result = ALU_wire;

endmodule 