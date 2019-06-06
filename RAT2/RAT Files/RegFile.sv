`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2019 12:29:10 PM
// Design Name: 
// Module Name: RegFile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegFile(
    input [7:0] DIN,
    input [4:0] ADDRX,
    input [4:0] ADDRY,
    input RF_WR,
    input CLK,
    output logic [7:0] DX_OUT,
    output logic [7:0] DY_OUT
    );    

logic [0:7] ram [0:31]; //ram for the 32x8 reg memory

initial begin
    int i;
    for (i=0; i<32; i++) begin
        ram[i] = 0;         //initialize ram to zero
    end
end

always_comb begin
    DX_OUT = ram[ADDRX];
    DY_OUT = ram[ADDRY];
end


always_ff @(posedge CLK) begin 
    if(RF_WR == 1'b1) //if write enabled, store data in to register at addrx
        ram[ADDRX] <= DIN; //need to pad the first three MSB with 0's since they're different widths

end

endmodule
