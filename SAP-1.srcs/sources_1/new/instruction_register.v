`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2023 06:48:07 PM
// Design Name: 
// Module Name: instruction_register
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


module instruction_register(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in, // instruction from RAM
    input wire load,          // signal to load instruction from RAM
    output wire [7:0] data_out, // instruction to the control unit
    output wire [3:0] opcode, // the upper nibble (opcode)
    output wire [3:0] operand // the lower nibble (operand)
);

    // 8-bit register to store the instruction
    reg [7:0] instr_reg;

    // Process the instruction on positive edge of clock or reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            instr_reg <= 8'b00000000; // Reset instruction register
        else if (load)
            instr_reg <= data_in; // Load new instruction from RAM
    end

    // Assign the output
    assign data_out = instr_reg;
    assign opcode = instr_reg[7:4]; // upper nibble
    assign operand = instr_reg[3:0]; // lower nibble
endmodule
