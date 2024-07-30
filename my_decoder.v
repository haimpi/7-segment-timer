module my_decoder (
    input clock,
    input resetn,
    input [31:0] seconds_in,
    input [31:0] minutes_in,
    input [31:0] hours_in,
    output reg [47:0] segment_out // 48 bits: [47:40] for hour tens, [39:32] for hour units, [31:24] for minute tens, [23:16] for minute units, [15:8] for second tens, [7:0] for second units
);

// Function to map digit to 7-segment display pattern
function [7:0] digit_to_segment;
    input [3:0] digit;
    case (digit)
        4'd0: digit_to_segment = 8'b11000000; // 0
        4'd1: digit_to_segment = 8'b11111001; // 1
        4'd2: digit_to_segment = 8'b10100100; // 2
        4'd3: digit_to_segment = 8'b10110000; // 3
        4'd4: digit_to_segment = 8'b10011001; // 4
        4'd5: digit_to_segment = 8'b10010010; // 5
        4'd6: digit_to_segment = 8'b10000010; // 6
        4'd7: digit_to_segment = 8'b11111000; // 7
        4'd8: digit_to_segment = 8'b10000000; // 8
        4'd9: digit_to_segment = 8'b10010000; // 9
        default: digit_to_segment = 8'b11000000; // Default to 0
    endcase
endfunction

// Start design
always @(posedge clock or negedge resetn) begin
    if (!resetn) begin
        segment_out <= {digit_to_segment(4'd0), digit_to_segment(4'd0), digit_to_segment(4'd0),
		  digit_to_segment(4'd0), digit_to_segment(4'd0), digit_to_segment(4'd0)}; // Display 00:00:00 on reset
    end else begin
        if (seconds_in < 32'd60 && minutes_in < 32'd60 && hours_in < 32'd24) begin
            segment_out[7:0]   <= digit_to_segment(seconds_in % 10); // Second units place
            segment_out[15:8]  <= digit_to_segment(seconds_in / 10); // Second tens place
            segment_out[23:16] <= digit_to_segment(minutes_in % 10); // Minute units place
            segment_out[31:24] <= digit_to_segment(minutes_in / 10); // Minute tens place
            segment_out[39:32] <= digit_to_segment(hours_in % 10);   // Hour units place
            segment_out[47:40] <= digit_to_segment(hours_in / 10);   // Hour tens place
        end else begin
            segment_out <= {digit_to_segment(4'd0), digit_to_segment(4'd0), digit_to_segment(4'd0), 
				digit_to_segment(4'd0), digit_to_segment(4'd0), digit_to_segment(4'd0)}; 
				// Display 00:00:00 if out of range
        end
    end
end

endmodule
