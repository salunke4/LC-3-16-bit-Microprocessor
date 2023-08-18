module Bus
						  (input logic [15:0] A, B, C, D,
						 input logic w, x, y, z, 
							output logic [15:0] s);

always_comb
begin
s <= 16'b00000000000000000; 
if(w)
s <= A;
else if(x)
s <= B;
else if(y)
s <= C;
else if(z)
s <= D;
end
endmodule