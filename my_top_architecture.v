module my_top_architecture (
    input clock,
    input resetn,
    input tunning, // Switch input to tunning/untunning the counters
    input mode_switch, // Switch between hour and minute mode
    input increment_button, // Button to increment selected counter
    output wire [47:0] segment_out
);

// Signals
wire [31:0] main_counter;
wire [31:0] seconds_counter;
wire [31:0] minutes_counter;
wire [31:0] hours_counter;
wire enable_seconds_counter;
wire enable_minutes_counter;
wire enable_hours_counter;
wire increment_signal; // Driven by the edge_detector module

// Instantiate edge detector
edge_detector edge_detector_inst (
    .clock(clock),
    .resetn(resetn),
    .increment_button(increment_button),
    .tunning(tunning),
    .increment_signal(increment_signal)
);

// Main Counter (1-second period)
my_counter #(
    .counter_size(31),
    .counter_limit(32'd50000000) // 1 second
) main_counter_inst (
    .clock(clock),
    .resetn(resetn),
    .enable(1'b1), // Always enabled
    .counter(main_counter)
);

// Signal Pulse Generator (1-second pulse)
my_signal_pulse #(
    .signal_period_one(32'd50000000) // 1 second
) my_signal_pulse_inst (
    .clock(clock),
    .resetn(resetn),
    .counter(main_counter),
    .signal_gen(enable_seconds_counter) // Generates a 1-second pulse
);

// Seconds Counter (counts up to 59 and resets)
my_counter #(
    .counter_size(31),
    .counter_limit(32'd59) // Counts from 0 to 59 then resets
) seconds_counter_inst (
    .clock(clock),
    .resetn(resetn),
    .enable(enable_seconds_counter && !tunning), // Enabled by 1-second pulse signal if not frozen
    .counter(seconds_counter)
);

// Enable signal for minutes counter (1 minute period)
assign enable_minutes_counter = (enable_seconds_counter && (seconds_counter == 32'd59) && !tunning);

// Minutes Counter (counts up to 59 and resets)
my_counter #(
    .counter_size(31),
    .counter_limit(32'd59)
) minutes_counter_inst (
    .clock(clock),
    .resetn(resetn),
    .enable(enable_minutes_counter || (increment_signal && mode_switch)), // Enabled by 1-minute signal or pulse increment
    .counter(minutes_counter)
);

// Enable signal for hours counter (1 hour period)
assign enable_hours_counter = (enable_minutes_counter && (minutes_counter == 32'd59) && !tunning);

// Hours Counter (counts up to 23 and resets)
my_counter #(
    .counter_size(31),
    .counter_limit(32'd23) // 24-hour format
) hours_counter_inst (
    .clock(clock),
    .resetn(resetn),
    .enable(enable_hours_counter || (increment_signal && !mode_switch)), // Enabled by 1-hour signal or pulse increment
    .counter(hours_counter)
);

// Decoder for segment display
my_decoder my_decoder_inst (
    .clock(clock),
    .resetn(resetn),
    .seconds_in(seconds_counter),
    .minutes_in(minutes_counter),
    .hours_in(hours_counter),
    .segment_out(segment_out)
);

endmodule
