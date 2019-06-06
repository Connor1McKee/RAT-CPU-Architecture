`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2019 03:21:26 PM
// Design Name: 
// Module Name: KeypadDriver
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


module KeypadDriver(
    input [2:0] COLUMN,
    input CLK,
    output logic [3:0] ROWS,
    output logic [7:0] DATA
    );
    
 //define state enum
 typedef enum {ST_ROW1, ST_ROW2, ST_ROW3, ST_ROW4} STATES;
 STATES NS, PS = ST_ROW1;  //PS = ST_ROW1
 
 //split up individual ROW values
 logic ROW1, ROW2, ROW3, ROW4;
 assign ROWS = {ROW4, ROW3, ROW2, ROW1};
 
 //concatenate rows and columns as data
 logic [7:0] s_data;
 assign s_data = {ROWS, COLUMN};                    //first 4: ROWS4-1, last 3: COLUMNS3-1
 
 logic div_clk = 0;                                 //need a clock divider for the longer time of butten presses
 int counter;
 int value = 1000000;                               //use 4,000,000 to achieve a 25Hz signal
 
 always_ff @(posedge CLK) begin                     //clock divider
    counter <= counter + 1;
    if(counter >= value) begin
        counter <= 0;
        div_clk <= ~div_clk;
    end
    
 end
 
 //Synchronous block to scan the Rows at a reduced rate
 always_ff @(posedge div_clk) begin
    PS <= NS;
 end
 
 //combinational circuit to determine how to read data from row to row
 always_comb begin
    ROW1 = 0; ROW2 = 0; ROW3 = 0; ROW4 = 0;     //initialize outputs 
    NS = PS;
    case (PS)
        ST_ROW1 : begin
           ROW1 = 1;
           if(COLUMN == 3'b000)begin
                NS = ST_ROW2;
           end
        end
        
        ST_ROW2 : begin
            ROW2 = 1;
            if(COLUMN == 3'b000)begin
                NS = ST_ROW3;
            end 
        end
    
        ST_ROW3 : begin
            ROW3 = 1;
            if(COLUMN == 3'b000)begin
                NS = ST_ROW4;
            end
    
        end
    
        ST_ROW4 : begin
            ROW4 = 1;
            if(COLUMN == 3'b000)begin
                NS = ST_ROW1;
            end     
        end    
    endcase
 end
 
 //assign DATA here for outputting
 always_comb begin
                        //initialize
    case (s_data)
        //ROW 1
        7'b0001001 : begin
            DATA = 8'b00000011;     // 3
        end   
        7'b0001010 : begin
            DATA = 8'b00000010;     // 2
        end   
        7'b0001100, 7'b0001110, 7'b0001101 : begin 
            DATA = 8'b00000001;    // 1
        end
        //ROW 2
        7'b0010001 : begin 
            DATA = 8'b00000110;     // 6 
        end   
        7'b0010010 : begin
            DATA = 8'b00000101;     // 5 
        end   
        7'b0010100, 7'b0010110, 7'b0010101 : begin
            DATA = 8'b00000100;     // 4 
        end   
        //ROW 3
        7'b0100001 : begin 
            DATA = 8'b00001001;     // 9 
        end   
        7'b0100010 : begin
            DATA = 8'b00001000;     // 8 
        end   
        7'b0100100, 7'b0100110, 7'b0100101 : begin 
            DATA = 8'b00000111;     // 7 
        end   
        //ROW 4
        7'b1000001 : begin
            DATA = 8'hB;            // # - B 
        end           
        7'b1000010 : begin 
            DATA = 8'b00000000;     // 0 
        end  
        7'b1000100, 7'b1000110, 7'b1000101 : begin 
            DATA = 8'hA;            // * - A 
        end   

        default : begin
            DATA = 8'hFF;                   // if no key pressed, 
        end
    
    endcase
 
 end
 
 
    
endmodule


