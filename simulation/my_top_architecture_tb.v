`timescale 1ns / 1ps

module my_top_architecture_tb;

//signals
reg clock_tb;
reg resetn_tb;
reg tunning_tb;
reg mode_switch_tb;
reg increment_button_tb;
wire [47:0] segment_out_tb;

my_top_architecture my_top_architecture_inst (
    .clock(clock_tb),
    .resetn(resetn_tb),
    .tunning(tunning_tb),
    .mode_switch(mode_switch_tb),
    .increment_button(increment_button_tb),
    .segment_out(segment_out_tb)
);

// Clock generation
initial begin
    clock_tb = 0;
    forever #10 clock_tb = ~clock_tb; // 50MHz clock
end

// Stimulus generation
initial begin
    // Initialize inputs
    resetn_tb = 0;
    tunning_tb = 0;
    mode_switch_tb = 0;
    increment_button_tb = 0;
   
    // Apply reset
    #100;
    resetn_tb = 1;
   
    // Wait for some time
    #500;
   
    // Switch to tuning mode
    tunning_tb = 1;
   
    // Increment minutes
    mode_switch_tb = 1; // Select minutes
    increment_button_tb = 1;
    #20;
    increment_button_tb = 0;
    #20;
    increment_button_tb = 1;
    #20;
    increment_button_tb = 0;
   
    // Increment hours
    mode_switch_tb = 0; // Select hours
    increment_button_tb = 1;
    #20;
    increment_button_tb = 0;
    #20;
    increment_button_tb = 1;
    #20;
    increment_button_tb = 0;
   
    // Exit tuning mode
    tunning_tb = 0;

end

endmodule