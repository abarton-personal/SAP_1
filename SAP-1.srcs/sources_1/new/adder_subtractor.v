
module adder_subtractor (
    input [7:0] inputA,        // Input A
    input [7:0] inputB,        // Input B
    input Sub,             // Subtract control
    input output_enable,             // Enable output control
    output reg [7:0] result_out    // Output
);

    // Intermediate result wire
    wire [7:0] result;

    // 2's complement subtraction if Su is high, addition if Su is low
    assign result = Sub ? (inputA + ~inputB + 1) : (inputA + inputB);

    // Tri-state control logic
    always @(inputA, inputB, Sub, output_enable) begin
        if (output_enable) begin
            result_out = result;  // Assign the result to the output if Eu is high
        end else begin
            result_out = 8'bz;    // High-z state if Eu is low
        end
    end

endmodule
