module mem
(   
    input logic clk,
    input logic [31:0] addr,
    input logic [31:0] write_data,
    input logic [2:0] funct3,
    input logic write_enable,
    output logic [31:0] read_data
);

localparam logic [2:0] B = 3'b000;
localparam logic [2:0] H = 3'b001;
localparam logic [2:0] W = 3'b010;
localparam logic [2:0] LBU = 3'b100;
localparam logic [2:0] LHU = 3'b101;

logic [7:0] mem [0:4095];
logic [31:0] world;
logic [11:0] local_addr;

assign local_addr = addr[11:0];
assign world = {mem[local_addr + 3], mem[local_addr + 2], mem[local_addr + 1], mem[local_addr]};

always_ff @(posedge clk)
begin
    if(write_enable)
    begin
        case (funct3)
            B : mem[local_addr] <= write_data[7:0];

            H : begin
                mem[local_addr] <= write_data[7:0];
                mem[local_addr + 1] <= write_data[15:8];
            end

            W : begin
                 mem[local_addr] <= write_data[7:0];
                 mem[local_addr + 1] <= write_data[15:8];
                 mem[local_addr + 2] <= write_data[23:16];
                 mem[local_addr + 3] <= write_data[31:24];
            end
            default : ;
        endcase

    end 
end

always_comb 
begin

    case(funct3)

        B : read_data = {{24{world[7]}} ,world[7:0]};

        H : read_data = {{16{world[15]}} ,world[15:0]};

        W : read_data = world;

        LBU : read_data = {24'b0 ,world[7:0]};

        LHU : read_data = {16'b0 , world[15:0]};

        default : read_data = 32'b0;
    endcase
end


endmodule