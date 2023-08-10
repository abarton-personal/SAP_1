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
    input wire clr,
    input wire [7:0] data_in, // instruction from RAM
    input wire load,          // signal to load instruction from RAM
    input wire output_enable,
    output wire [3:0] opcode, // the upper nibble (opcode) - to control sequencer
    output reg [3:0] operand // the lower nibble (operand) - to bus
);

    // 8-bit register to store the instruction
    reg [7:0] instr_reg;

    // Process the instruction on positive edge of clock or clr
    always @(posedge clk or posedge clr) begin
        if (clr)
            instr_reg <= 8'b00000000; // Reset instruction register
        else if (load)
            instr_reg <= data_in; // Load new instruction from RAM
        
    end
    
    always @(posedge clk) begin
        if(output_enable)
            operand <= instr_reg[3:0];            
        else 
            operand <= 4'bz;
    end
    
    // opcode is always active
    assign opcode = instr_reg[7:4];

endmodule
