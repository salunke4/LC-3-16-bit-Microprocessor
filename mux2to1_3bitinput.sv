module mux2to1_3bitinput
(
	input logic s,
	input logic [2:0] a,
	input logic [2:0] b,

	output logic [2:0] out
);

always_comb begin
	
case(s)
1'b0: out <= a;
1'b1: out <= b;
		endcase
		
	end

endmodule 