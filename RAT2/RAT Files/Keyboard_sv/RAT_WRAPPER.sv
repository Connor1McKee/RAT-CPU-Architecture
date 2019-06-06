`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Paul Hummel
//
// Create Date: 11/09/2018
// Module Name: RAT_WRAPPER
// Target Devices: RAT MCU on Basys3
// Description: RAT_WRAPPER with Keyboard connections
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////

module RAT_WRAPPER(
    input CLK,
    input BTNC,
    input [7:0] SWITCHES,
    input PS2CLK,
    input PS2DATA,
    output [7:0] LEDS,
    output [7:0] CATHODES,
    output [3:0] ANODES
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_ID = 8'h20;
    localparam KEYBOARD_ID = 8'h44;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam LEDS_ID      = 8'h40;
    localparam SSEG0_ID     = 8'h81;
    localparam SSEG1_ID     = 8'h82;

    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] s_output_port;
    logic [7:0] s_port_id;
    logic s_load;
    logic s_reset;
    logic s_clk_50 = 1'b0;     // 50 MHz clock
    
    // Signals for connecting Keyboard Driver
    logic [7:0] s_scancode;
    logic s_interrupt;
     
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   s_input_port;
    logic [7:0]   r_LEDS = 8'h00;
    logic [15:0]  r_SSEG = 16'h0000;
         
    // Declare RAT_CPU ///////////////////////////////////////////////////////
    RATMCU MCU (.IN_PORT(s_input_port), .OUT_PORT(s_output_port),
                .PORT_ID(s_port_id), .IO_STRB(s_load), .RESET(s_reset),
                .INTR(s_interrupt), .CLK(s_clk_50));
    
    // Declare Seven Segment Display /////////////////////////////////////////
    SevSegDisp SSG_DISP (.DATA_IN(r_SSEG), .CLK(CLK), .MODE(1'b0),
                        .CATHODES(CATHODES), .ANODES(ANODES));
    
    // Declare Keyboard Driver //////////////////////////////////////////////
    KeyboardDriver KEYBD (.CLK(CLK), .PS2DATA(PS2DATA), .PS2CLK(PS2CLK),
                          .INTRPT(s_interrupt), .SCANCODE(s_scancode));
  
    // Clock Divider to create 50 MHz Clock /////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end
     
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (s_port_id == SWITCHES_ID)
            s_input_port = SWITCHES;
        else if (s_port_id == KEYBOARD_ID)
            s_input_port = s_scancode;
        else
            s_input_port = 8'h00;
    end
   
    // MUX for updating output registers //////////////////////////////////////////
    // Register updates depend on rising clock edge and asserted load signal
    always_ff @ (posedge CLK) begin
        if (s_load == 1'b1) begin
             
            if (s_port_id == LEDS_ID)
                r_LEDS <= s_output_port;
            else if (s_port_id == SSEG0_ID)
                r_SSEG[7:0] <= s_output_port;
            else if (s_port_id == SSEG1_ID)
                r_SSEG[15:8] <= s_output_port;
        end
    end
 
    // Signal Assignments /////////////////////////////////////////////
    assign s_reset = BTNC;  
 
    // Register Interface Assignments /////////////////////////////////////////////
    assign LEDS = r_LEDS;
   
    endmodule
