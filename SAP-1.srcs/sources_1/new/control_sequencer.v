module control_sequencer (
    input clk, reset,
    input [3:0] opcode,
    output reg pc_oe,
    output reg pc_inc,
    output reg mar_load,
    output reg ram_oe,
    output reg ir_load,
    output reg reg_a_load,
    output reg reg_b_load,
    output reg reg_a_oe,
    output reg reg_b_oe,
    output reg sub,
    output reg adder_oe,
    output reg out_reg_load
);

    reg [3:0] t_state;  // Timing state

    // Increment the timing state on each clock cycle
    always @(negedge clk or posedge reset)
    if (reset)
        t_state <= 0;
    else
        t_state <= t_state + 1;

    // Generate control signals based on the timing state
    always @(t_state, opcode)
    begin
        // Default: turn off all control signals
        pc_inc = 0;
        pc_oe = 0;
        mar_load = 0;
        ram_oe = 0;
        ir_load = 0;
        reg_a_load = 0;
        reg_b_load = 0;
        reg_a_oe = 0;
        reg_b_oe = 0;
        sub = 0;
        adder_oe = 0;
        out_reg_load = 0;

        // Timing state T1: Increment PC, load MAR
        if (t_state == 1)
        begin
            pc_oe = 1;            
            mar_load = 1;
        end

        // Timing state T2: Enable RAM, load IR
        else if (t_state == 2)
        begin
            ram_oe = 1;            
            ir_load = 1;
            pc_inc = 1;
        end

        // Timing state T3 and beyond: execute instruction
        else if (t_state > 2)
        begin
            // Decode and execute opcode
            case (opcode)
                4'b0000: // LDA
                    if (t_state == 3) reg_a_load = 1;
                4'b0001: // ADD
                    if (t_state == 3) reg_b_load = 1;
                    else if (t_state == 4)
                    begin
                        reg_a_oe = 1;
                        reg_b_oe = 1;
                        adder_oe = 1;
                        reg_a_load = 1;
                    end
                4'b0010: // SUB
                    if (t_state == 3) reg_b_load = 1;
                    else if (t_state == 4)
                    begin
                        reg_a_oe = 1;
                        reg_b_oe = 1;
                        sub = 1;
                        adder_oe = 1;
                        reg_a_load = 1;
                    end
                4'b1110: // OUT
                    if (t_state == 3)
                    begin
                        reg_a_oe = 1;
                        out_reg_load = 1;
                    end
                4'b1111: // HLT
                    if (t_state == 3) reset = 1;
            endcase
        end
    end
endmodule
