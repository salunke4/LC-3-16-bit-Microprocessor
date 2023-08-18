module mux2to1(input logic [15:0] a, b,
					input s,
					output logic [15:0] 	out
);
always_comb
begin

case (s)
	1'b0 : begin
		out = a;
	end
	1'b1 : begin
		out = b;
	end
endcase

end

endmodule