`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2023 08:37:42 AM
// Design Name: 
// Module Name: register
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


    module register(
        input wire [7:0] data_in,
        input wire clk,
        input wire load,
        input wire clr,
        output wire [7:0] data_out,
        input wire output_enable,           
        output wire [7:0] data_out_gated    //outputs only if output_enable is true
        
    );

    // Internal register to hold the data.
    reg [7:0] data_reg;

    // When the load signal is high, store the input data on the next clock cycle.
    always @(posedge clk) begin
        if (clr)
            data_reg <= 8'b00000000;      
        else if (load)
            data_reg <= data_in;
  
    end

    // Create a tri-state buffer for the output.
    // When the enable signal is high, the output is the value stored in the register.
    // Otherwise, the output is high impedance (Z).
    assign data_out_gated = output_enable ? data_reg : 8'bz;
    assign data_out = data_reg;
endmodule
