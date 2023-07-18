`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2023 07:34:31 PM
// Design Name: 
// Module Name: random_access_memory
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


module random_access_memory(
  input [3:0] addr, // 4-bit address input
  input [7:0] data, // 8-bit data input
  input clk,
  input we, // write enable input
  output reg [7:0] q // 8-bit data output
);

  reg [7:0] memory [15:0]; // memory array, 16 8-bit locations

  always @(posedge clk) begin
    if(we) begin
      memory[addr] <= data; // write operation
    end else begin
      q <= memory[addr]; // read operation
    end
  end

endmodule

