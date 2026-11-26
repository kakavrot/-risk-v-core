module ALU_BRANCH
(
    input logic [31:0] A_operand,
    input logic [31:0] B_operand,
    input logic [2:0] funct3,
    output logic load_flag
);

localparam logic [2:0] BEQ = 3'b000;
localparam logic [2:0] BNE = 3'b001;
localparam logic [2:0] BLT = 3'b100;
localparam logic [2:0] BGE = 3'b101;
localparam logic [2:0] BLTU = 3'b110;
localparam logic [2:0] BGEU = 3'b111;

always_comb
begin
    case(funct3)

    BEQ : load_flag = (A_operand == B_operand) ? 1'b1 : 1'b0;

    BNE : load_flag = A_operand != B_operand;

    BLT : load_flag = ($signed(A_operand) < $signed(B_operand)) ? 1'b1 : 1'b0;
    
    BGE : load_flag = ($signed(A_operand) >= $signed(B_operand)) ? 1'b1 : 1'b0;

    BLTU : load_flag = (A_operand < B_operand) ? 1'b1 : 1'b0;

    BGEU : load_flag = (A_operand >= B_operand) ? 1'b1 : 1'b0;

    default : load_flag = 1'b0;
    endcase
end


endmodule