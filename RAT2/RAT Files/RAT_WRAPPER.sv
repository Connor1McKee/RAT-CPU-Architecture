`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Paul Hummel
//
// Create Date: 06/28/2018 05:21:01 AM
// Module Name: RAT_WRAPPER
// Target Devices: RAT MCU on Basys3
// Description: Basic RAT_WRAPPER
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////

module RAT_WRAPPER(
    input CLK,
    input BTNC,
    input MODE_BTN,
    input DBOS_BTN,
    //input [7:0] PMOD,
    input [7:0] SWITCHES,
    output [7:0] LEDS,
    output [7:0] CATHODES,
    output [3:0] ANODES
    //output [7:0] SSEG
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_ID = 8'h20;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam LEDS_ID      = 8'h40;
    localparam SSEG_ID      = 8'h81;
       
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] s_output_port;
    logic [7:0] s_port_id;
    logic s_load;
    logic s_interrupt;
    logic s_reset;
    logic s_clk_50 = 1'b0;     // 50 MHz clock
    
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   s_input_port;
    logic [7:0]   r_leds = 8'h00;
    logic [7:0]   r_sseg = 8'h00;
    logic [7:0]   SSEG;

    // Declare RAT_CPU ///////////////////////////////////////////////////////
    RATMCU MCU (.IN_PORT(s_input_port), .OUT_PORT(s_output_port),
                .PORT_ID(s_port_id), .IO_STRB(s_load), .RESET(s_reset), 
                .INTR(s_interrupt), .CLK(s_clk_50));
                
    SevSegDisp sevseg(.CLK(s_clk_50), .MODE(MODE_BTN), .DATA_IN({8'b0,SSEG[7:0]}), 
    .CATHODES(CATHODES), .ANODES(ANODES));
    
    debounce_one_shot dbos(.CLK(s_clk_50), .BTN(DBOS_BTN),
     .DB_BTN(s_interrupt));
    
    // Clock Divider to create 50 MHz Clock //////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end
    
     
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (s_port_id == SWITCHES_ID)
            s_input_port = SWITCHES;
//        else if (s_port_id == SSEG_ID)  //pmod id??
//            s_input_port = PMOD;
        else
            s_input_port = 8'h00;
    end
    
    // MUX for selecting the output
//    always_comb begin
//        if (s_port_id == SSEG_ID) begin
//            r_sseg = s_output_port;
//        end
//        else if (s_port_id == LEDS_ID) begin
//            //r_mux_sseg = 8'b0; 
//            r_leds = s_output_port;
//        end
//    end
   
    // MUX for updating output registers /////////////////////////////////////
    // Register updates depend on rising clock edge and asserted load signal
//    always_ff @ (posedge CLK) begin
//        if (s_load == 1'b1) begin
//            if (s_port_id == LEDS_ID)
//                r_leds <= s_output_port;

//            else if (s_port_id == SSEG_ID)
//                r_sseg <= s_output_port;
            
//        end
//    end
    
        always_ff @ (posedge CLK) begin
        if (s_load == 1'b1) begin
            case(s_port_id)
                LEDS_ID : begin
                    r_leds <= s_output_port;
                end
                SSEG_ID : begin
                    r_sseg <= s_output_port;
                end
            endcase  
        end
    end

    
     
    // Connect Signals ///////////////////////////////////////////////////////
    assign s_reset = BTNC;
     
    // Output Assignments ////////////////////////////////////////////////////
    assign LEDS = r_leds;
    assign SSEG = r_sseg;
   
    endmodule
