`timescale 1ns / 1ps


module FLAGS(
    input FLG_C_SET,
    input FLG_C_CLR,
    input FLG_C_LD,
    input FLG_Z_LD,
    input FLG_SHAD_LD,
    input FLG_LD_SEL,
    input C,
    input Z,
    output logic C_FLAG,
    output logic Z_FLAG,
    input CLK
    );
    
// INTERMEDIATES -----------------------------
logic Cin, Zin, SHAD_Z_IN, SHAD_C_IN, SHAD_C_OUT, SHAD_Z_OUT;

assign SHAD_Z_IN = Z_FLAG;
assign SHAD_C_IN = C_FLAG;

// C FLAG MUX --------------------------------
always_comb begin
    if(FLG_LD_SEL == 1'b1) 
        Cin = SHAD_C_OUT;
    else
        Cin = C;
end

// Z FLAG MUX ---------------------------------
always_comb begin
    if(FLG_LD_SEL == 1'b1) 
        Zin = SHAD_Z_OUT;
    else
        Zin = Z;
end


// FLAG REG'S ---------------------------------    
always_ff @(posedge CLK) begin
    if(FLG_SHAD_LD == 1)
        SHAD_C_OUT = SHAD_C_IN;
end

always_ff @(posedge CLK) begin
    if(FLG_SHAD_LD == 1)
        SHAD_Z_OUT = SHAD_Z_IN;
end

always_ff @(posedge CLK) begin
    if(FLG_Z_LD == 1)
        Z_FLAG <= Zin;
    end

always_ff @(posedge CLK) begin
    if (FLG_C_CLR == 1)
        C_FLAG <= 0;
    else if (FLG_C_SET == 1)
        C_FLAG <= 1;
    else if (FLG_C_LD == 1)
        C_FLAG <= Cin;
end
  
endmodule
