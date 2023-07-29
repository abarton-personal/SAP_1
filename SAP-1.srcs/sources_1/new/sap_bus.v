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
    input clk,
    input BTNC,
    input BTNU,
    input BTND,
    input BTNL,
    input BTNR,
    output [3:0] LED,
    input [11:0] SW,
    output [6:0] cat,
    output [7:0] AN_out,
    output DP
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
    
    

//    //connects program counter to MAR.
//    wire [3:0] pc_to_mar;

//    // Instantiate program_counter module
//    program_counter PC (
//        .clock(slow_clk),
//        .out_to_bus(pc_to_mar),
//        .clr(clr),
//        .en(en)
//    );

    
//    memory_address_register MAR (
//        .clk(slow_clk),
//        .load(BTND),
//        .data_in(pc_to_mar),
//        .data_out(LED)
//    );

//    wire[7:0] ram_read;
//    random_access_memory RAM(
//      .addr(SW[3:0]), // 4-bit address input
//      .data(SW[11:4]), // 8-bit data input
//      .clk(slow_clk),
//      .we(en), // write enable input
//      .q(ram_read) // 8-bit data output
//    );


    register register_a(
        .data_in(SW[7:0]),
        .clk(slow_clk),
        .load(BTNL),
        .output_enable(BTNR),
        .data_out(mybus)
    );
    
    register register_b(
        .data_in(SW[7:0]),
        .clk(slow_clk),
        .load(BTNU),
        .output_enable(BTND),
        .data_out(mybus)
    );



    wire[7:0] AN;
    // AN[7:4] are unused, hard code to '1'
    assign AN[7:4] = 4'b1111;
    assign AN_out = AN;



    // Split the switch inputs into four 4-bit values
//    wire [3:0] seg_data0 = ram_read[3:0];
//    wire [3:0] seg_data1 = ram_read[7:4];
    wire [7:0] mybus;
    wire [3:0] seg_data2 = SW[3:0]; // Placeholder - set to whatever you want to display on the third digit
    wire [3:0] seg_data3 = SW[7:4]; // Placeholder - set to whatever you want to display on the fourth digit

    
  display_multiplexer disp_mux (
        .data0(mybus[3:0]),
        .data1(mybus[7:4]),
        .data2(seg_data2),
        .data3(seg_data3),
        .clk(refresh_clk),
        .seg(cat),
        .AN(AN[3:0]) // Connect the first 3 bits of AN to the anodes of the displays
    );

    

    // Other logic of your top-level design

endmodule
