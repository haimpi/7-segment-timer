module my_signal_pulse #(
	parameter signal_period_one = 32'd50000000
)

(

input clock,

input resetn,

input [31:0] counter, 

output reg signal_gen

);

//signals

//start design
 
always @ (posedge clock or negedge resetn)

begin

  if(resetn == 1'b0) begin

    signal_gen <= 1'b0;

   end  

   else begin
	
	if(counter == signal_period_one) begin
		
		signal_gen <= 1'b1;
		
	end
	else begin
	
		signal_gen <= 1'b0;
		
	end
	
   end 

end

//end design 
 
endmodule