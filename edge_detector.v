module edge_detector (
    input clock,
    input resetn,
    input increment_button,
    input tunning,
    output reg increment_signal
);

reg increment_button_prev;
reg reset_delay; //like a flag

initial begin
    increment_button_prev = 0;
    reset_delay = 1'b0; // Clear delay counter
end

// Edge detection logic
always @(posedge clock or negedge resetn) begin
    if (!resetn) begin
        increment_button_prev <= 0;
        increment_signal <= 0;
        reset_delay <= 1'b1; // raises flag that i presses on reset button
    end else begin
        if (reset_delay != 1'b0) begin
            // Count down to zero before enabling button press detection
            reset_delay <= reset_delay - 1'b1;
            increment_signal <= 0; // Ensure no increment signal during the delay period
        end else begin
            // Normal operation, only proceed if delay has finished
            if (!increment_button_prev && increment_button && tunning) begin
                increment_signal <= 1; // Generate a pulse when a rising edge is detected
            end else begin
                increment_signal <= 0; // Reset the pulse
            end
        end
        increment_button_prev <= increment_button; // Update the previous state
    end
end

endmodule
