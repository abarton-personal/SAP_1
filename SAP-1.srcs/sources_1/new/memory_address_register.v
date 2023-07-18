`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2023 04:21:06 PM
// Design Name: 
// Module Name: memory_address_register
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



    
module memory_address_register(
    input wire clk,
    input wire load,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);

always @(posedge clk) begin
    if (load) begin
        data_out <= data_in;
    end
end

endmodule
















