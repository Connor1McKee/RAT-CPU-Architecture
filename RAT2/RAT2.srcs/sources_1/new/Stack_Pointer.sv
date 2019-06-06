`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2019 02:58:31 PM
// Design Name: 
// Module Name: Stack_Pointer
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


module Stack_Pointer(
    input [7:0] DATA_IN,
    input RST,
    input SP_LD,
    input SP_INCR,
    input SP_DECR,
    input CLK,
    output logic [7:0] DATA_OUT 
    );
    
always_ff @(posedge CLK) begin
    if(RST == 1'b1)
        DATA_OUT <= 8'h00;
    else if(SP_LD == 1'b1)
        DATA_OUT <= DATA_IN;
    else if(SP_INCR == 1'b1)
        DATA_OUT <= DATA_OUT + 1;
    else if(SP_DECR == 1'b1)
        DATA_OUT <= DATA_OUT - 1;
    
end
    
    
endmodule
