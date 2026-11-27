module rom
(
    input logic [31:0] addr_command,
    output logic [31:0] command
);

logic [31:0] rom_0 [0:1023];
logic [9:0] need_addr;

assign need_addr = addr_command[11:2];

assign command = rom_0[need_addr];

initial begin
    $readmemh("program.mem", rom_0);
end

endmodule