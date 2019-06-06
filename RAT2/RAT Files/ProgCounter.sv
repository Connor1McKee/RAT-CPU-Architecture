`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CPE - 233
// Engineer: Connor McKee and Marty Lange
// 
// Create Date: 01/17/2019 07:38:35 PM
// Design Name: 
// Module Name: ProgCounter
// Project Name: RAT2
// Target Devices: Basys 3
// Tool Versions: 
// Description: A Program Counter that resets, loads values, and increments.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module ProgCounter(
    input logic [9:0] DIN,
    input PC_LD,
    input PC_INC,
    input RST,
    input CLK,
    output logic [9:0] PC_COUNT
    );
    

always_ff @(posedge CLK) begin      //at every rising edge
    if(RST == 1'b1)
        PC_COUNT <= 10'h000;          //reset PC_COUNT output to 0x000
    else if(PC_LD == 1'b1)
        PC_COUNT <= DIN;           //output DIN when LOAD is high
    else if(PC_INC == 1'b1)
        PC_COUNT <= PC_COUNT + 1;  //increment the PC_COUNT
end    
    
endmodule