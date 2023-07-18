`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2023 03:56:49 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input clock,
    output reg [3:0] out_to_bus,
    input clr,
    input en
    );
    
    reg [3:0] counter;

    always @(posedge clock) begin
        if (clr)
            counter <= 4'b0000;
        else if (en)
            counter <= counter + 1;
            
        if (clr)
            out_to_bus <= 4'b0000;
        else
            out_to_bus <= counter;
    end
    
endmodule





















