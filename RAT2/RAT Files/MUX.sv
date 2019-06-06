`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CPE - 233
// Engineer: Connor McKee and Marty Lange
// 
// Create Date: 01/17/2019 07:38:35 PM
// Design Name: 
// Module Name: MUX
// Project Name: RAT2
// Target Devices: Basys 3
// Tool Versions: 
// Description: A 2-bit mux selector with two default values at 10 & 11
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MUX(
    input [9:0] FROM_IMMED,
    input [9:0] FROM_STACK,
    input [1:0] PC_MUX_SEL,
    output logic [9:0] DIN
    );
    

always_comb begin
    if(PC_MUX_SEL == 2'b00)
        DIN = FROM_IMMED;
    else if(PC_MUX_SEL == 2'b01)
        DIN = FROM_STACK;
    else if(PC_MUX_SEL == 2'b10)
        DIN = 10'b1111111111;
    else 
        DIN = 10'h000;
end    
    
endmodule
