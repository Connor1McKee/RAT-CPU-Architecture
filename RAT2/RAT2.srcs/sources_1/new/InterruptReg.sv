`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2019 08:04:28 PM
// Design Name: 
// Module Name: InterruptReg
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


module InterruptReg(
    input I_SET,
    input I_CLR,
    input INTERRUPT,
    input CLK,
    output logic INTER_OUT
    );

logic INTER_REG;
    
always_ff @(posedge CLK) begin
        if(I_CLR == 1)
            INTER_REG = 0;
        else if(I_SET == 1)
            INTER_REG = 1;
    end


assign INTER_OUT = INTER_REG & INTERRUPT;    
    
endmodule
