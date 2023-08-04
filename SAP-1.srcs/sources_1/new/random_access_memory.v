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
  input [7:0] data_in, // 8-bit data input
  input clk,
  input write_enable, // write enable input
  input output_enable,
  output reg [7:0] q // 8-bit data output
);

  reg [7:0] memory [15:0]; // memory array, 16 8-bit locations

  always @(posedge clk) begin
    if(write_enable) begin
      memory[addr] <= data_in; // write operation
    end else begin
      // output what's in memory if output_enable, else high z
      q <= output_enable ? memory[addr] : 8'bz; 
    end
  end

endmodule

