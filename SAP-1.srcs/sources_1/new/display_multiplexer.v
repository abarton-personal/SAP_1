`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2023 05:37:39 PM
// Design Name: 
// Module Name: display_multiplexer
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


module display_multiplexer(
    input [3:0] data0, // 4-bit input for the first display
    input [3:0] data1, // 4-bit input for the second display
    input [3:0] data2, // 4-bit input for the third display
    input [3:0] data3, // 4-bit input for the fourth display
    input [3:0] data7, // 4-bit input for the fourth display
    input clk,             // clock signal
    output wire [6:0] seg,  // 7-segment output
    output wire [3:0] AN,    // Anode selection output
    output wire AN7    // Anode selection output
);

    // Counter for cycling through the displays
    reg [2:0] display_select = 3'b000;
    always @(posedge clk) begin
        display_select <= display_select + 1'b1;
    end

    wire [6:0] segs [4:0]; // Four 7-segment outputs, one for each digit

    // Create four instances of the seven_segment module
    seven_segment seg0 (.data(data0), .seg(segs[0]));
    seven_segment seg1 (.data(data1), .seg(segs[1]));
    seven_segment seg2 (.data(data2), .seg(segs[2]));
    seven_segment seg3 (.data(data3), .seg(segs[3]));
    
    seven_segment seg7 (.data(data7), .seg(segs[4])); 

    // Multiplex the seg outputs
    assign seg = (display_select == 0) ? segs[0] :
                 (display_select == 1) ? segs[1] :
                 (display_select == 2) ? segs[2] : 
                 (display_select == 3) ? segs[3] : segs[4];

    // Update the anode selection based on the counter
    // Use a continuous assignment for AN
    assign AN[0] = (display_select == 0) ? 1'b0 : 1'b1;
    assign AN[1] = (display_select == 1) ? 1'b0 : 1'b1;
    assign AN[2] = (display_select == 2) ? 1'b0 : 1'b1;
    assign AN[3] = (display_select == 3) ? 1'b0 : 1'b1;
    assign AN7   = (display_select == 4) ? 1'b0 : 1'b1;
endmodule
