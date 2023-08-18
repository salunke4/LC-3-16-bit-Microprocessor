module adder(input [15:0] a,
				 input [15:0] b,
				 output logic [15:0] out);
				 
always_comb
	begin
	out <= a+b;
	end
endmodule 