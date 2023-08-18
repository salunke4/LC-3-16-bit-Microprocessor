module mux4to1(input logic [15:0] a, b, c, d,
					input logic [1:0] s,
					output logic [15:0] 	out
);
always_comb
begin
out = 16'hffff;
case (s)
	2'b11 : begin
		out = a;
	end
	2'b10 : begin
		out = b;
	end
	2'b01 : begin
	   out = c;
	end
	2'b00 : begin
	   out = d;
	end
endcase
end
endmodule