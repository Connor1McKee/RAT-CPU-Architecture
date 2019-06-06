`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2019 09:41:59 PM
// Design Name: 
// Module Name: Speaker_Driver
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


module Speaker_Driver(
    input [7:0] KEYS,
    input CLK,
    output logic FREQ = 0                       //initialize to 0
    );

int countTo;      
int counter;


always_comb begin
    case (KEYS)
        8'b00000001 : countTo = 47778;          //Each statement corresponds to a single
        8'b00000010 : countTo = 45096;          //value between 0-36. Each statement has
        8'b00000011 : countTo = 42565;          //its own specific counter to get the 
        8'b00000100 : countTo = 40176;          //desired frequency
        8'b00000101 : countTo = 37921;
        8'b00000110 : countTo = 35793;
        8'b00000111 : countTo = 33784;
        8'b00001000 : countTo = 31888;
        8'b00001001 : countTo = 30089;
        8'b00001010 : countTo = 28409;
        8'b00001011 : countTo = 26814;
        8'b00001100 : countTo = 25309;
        8'b00001101 : countTo = 23889;
        8'b00001110 : countTo = 22548;
        8'b00001111 : countTo = 21282;
        8'b00010000 : countTo = 20088;
        8'b00010001 : countTo = 18960;
        8'b00010010 : countTo = 17896;
        8'b00010011 : countTo = 16892;
        8'b00010100 : countTo = 15944;
        8'b00010101 : countTo = 15049;
        8'b00010110 : countTo = 14204;
        8'b00010111 : countTo = 13407;
        8'b00011000 : countTo = 12655;
        8'b00011001 : countTo = 11945;
        8'b00011010 : countTo = 11274;
        8'b00011011 : countTo = 10641;
        8'b00011100 : countTo = 10044;
        8'b00011101 : countTo = 9480;
        8'b00011110 : countTo = 8948;
        8'b00011111 : countTo = 8446;
        8'b00100000 : countTo = 7972;
        8'b00100001 : countTo = 7525;
        8'b00100010 : countTo = 7102;
        8'b00100011 : countTo = 6704;
        8'b00100100 : countTo = 6327;
        default : begin
                    countTo = 0;
                  end
        
    endcase
end
 
always_ff @(posedge CLK) begin
    counter <= counter + 1;
    if(counter >= countTo & counter != 0) begin   //Divide the clock and invert the output      
       counter <= 0;
       FREQ <= !FREQ;
    end
end
    
endmodule
