`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2019 08:27:49 PM
// Design Name: 
// Module Name: ScrRam
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


module ScrRam(
    input [9:0] DATA_IN,
    input [7:0] SCR_ADDR,
    input SCR_WE,
    input CLK,
    output logic [9:0] DATA_OUT
    );
    
logic [0:9] ram [0:255];    

initial begin
    int i;
    for (i=0; i<255; i++) begin
        ram[i] = 0;         //initialize ram to zero
    end
end

assign DATA_OUT = ram[SCR_ADDR]; //this needs to be padded with zeros at the three MSBs 


always_ff @(posedge CLK) begin    
    if(SCR_WE == 1'b1)
        ram[SCR_ADDR] <= DATA_IN;
end
    
endmodule
