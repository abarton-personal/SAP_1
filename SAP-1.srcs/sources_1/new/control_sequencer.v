module control_sequencer (
    input clk, reset,
    input [3:0] opcode,
    output reg pc_oe,
    output reg pc_inc,
    output reg mar_load,
    output reg ram_oe,
    output reg ir_load,
    output reg ir_oe,
    output reg reg_a_load,
    output reg reg_b_load,
    output reg reg_a_oe,
    output reg reg_b_oe,
    output reg sub,
    output reg adder_oe,
    output reg out_reg_load,
    output [3:0] t_state_out
);

    reg [3:0] t_state;  // Timing state
    reg halt;
    reg instruction_complete;
    
    initial begin
        halt = 0;
        instruction_complete = 0;
    end

    assign t_state_out = t_state;
    
    // Increment the timing state on each clock cycle
    always @(negedge clk or posedge reset)
    if (reset) begin
        halt <= 0;       // Clear halt signal on reset
        t_state <= 0;        
        instruction_complete <= 0;
    end
    else if (!halt) begin //Only increment the t_state if not halted
        if (instruction_complete) begin
            t_state <= 0;        
            instruction_complete <= 0;
        end else 
            t_state <= t_state + 1;
    end

    // Generate control signals based on the timing state
    always @(t_state, opcode)
    begin
        // Default: turn off all control signals
        pc_inc = 0;
        pc_oe = 0;
        mar_load = 0;
        ram_oe = 0;
        ir_load = 0;
        ir_oe = 0;
        reg_a_load = 0;
        reg_b_load = 0;
        reg_a_oe = 0;
        reg_b_oe = 0;
        sub = 0;
        adder_oe = 0;
        out_reg_load = 0;

        // FETCH CYCLE
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

        // Timing state T3 and beyond: EXECUTE INSTRUCTION
        else if (t_state > 2)
        begin
            // Decode and execute opcode
            case (opcode)
                4'b0000: // LDA
                    if (t_state == 3) 
                    begin
                        ir_oe = 1;
                        mar_load = 1;
                    end
                    else if (t_state == 4)
                    begin
                        ram_oe = 1;
                        reg_a_load = 1;
                        instruction_complete <= 1;
                    end
                4'b0001: // ADD
                    if (t_state == 3) 
                    begin 
                        ir_oe = 1;
                        mar_load = 1;                
                    end
                    else if (t_state == 4)
                    begin
                       ram_oe = 1;
                       reg_b_load = 1;
                    end
                    else if (t_state == 5)
                    begin
                       adder_oe = 1;
                       reg_a_load = 1;
                       instruction_complete <= 1;
                    end
                4'b0010: // SUBTRACT
                    if (t_state == 3) 
                    begin 
                        ir_oe = 1;
                        mar_load = 1;                
                    end
                    else if (t_state == 4)
                    begin
                       ram_oe = 1;
                       reg_b_load = 1;
                       sub = 1;
                    end
                    else if (t_state == 5)
                    begin
                       adder_oe = 1;
                       reg_a_load = 1;
                       sub = 1;
                       instruction_complete <= 1;
                    end
                4'b1110: // OUT
                    if (t_state == 3)
                    begin
                        reg_a_oe = 1;
                        out_reg_load = 1;
                        instruction_complete <= 1;
                    end
                4'b1111: // HLT
                    if (t_state == 3) halt <= 1;
            endcase
        end
    end
endmodule
