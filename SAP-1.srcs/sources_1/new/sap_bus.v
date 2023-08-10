`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2023 04:13:38 PM
// Design Name: 
// Module Name: sap_bus
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




module sap_bus(
    input clk,  //internal clock, 500MHz
    input BTNC, //center 
    input BTNU, //up
    input BTND, //down
    input BTNL, //left
    input BTNR, //right
    output [15:0] LED,   //green LEDs above switches
    input [15:0] SW,    //switches
    output [6:0] cat,   //7 seg cathodes, one for each segment (shared by all digits)
    output [7:0] AN_out,    //7 seg anodes, one for each digit
    output DP           //decimal point cathode
    );
        


    reg [24:0] count = 0;
    // Create a slower clock by dividing the original clock
    wire slow_clk;    
    reg btn_clk;  
    assign slow_clk = count[24];      
    // Create a seven segment refresh clock, ~60Hz
    wire refresh_clk;        
    assign refresh_clk = count[17];
    
    always @ (posedge(clk)) begin
        count <= count + 1;        
    end
    
    always @ (posedge(slow_clk)) begin
        btn_clk <= BTNC;
    end
    
    // visualize the clock
    assign LED[0] = slow_clk;
    assign LED[1] = btn_clk;
    
    
    //wires used for 7 segment displays
    
    wire[7:0] AN;
    // AN[7:4] are unused, hard code to '1'
    assign AN[7:4] = 4'b1111;
    assign AN_out = AN;
    

    
    // THE BUS
    wire [7:0] mybus;
    
    
    
    // control signals
    wire pc_oe      = SW[0];
    wire pc_inc     = SW[1];
    wire mar_load   = SW[2];
    wire ram_oe     = SW[3];
    wire ram_we     = SW[4];   
    wire inst_load  = SW[5];
    wire inst_oe    = SW[6];
    wire reg_a_load = SW[7];
    wire reg_b_load = SW[8];
    wire reg_a_oe   = SW[9];
    wire reg_b_oe   = SW[10];
    wire sub        = SW[11];
    wire adder_oe   = SW[12];
    wire out_reg_load = SW[13];
  
    wire reset      = SW[14];
    
    

    // Instantiate program_counter module
    program_counter PC (
        .clock(btn_clk),
        .out_to_bus(mybus[3:0]),
        .clr(reset),
        .output_enable(pc_oe),
        .increment(pc_inc)
    );

    // memory address - from MAR to RAM
    wire [3:0] next_address;
    
    memory_address_register MAR (
        .clk(btn_clk),
        .load(mar_load),
        .clr(reset),
        .data_in(mybus[3:0]),
        .data_out(next_address)
    );

    random_access_memory RAM(
      .addr(next_address), // 4-bit address input
      .data_in(mybus), // 8-bit data input
      .clk(btn_clk),
      .write_enable(ram_we), // write enable input
      .output_enable(ram_oe),
      .q(mybus) // 8-bit data output
    );


    wire [3:0] opcode; //passes directly to control sequencer
    instruction_register IR(
        .clk(btn_clk),
        .clr(reset),
        .data_in(mybus), // instruction from RAM
        .load(inst_load),          // signal to load instruction from RAM
        .output_enable(inst_oe),
        .opcode(opcode), // the upper nibble (opcode) - to control sequencer
        .operand(mybus[3:0]) // the lower nibble (operand) - to bus
    );

    // feeds directly from registers to adder
    wire[7:0] reg_a;
    wire[7:0] reg_b;
    
    register register_a(
        .data_in(mybus),
        .clk(btn_clk),
        .clr(reset),
        .load(reg_a_load),
        .output_enable(reg_a_oe),
        .data_out(reg_a),
        .data_out_gated(mybus)
    );
    
    register register_b(
        .data_in(mybus),
        .clk(btn_clk),
        .clr(reset),
        .load(reg_b_load),
        .output_enable(reg_b_oe),
        .data_out(reg_b),
        .data_out_gated(mybus)
    );

    adder_subtractor add_sub(
        .inputA(reg_a),        // Input A
        .inputB(reg_b),        // Input B
        .Su(sub),             // Subtract control
        .Eu(adder_oe),        // Enable output control
        .result_out(mybus)    // Output
    );



    wire [7:0] out_to_seg;
    register output_register(
        .data_in(mybus),
        .clk(btn_clk),
        .clr(1'b0),
        .load(out_reg_load),
        .output_enable(1'b0),
        .data_out(out_to_seg),
        .data_out_gated(mybus)
    );

    
  display_multiplexer disp_mux (
        .data0(mybus[3:0]),
        .data1(mybus[7:4]),
        .data2(out_to_seg[3:0]),
        .data3(out_to_seg[7:4]),
        .clk(refresh_clk),
        .seg(cat),
        .AN(AN[3:0]) // Connect the first 3 bits of AN to the anodes of the displays
    );

 

endmodule
