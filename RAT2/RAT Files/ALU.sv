`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2019 03:51:38 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [3:0] SEL,                                        
    input logic [7:0] A,                                    
    input logic [7:0] B,
    input CIN,
    output logic [7:0] RESULT,
    output logic C,
    output logic Z
    );
logic [8:0] TEMP;                                            //Create a variable that has one extra bit in the MSB
                                                            //so that the carry bit can reside there


always_comb begin
    
    case (SEL)
        4'b0000 : begin //add
                    TEMP = A + B;                                         
                  end
        
        4'b0001 : begin //addc
                    TEMP = A + B + CIN;
                  end    
 
        4'b0010 : begin //sub
                    TEMP = A - B;
                  end  
        
         4'b0011 : begin //subc
                     TEMP = A - B - CIN;                       
                   end 
         
         4'b0100 : begin //cmp
                     TEMP = A - B;                          //subtract inputs, MCU will discard result
                   end 
         
         4'b0101 : begin //and
                     TEMP = {1'b0, A&B};  
                   end 
         
         4'b0110 : begin  //or
                     TEMP = {1'b0, A|B};
                   end 
         
         4'b0111 : begin //EXOR (invert) bits
                     TEMP = {1'b0, A^B};
                    end 
         
         4'b1000 : begin  //test
                         //AND inputs, MCU will discard result
                     TEMP = {1'b0, A&B};
                    end 

        4'b1001 : begin //LSL     
                    TEMP = {A[7:0], CIN};                   //concatenate: A, & set LSB to Carry
                 end       
                  
        4'b1010 : begin //LSR
                    TEMP = {A[0], CIN, A[7:1]};             //concatenate: LSB, Carry, & bits 8-2
                  end
        
        
        4'b1011 : begin //ROL
                    TEMP = {A[7], A[6:0], A[7]};            //concatenate: MSB, bits 7-1, & MSB
                  end       
        
        4'b1100 : begin //ROR
                    TEMP = {A[0], A[0], A[7:1]};            //concatenate: LSB, LSB, & bits 8-2
                  end  
        
        
        4'b1101 : begin //ASR
                    TEMP = {A[0], A[7], A[7:1]};            //concatenate: LSB, MSB, & bits 8-2
                  end
        
        
        4'b1110 : begin //MOV
                    //TEMP = B;
                    TEMP = {CIN, B[7:0]};
                    //A = B; ????
                  end
                  
        default : begin
                    //unused case?
                    //TEMP = B;
                    TEMP = {CIN, A[7:0]};                              //Set to A, a dummy move to itself
                  end
    endcase 
        
        RESULT = TEMP[7:0];                                //Assign result and C and Z FLAGS

        if (TEMP[7:0] == 7'b0)
            Z = 1;
        else
            Z = 0;

        if (TEMP[8] == 1)
            C = 1;
        else 
            C = 0;
        C = TEMP[8];                                       //Always assign carry bit
        
end
  
    
endmodule
