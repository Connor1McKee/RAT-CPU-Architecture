`timescale 1ns / 1ps


module RATMCU(
    input [7:0] IN_PORT,
    input RESET,
    input INTR,
    input CLK,
    output logic [7:0] OUT_PORT,
    output logic [7:0] PORT_ID,
    output IO_STRB
    );
       
//PC INTERMEDIATES
logic RST; logic [1:0] PC_MUX_SEL; logic [9:0] PC_COUNT; logic [9:0] PC_DIN;
  
//PROG_ROM
logic [17:0] IR;
   
//REG FILE
logic RF_WR; logic [7:0] DX_OUT; logic [7:0] DY_OUT; logic [7:0] DIN; logic [7:0] B_INTER;
 
// RF WR MUX
logic [1:0] RF_WR_SEL;
  
//ALU
logic CIN; logic [3:0] ALU_SEL; logic [7:0] RESULT; logic [7:0] A; logic [7:0] B_ALU; logic C; logic Z;
  
//ALU MUX
logic ALU_OPY_SEL;

//SCRATCH RAM
logic [9:0] SCR_DATA_OUT; logic [9:0] SCR_DATA_IN; logic [1:0] SCR_ADDR_SEL; logic [7:0] SCR_ADDR;


//FLAGS
logic FLG_Z_LD, Z_FLAG, FLG_LD_SEL, FLG_SHAD_LD;
logic FLG_C_SET, FLG_C_LD, C_FLAG, FLG_C_CLR;

//INTERRUPT REG
logic I_SET, I_CLR, INTERRUPT_INTER;

//CONTROL UNIT
logic PC_LD, PC_INC, SCR_WE, 
      SCR_DATA_SEL;  
      
//STACK POINTER
logic SP_LD, SP_INCR, SP_DECR;
      
//assign consts and intermediates top level      
assign OUT_PORT = DX_OUT;
assign PORT_ID = IR[7:0];

//MUXES--------------------------------------------------
always_comb begin
    //ALU MUX
    case(ALU_OPY_SEL)
        1'b0 : begin
            B_ALU = DY_OUT;
        end
        
        1'b1 : begin
            B_ALU = IR[7:0];
        end
    endcase
end 

always_comb begin    
    //REG MUX
    case(RF_WR_SEL)
        2'b00 : begin
            DIN = RESULT;
        end
        2'b01 : begin
            DIN = SCR_DATA_OUT[7:0];
        end
        2'b10 : begin
             DIN = B_INTER;         //FROM STACK POINTER
        end
        2'b11 : begin
             DIN = IN_PORT;
        end
    endcase
end

always_comb begin    
    //SCRATCH RAM ADDR MUX
    case(SCR_ADDR_SEL)
        2'b00 : begin
            SCR_ADDR = DY_OUT;
        end
        2'b01 : begin
            SCR_ADDR = IR[7:0];
        end
        2'b10 : begin
            SCR_ADDR = B_INTER;
        end
        2'b11 : begin
           SCR_ADDR = B_INTER - 1'b1;  //check this
        end
        default: SCR_ADDR = 8'b0;
    endcase
end
    
always_comb begin
    //SCRATCH RAM DATA_IN MUX
    case(SCR_DATA_SEL)
        1'b0 : begin
            SCR_DATA_IN = {2'b00, DX_OUT};
        end
        1'b1 : begin
            SCR_DATA_IN = PC_COUNT;
        end
        default: SCR_DATA_IN = 10'b0;
    endcase

end    
//-------------------------------------------------------

ScrRam scratchram(
    .DATA_IN(SCR_DATA_IN),
    .SCR_ADDR(SCR_ADDR),
    .SCR_WE(SCR_WE),
    .CLK(CLK),
    .DATA_OUT(SCR_DATA_OUT)
);

Stack_Pointer SP(
    .DATA_IN(DX_OUT),
    .RST(RST),
    .SP_LD(SP_LD),
    .SP_INCR(SP_INCR),
    .SP_DECR(SP_DECR),
    .CLK(CLK),
    .DATA_OUT(B_INTER)
);


FLAGS flags(
    .FLG_C_SET(FLG_C_SET), 
    .FLG_C_CLR(FLG_C_CLR), 
    .FLG_C_LD(FLG_C_LD), 
    .C_FLAG(C_FLAG), 
    .C(C),
    .CLK(CLK),
    .FLG_Z_LD(FLG_Z_LD),
    .FLG_SHAD_LD(FLG_SHAD_LD),
    .FLG_LD_SEL(FLG_LD_SEL),
    .Z_FLAG(Z_FLAG),
    .Z(Z)
);

ALU ALU(
    .A(DX_OUT),
    .B(B_ALU),
    .CIN(C_FLAG),
    .RESULT({RESULT[7:0]}),
    .C(C),
    .Z(Z),
    .SEL(ALU_SEL)
);
    
ProgROM prog(
    .PROG_CLK(CLK),
    .PROG_ADDR(PC_COUNT),
    .PROG_IR(IR)
);  

ProgCounter pc(
    .RST(RST),
    .PC_LD(PC_LD),
    .PC_INC(PC_INC),
    .DIN(PC_DIN),
    .PC_COUNT(PC_COUNT),
    .CLK(CLK)
);

MUX pcMUX(
    .PC_MUX_SEL(PC_MUX_SEL),
    .FROM_STACK(SCR_DATA_OUT),
    .FROM_IMMED(IR[12:3]),
    .DIN(PC_DIN)
);

RegFile regfile(
    .DIN(DIN),
    .RF_WR(RF_WR),
    .ADDRX(IR[12:8]),
    .ADDRY(IR[7:3]),
    .CLK(CLK),
    .DX_OUT(DX_OUT),
    .DY_OUT(DY_OUT)
);

InterruptReg IntrReg(
.I_SET(I_SET), 
.I_CLR(I_CLR),
.INTERRUPT(INTR),
.CLK(CLK),
.INTER_OUT(INTERRUPT_INTER)
);

ControlUnit_Template controlunit(
    .CLK(CLK),
    .C(C_FLAG),
    .Z(Z_FLAG),
    .RESET(RESET),
    .OPCODE_HI_5(IR[17:13]),
    .OPCODE_LO_2(IR[1:0]),
    .INTR(INTERRUPT_INTER),
    .I_SET(I_SET), 
    .I_CLR(I_CLR),
    .PC_LD(PC_LD),
    .PC_INC(PC_INC),
    .PC_MUX_SEL(PC_MUX_SEL),
    .ALU_OPY_SEL(ALU_OPY_SEL),
    .ALU_SEL(ALU_SEL),
    .SP_LD(SP_LD),
    .SP_INCR(SP_INCR),
    .SP_DECR(SP_DECR),
    .SCR_WE(SCR_WE),
    .SCR_ADDR_SEL(SCR_ADDR_SEL),
    .SCR_DATA_SEL(SCR_DATA_SEL),
    .RST(RST),
    .RF_WR(RF_WR),
    .RF_WR_SEL(RF_WR_SEL),
    .FLG_C_SET(FLG_C_SET),
    .FLG_C_CLR(FLG_C_CLR),
    .FLG_C_LD(FLG_C_LD),
    .FLG_Z_LD(FLG_Z_LD),
    .FLG_LD_SEL(FLG_LD_SEL),
    .FLG_SHAD_LD(FLG_SHAD_LD),
    .IO_STRB(IO_STRB)
);
     
endmodule
