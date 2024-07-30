module my_counter #
(
    parameter counter_size = 31,
    parameter counter_limit = 32'd50000000
)
(
    input clock,
    input resetn,
    input enable,
    output reg [counter_size:0] counter
);

// signals

// start design
always @ (posedge clock or negedge resetn)
begin
    if (resetn == 1'b0) begin
        counter <= 'b0;
    end
    else begin
        if (enable == 1'b1) begin
            if (counter == counter_limit) begin
                counter <= 'b0;
            end
            else begin
                counter <= counter + 1'b1;
            end    
        end
        else begin
            counter <= counter;
        end
    end
end
// end design

endmodule
