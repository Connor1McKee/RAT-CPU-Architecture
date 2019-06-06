`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2019 02:38:47 PM
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
    input [9:0] DIN,
    input PC_LD,
    input PC_INC,
    input RST,
    input CLK,
    output reg [9:0] PC_COUNT
    );


    
always @(posedge CLK) begin
    if(RST == 1'b1)
        PC_COUNT <= 10'b0000000000;
    else if(PC_LD == 1'b1)
        PC_COUNT <= DIN;
    else if(PC_INC == 1'b1)
        //PC_COUNT++;
        PC_COUNT <= PC_COUNT + 1;
end    
    
endmodule
