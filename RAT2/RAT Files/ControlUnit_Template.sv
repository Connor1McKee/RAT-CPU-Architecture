`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: 
// Date:
// Description: Controls the RAT CPU
//////////////////////////////////////////////////////////////////////////////////

module ControlUnit_Template(
  input CLK,
  input C,
  input Z,
  input INTR,
  input RESET,
  input [4:0] OPCODE_HI_5,
  input [1:0] OPCODE_LO_2,
  
  output logic PC_INC,
  output logic RST,
  output logic I_SET,
  output logic I_CLR,
  output logic ALU_OPY_SEL,
  output logic [3:0] ALU_SEL,
  output logic PC_LD,
  output logic [1:0] PC_MUX_SEL,
  output logic RF_WR,
  output logic [1:0] RF_WR_SEL,
  output logic SP_LD,
  output logic SP_INCR,
  output logic SP_DECR,
  output logic SCR_WE,
  output logic [1:0] SCR_ADDR_SEL,
  output logic SCR_DATA_SEL,
  output logic FLG_C_SET,
  output logic FLG_C_CLR,
  output logic FLG_C_LD,
  output logic FLG_Z_LD,
  output logic FLG_LD_SEL,
  output logic FLG_SHAD_LD,
  output logic IO_STRB
  );

  // Define States -----------------------------------------
  typedef enum {ST_FETCH, ST_EXEC, ST_INIT, ST_INTRPT} STATES; 
  STATES NS, PS = ST_INIT;
  //--------------------------------------------------------

  //concatenate opcode bits---------------------------------
  logic [6:0] s_opcode;
  assign s_opcode = {OPCODE_HI_5,OPCODE_LO_2};
  //--------------------------------------------------------


  // Synchronous State Changes -----------------------------
  always_ff @ (posedge CLK)
    begin
      if (RESET == 1'b1)
        PS <= ST_INIT;
      else
        PS <= NS;
    end
  //---------------------------------------------------------  

  always_comb
    begin

      //INITIALIZE OUTPUTS
      I_SET = 0;
      I_CLR = 0;
      PC_LD = 0;
      PC_INC = 0;
      PC_MUX_SEL = 2'b00;
      ALU_OPY_SEL = 0;
      ALU_SEL = 3'b000;
      RF_WR = 0;
      RF_WR_SEL = 2'b00;
      SP_LD = 0;
      SP_INCR = 0;
      SP_DECR = 0;
      SCR_WE = 0;
      SCR_ADDR_SEL = 2'b00;
      SCR_DATA_SEL = 0;
      FLG_C_SET = 0;
      FLG_C_CLR = 0;
      FLG_C_LD = 0;
      FLG_Z_LD = 0;
      FLG_LD_SEL = 0;
      FLG_SHAD_LD = 0;
      RST = 0;
      IO_STRB = 0;
      
      //START
      case (PS)
        ST_INIT: begin                      // INITIAL STATE
          NS = ST_FETCH;
          RST = 1'b1;
        end
        

        ST_FETCH: begin                     // FETCH STATE
          NS = ST_EXEC;
          PC_INC = 1'b1;
        end
        
        ST_INTRPT : begin                   // INTERRUPT STATE
            NS = ST_FETCH;
            PC_LD = 1'b1;
            PC_MUX_SEL = 2'b10;             //set PC value to 0x3FF
            SCR_DATA_SEL = 1'b1;
            SCR_WE = 1'b1;
            SCR_ADDR_SEL = 2'b11;           //selected SP-1 address
            SP_DECR = 1'b1;                 //decrement since current PC val pushed onto stack
            I_CLR = 1'b1;
            FLG_SHAD_LD = 1'b1;
        end
        
        

        ST_EXEC: begin                      // EXECUTE STATE
            
                  

          case (s_opcode)
			//ADD - REG-REG
            7'b0000100: begin
                RF_WR = 1'b1;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
			end
			
			//ADD - REG-IMMED
			7'b1010000, 7'b1010001, 7'b1010010, 7'b1010011: begin
                RF_WR = 1'b1;
                ALU_OPY_SEL = 1'b1;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
           end
           
           //ADDC - REG-REG
           7'b0000101: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b0001;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
           end
           
           //ADDC - REG-IMMED
           7'b1010100, 7'b1010101, 7'b1010110, 7'b1010111: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b0001;
                ALU_OPY_SEL = 1'b1;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
           end
           
           //AND - REG-REG
           7'b0000000: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b0101;
                FLG_C_CLR = 1'b1;
                FLG_Z_LD = 1'b1;
           end
           
           //AND - REG-IMMED
           7'b1000000, 7'b1000001, 7'b1000010, 7'b1000011: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b0101;
                ALU_OPY_SEL = 1'b1;
                FLG_C_CLR = 1'b1;
                FLG_Z_LD = 1'b1;
           end
           
           //ASR - REG
           7'b0100100: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b1101;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
           end
           
           //BRCC 
           7'b0010101: begin
                if (C == 1'b0)                   //Check for No Carry
                    PC_LD = 1'b1;
           end
          
           //BRCS 
           7'b0010100: begin
                if (C == 1'b1)                  //Check for Carry Set
                    PC_LD = 1'b1;
           end
           
           //BREQ 
           7'b0010010: begin
                if (Z == 1'b1)                 //Check for Zeroed Number
                    PC_LD = 1'b1;
           end
           
			
			//BRN
            7'b0010000: begin 			
                PC_LD = 1'b1;
            end
            
            //BRNE 
            7'b0010011: begin
                if (Z == 1'b0)                 //Check for non-zero
                    PC_LD = 1'b1;
            end
            
            //CALL
            7'b0010001: begin
                 SCR_DATA_SEL = 1'b1;          //get pc count
                 SCR_ADDR_SEL = 2'b11;         //put pc count at sp val - 1
                 SCR_WE = 1'b1;
                 SP_DECR = 1'b1;               //update pointer
                 PC_LD = 1'b1;                 //load to instruction
                                               //decrement and load
            end
            
            //CLC
            7'b0110000: begin
                FLG_C_CLR = 1'b1;
            end
            
            //CLI
            7'b0110101 : begin
                I_CLR = 1'b1;
            end
            
            //CMP - REG-REG
            7'b0001000: begin
              ALU_SEL = 4'b0100;
              FLG_Z_LD = 1'b1;
              FLG_C_LD = 1'b1;  
            end
            
            //CMP - REG-IMMED
            7'b1100000, 7'b1100001, 7'b1100010, 7'b1100011: begin
                ALU_SEL = 4'b0100;
                ALU_OPY_SEL = 1'b1;
                FLG_Z_LD = 1'b1;
                FLG_C_LD = 1'b1;  
            end
            
            //EXOR - REG-REG
            7'b0000010: begin
              RF_WR = 1'b1;
              ALU_SEL = 4'b0111;
              FLG_Z_LD = 1'b1;
              FLG_C_CLR = 1'b1;
            end
            
            //EXOR - REG - IMMED
            7'b1001000, 7'b1001001, 7'b1001010, 7'b1001011: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b0111;
                ALU_OPY_SEL = 1'b1;
                FLG_Z_LD = 1'b1;
                FLG_C_CLR = 1'b1;
            end
            
            //IN
            7'b1100100, 7'b1100101, 7'b1100110, 7'b1100111: begin
                RF_WR = 1'b1; 
                RF_WR_SEL = 2'b11;
            end
            
            //LD - REG-REG
            7'b0001010: begin
                RF_WR = 1'b1;
                RF_WR_SEL = 2'b01;              //data from scratch memory
                SCR_ADDR_SEL = 2'b00;           //data at address = dy_out
            end
            
            //LD - REG-IMMED
            7'b1110000, 7'b1110001, 7'b1110010, 7'b1110011: begin
                RF_WR = 1'b1;
                RF_WR_SEL = 2'b01;
                SCR_ADDR_SEL = 2'b01;            
            end
            
            //LSL 
            7'b0100000: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b1001;
                FLG_Z_LD = 1'b1;
                FLG_C_LD = 1'b1;
            end
            
            //LSR
            7'b0100001: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b1010;
                FLG_Z_LD = 1'b1;
                FLG_C_LD = 1'b1;
            end
            
            
            //MOV - REG - REG
            7'b0001001: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b1110;
            end
            
            //MOV - REG - IMMED
            7'b1101100, 7'b1101101, 7'b1101110, 7'b1101111: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b1110;
                ALU_OPY_SEL = 1'b1;
            end
            
            //OR - REG-REG
            7'b0000001: begin
               RF_WR = 1'b1;
               ALU_SEL = 4'b0110; 
               FLG_C_CLR = 1'b1;
               FLG_Z_LD = 1'b1;
            end
            
            //OR - REG-IMMED
            7'b1000100, 7'b1000101, 7'b1000110, 7'b1000111: begin
                 RF_WR = 1'b1;
                 ALU_SEL = 4'b0110;
                 ALU_OPY_SEL = 1'b1; 
                 FLG_C_CLR = 1'b1;
                 FLG_Z_LD = 1'b1;
            end
            
            //OUT
            7'b1101000, 7'b1101001, 7'b1101010, 7'b1101011: begin
                IO_STRB = 1'b1;
            end
            
            //POP
            7'b0100110: begin
                RF_WR = 1'b1;
                RF_WR_SEL = 2'b01;
                SCR_ADDR_SEL = 2'b10;
                SP_INCR =   1'b1;
            end
            
            //PUSH
            7'b0100101: begin
                SCR_WE = 1'b1;
                SCR_ADDR_SEL = 2'b11;
                SP_DECR = 1'b1;
            end
            
            //RET
            7'b0110010: begin
                PC_LD = 1'b1;
                PC_MUX_SEL = 2'b01;
                SCR_ADDR_SEL = 2'b10;
                SP_INCR = 1'b1;
            end
            
            //RETIE
            7'b0110111 : begin
                PC_LD = 1'b1;
                PC_MUX_SEL = 2'b01;
                SCR_ADDR_SEL = 2'b10;
                SP_INCR = 1'b1;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
                I_SET = 1'b1;
                FLG_LD_SEL = 1'b1;
            end
            
            //RETID
            7'b0110110 : begin
                PC_LD = 1'b1;
                PC_MUX_SEL = 2'b01;
                SCR_ADDR_SEL = 2'b10;
                SP_INCR = 1'b1;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
                I_CLR = 1'b1;           //may not be needed since interrupts are cleared in the interrupt state
                FLG_LD_SEL = 1'b1;
            end
            
            
            //ROL
            7'b0100010: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b1011;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
            end
            
            //ROR
            7'b0100011: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b1100;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
            end
            
            //SEC
            7'b0110001: begin
                FLG_C_SET = 1'b1;
            end
            
            //SEI
            7'b0110100 : begin
                I_SET = 1'b1;
            end
            
            //ST - REG-REG
            7'b0001011: begin
                SCR_WE = 1'b1;
            end
            
            //ST - REG-IMMED
            7'b1110100, 7'b1110101, 7'b1110110, 7'b1110111: begin
                SCR_WE = 1'b1;
                SCR_ADDR_SEL = 2'b01;
            end
            
            
            //SUB - REG-REG
            7'b0000110: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b0010;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
            end
            
            //SUB - REG-IMMED
            7'b1011000, 7'b1011001, 7'b1011010, 7'b1011011: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b0010;
                ALU_OPY_SEL = 1'b1;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
            end
            
            //SUBC - REG-REG
			7'b0000111: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b0011;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
            end
            
            //SUBC - REG-IMMED
            7'b1011100, 7'b1011101, 7'b1011110, 7'b1011111: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b0011;
                ALU_OPY_SEL = 1'b1;
                FLG_C_LD = 1'b1;
                FLG_Z_LD = 1'b1;
            end		
            
            //TEST - REG-REG
            7'b0000011: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b1000;
                FLG_Z_LD = 1'b1;
                FLG_C_CLR = 1'b1;
            end
            
            //TEST - REG-IMMED
            7'b1001100, 7'b1001101, 7'b1001110, 7'b1001111: begin
                RF_WR = 1'b1;
                ALU_SEL = 4'b1000;
                ALU_OPY_SEL = 1'b1;
                FLG_Z_LD = 1'b1;
                FLG_C_CLR = 1'b1;
            end
            
            //WSP
            7'b0101000: begin
                SP_LD = 1'b1;
            end
            
            
          endcase
                                                //SELECT INTERRUPT STATE
          if(INTR == 1)
              NS = ST_INTRPT;
          else
              NS = ST_FETCH; 
        end

        default:  
          NS = ST_INIT;

      endcase
    end

endmodule
