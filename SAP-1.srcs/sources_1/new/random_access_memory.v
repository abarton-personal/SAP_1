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

    initial begin
        // Set the initial RAM values 
        //instructions
        memory[4'h0] = 8'b00001000; // LDA from address 8
        memory[4'h1] = 8'b00011001; // ADD that to address 9
        memory[4'h2] = 8'b11100000; // Output the result
        memory[4'h3] = 8'b11110000; // halt
        
        //data
        memory[4'h8] = 8'd13; // value in address 8
        memory[4'h9] = 8'd10; 
        memory[4'hA] = 8'd1; 
        memory[4'hB] = 8'hBB; 
        memory[4'hC] = 8'h26; 
        memory[4'hD] = 8'hDD; 
        memory[4'hE] = 8'hEE; 
        memory[4'hF] = 8'hFF;
        // ... repeat for other addresses
    end
    

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

