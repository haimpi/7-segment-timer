# Digital Clock Module

## Description
This Verilog module serves as a configurable digital clock, showcasing the robust capabilities of Verilog in creating a device that tracks seconds, minutes, and hours with additional tuning features. It is specifically developed and tested on the DE10-Standard FPGA Development Board for optimal performance and compatibility.


## Features
- **Accurate Timekeeping**: Counts seconds, minutes, and hours up to predefined limits.
- **Tuning Capability**: Allows for the counters to be frozen for manual adjustment, ideal for calibration or testing.
- **Mode Switching**: Toggle between hour and minute adjustment modes using a simple switch input.
- **Incremental Adjustment**: Utilizes a button to increment the selected time counter.
- **Seven-Segment Display Decoder**: Converts binary time values into signals compatible with a seven-segment display for easy visualization.
