module alu 
(
input logic [15:0] inputA,
input logic [15:0] inputB,
input logic [1:0] aluk,
output logic [15:0] ALU_Out
);

always_comb begin
unique case(aluk)

2'b00: ALU_Out = inputA + inputB;
2'b01: ALU_Out = inputA & inputB;
2'b10: ALU_Out = ~inputA;
2'b11: ALU_Out = inputA;

endcase
end

endmodule
