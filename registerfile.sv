module registerfile(input logic Clk, Reset, LD,
					     input logic [2:0]DR_In,
					     input logic [2:0]SR2, SR1,
					     input logic [15:0]Bus_In,
					     output logic [15:0] SR1_OUT, SR2_OUT);
					 
logic [7:0][15:0] regunit;
	
always_ff @ (posedge Clk)
begin
if (Reset)				
begin
regunit[0] <= 16'h0000;
regunit[1] <= 16'h0000;
regunit[2] <= 16'h0000;
regunit[3] <= 16'h0000;
regunit[4] <= 16'h0000;
regunit[5] <= 16'h0000;
regunit[6] <= 16'h0000;
regunit[7] <= 16'h0000;
end
else
begin
if(LD)			
begin
case(DR_In)
3'b000 : regunit[0] <= Bus_In;
3'b001 : regunit[1] <= Bus_In;
3'b010 : regunit[2] <= Bus_In;
3'b011 : regunit[3] <= Bus_In;
3'b100 : regunit[4] <= Bus_In;
3'b101 : regunit[5] <= Bus_In;
3'b110 : regunit[6] <= Bus_In;
3'b111 : regunit[7] <= Bus_In;
endcase
end
end
end
		
	
always_comb
begin

case (SR1)
3'b000 : SR1_OUT = regunit[0];
3'b001 : SR1_OUT = regunit[1];
3'b010 : SR1_OUT = regunit[2];
3'b011 : SR1_OUT = regunit[3];
3'b100 : SR1_OUT = regunit[4];
3'b101 : SR1_OUT = regunit[5];
3'b110 : SR1_OUT = regunit[6];
3'b111 : SR1_OUT = regunit[7];
endcase

case (SR2)
3'b000 : SR2_OUT = regunit[0];
3'b001 : SR2_OUT = regunit[1];
3'b010 : SR2_OUT = regunit[2];
3'b011 : SR2_OUT = regunit[3];
3'b100 : SR2_OUT = regunit[4];
3'b101 : SR2_OUT = regunit[5];
3'b110 : SR2_OUT = regunit[6];
3'b111 : SR2_OUT = regunit[7];
endcase
end
endmodule