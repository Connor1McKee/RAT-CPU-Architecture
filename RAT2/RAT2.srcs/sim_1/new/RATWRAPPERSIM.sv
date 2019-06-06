`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2019 04:04:03 PM
// Design Name: 
// Module Name: RATWRAPPERSIM
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


module RATWRAPPERSIM(

    );
    
    logic CLK = 0;
    logic BTNC = 0;
    logic MODE_BTN = 0;
    logic [7:0] PMOD = 0;
    logic [7:0] SWITCHES = 0;
    logic [7:0] LEDS;
    
    
    RAT_WRAPPER UUT (.*);
    
    always begin
        #10 CLK <= ~CLK;
    end
    
endmodule
