`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2023 07:47:21 PM
// Design Name: 
// Module Name: seven_segment
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



module seven_segment (
    input [3:0] data,   // 8-bit input
    output reg [6:0] seg   // 7-segment output
//    output DP,          // Decimal Point output
);


    // Decode the 8-bit input into the 7-segment display format
    always @(*) begin
        case(data)
            4'd0:  seg = 7'b1000000;  // Display 0
            4'd1:  seg = 7'b1111001;  // Display 1
            4'd2:  seg = 7'b0100100;  // Display 2
            4'd3:  seg = 7'b0110000;  // Display 3
            4'd4:  seg = 7'b0011001;  // Display 4
            4'd5:  seg = 7'b0010010;  // Display 5
            4'd6:  seg = 7'b0000010;  // Display 6
            4'd7:  seg = 7'b1111000;  // Display 7
            4'd8:  seg = 7'b0000000;  // Display 8
            4'd9:  seg = 7'b0010000;  // Display 9
            4'd10: seg = 7'b0001000;  // Display A
            4'd11: seg = 7'b0000011;  // Display B
            4'd12: seg = 7'b1000110;  // Display C
            4'd13: seg = 7'b0100001;  // Display D
            4'd14: seg = 7'b0000110;  // Display E
            4'd15: seg = 7'b0001110;  // Display F
            default: seg = 7'b1111111; // Display nothing for other values
        endcase
    end
endmodule
