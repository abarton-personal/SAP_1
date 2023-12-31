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
    output [3:0] out_to_disp,
    input clr,
    input output_enable,
    input increment
    );
    
    reg [3:0] counter;

    always @(posedge clock) begin
        if (clr) begin
            counter <= 4'b0000;
        end
        else if (increment) begin
            counter <= counter + 1;
        end 
    end

    always @(posedge clock) begin   
        if(output_enable) begin
            out_to_bus <= counter;
        end
        else begin    
            out_to_bus <= 4'bz;
        end       
    end        
    
    assign out_to_disp = counter;
    
endmodule























