module testbench();

timeunit 10ns;

timeprecision 1ns;



logic [9:0] SW;
logic Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;


slc3_testtop slc3_testtop0(.*);

always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
	Clk = 0;
end


initial begin: TEST_VECTORS

SW = 10'b0000000110; 

Run = 0;
#10 Continue = 0;

#10 Run = 1;
	Continue = 1;

#20 Run = 0;

#10 Run = 1;


#20 Continue = 0;

#10 Continue = 1;

#10 Continue = 0;

#20 Continue = 1;

#10 Continue = 0;

#20 Continue = 1;

#10 Continue = 0;

#20 Continue = 1;

#20	Run = 0;
	Continue = 0;
#10 Run = 1;
	Continue = 1;

#20 Run = 0;
#10 Run = 1;

#20 Continue = 0;

#10 Continue = 1;

#10 Continue = 0;

#20 Continue = 1;
	
end
endmodule 


