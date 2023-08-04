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
    output [3:0] LED,   //green LEDs above switches
    input [11:0] SW,    //switches
    output [6:0] cat,   //7 seg cathodes, one for each segment (shared by all digits)
    output [7:0] AN_out,    //7 seg anodes, one for each digit
    output DP           //decimal point cathode
    );
        


    reg [24:0] count = 0;
    // Create a slower clock by dividing the original clock
    wire slow_clk;      
    assign slow_clk = count[24];  
    // Create a seven segment refresh clock, ~60Hz
    wire refresh_clk;        
    assign refresh_clk = count[17];
    
    always @ (posedge(clk)) begin
        count <= count + 1;
    end
    
    // visualize the clock
    assign LED[0] = slow_clk;
    
    
    //wires used for 7 segment displays
    
    wire[7:0] AN;
    // AN[7:4] are unused, hard code to '1'
    assign AN[7:4] = 4'b1111;
    assign AN_out = AN;
    
    // Split the switch inputs into four 4-bit values
//    wire [3:0] seg_data0 = ram_read[3:0];
//    wire [3:0] seg_data1 = ram_read[7:4];
    wire [3:0] seg_data2 = SW[3:0]; // Placeholder - set to whatever you want to display on the third digit
    wire [3:0] seg_data3 = SW[7:4]; // Placeholder - set to whatever you want to display on the fourth digit
    
    // THE BUS
    wire [7:0] mybus;

    
    // control signals
    wire pc_oe;
    wire pc_inc;
    wire mar_load;
    wire ram_oe;
    wire ram_we;
    wire reset;
    wire reg_a_load;
    wire reg_b_load;
    wire reg_a_oe;
    wire reg_b_oe;
    wire sub;
    wire adder_oe;
    
    

    // Instantiate program_counter module
    program_counter PC (
        .clock(slow_clk),
        .out_to_bus(mybus[3:0]),
        .clr(reset),
        .output_enable(pc_oe),
        .increment(pc_inc)
    );

    // from MAR to RAM
    wire [3:0] next_address;
    
    memory_address_register MAR (
        .clk(slow_clk),
        .load(mar_load),
        .clr(reset),
        .data_in(mybus[3:0]),
        .data_out(next_address)
    );

    random_access_memory RAM(
      .addr(next_address), // 4-bit address input
      .data_in(mybus), // 8-bit data input
      .clk(slow_clk),
      .write_enable(ram_we), // write enable input
      .output_enable(ram_oe),
      .q(mybus) // 8-bit data output
    );

    // feeds directly from registers to adder
    wire[7:0] reg_a;
    wire[7:0] reg_b;
    
    register register_a(
        .data_in(mybus),
        .clk(slow_clk),
        .clr(reset),
        .load(reg_a_load),
        .output_enable(reg_a_oe),
        .data_out(reg_a),
        .data_out_gated(mybus)
    );
    
    register register_b(
        .data_in(mybus),
        .clk(slow_clk),
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
        .Eu(adder_oe),             // Enable output control
        .result_out(mybus)    // Output
    );





    
  display_multiplexer disp_mux (
        .data0(mybus[3:0]),
        .data1(mybus[7:4]),
        .data2(seg_data2),
        .data3(seg_data3),
        .clk(refresh_clk),
        .seg(cat),
        .AN(AN[3:0]) // Connect the first 3 bits of AN to the anodes of the displays
    );

 

endmodule
