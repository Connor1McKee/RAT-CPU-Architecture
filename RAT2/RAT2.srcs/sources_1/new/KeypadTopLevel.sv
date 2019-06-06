`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2019 02:25:53 PM
// Design Name: 
// Module Name: KeypadTopLevel
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


module KeypadTopLevel(
    input [2:0] COLUMNS,
    output [3:0] ROWS,     
    input CLK,
    input MODE,
    output [3:0] ANODES,
    output [7:0] CATHODES
    );
    
//intermediates
logic [7:0] DATA_INTER;

    
KeypadDriver KPD (.COLUMN(COLUMNS), .ROWS(ROWS),
    .CLK(CLK), .DATA(DATA_INTER)
);

SevSegDisp SSEG(.CLK(CLK), .MODE(MODE),
    .DATA_IN({8'b11111111, DATA_INTER}), .CATHODES(CATHODES), .ANODES(ANODES)
);
      
    
endmodule
