`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2019 08:13:41 PM
// Design Name: 
// Module Name: PWM
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


module PWM(
    input logic [7:0] SWITCHES,
    input CLK,
    output logic SIGNAL
    );

//initial begin
//    SIGNAL = 1'b0;
//end    
//int counter;

reg [7:0] counter = 8'b00000000;           //initialize counter to 0


always_ff @(posedge CLK) begin             //on every clock edge
    counter <= counter + 1'b1;             //increment counter
    if (counter == 8'b11111111)            //Divide clock to get desired frequency
        counter = 8'b0;                    //Reset counter when == 255
    if ( counter < SWITCHES )              //Delay/Duty Cycle based on 8-bit input
        SIGNAL <= 1'b1;                    //While counter < switches, Signal is high
    else                                   
        SIGNAL <= 1'b0;                    //otherwise, signal is low 
        
end






//always_ff @(posedge CLK) begin
//    //#duty;
//    counter <= counter + 1;
//    if (counter >= 255 & counter != 0) begin
//        counter <= 0;
//        SIGNAL <= !SIGNAL;
//    end
    
//end
    
    
    
endmodule
