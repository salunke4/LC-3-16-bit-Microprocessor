//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 5 Given Code - SLC-3 top-level (Physical RAM)
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//------------------------------------------------------------------------------


module slc3(
	input logic [9:0] SW,
	input logic	Clk, Reset, Run, Continue,
	output logic [9:0] LED,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);


// An array of 4-bit wires to connect the hex_drivers efficiently to wherever we want
// For Lab 1, they will direclty be connected to the IR register through an always_comb circuit
// For Lab 2, they will be patched into the MEM2IO module so that Memory-mapped IO can take place
logic [3:0] hex_4[3:0]; 
HexDriver hex_drivers[3:0] (hex_4, {HEX3, HEX2, HEX1, HEX0});
// This works thanks to http://stackoverflow.com/questions/1378159/verilog-can-we-have-an-array-of-custom-modules

//HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
//HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
//HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
//HexDriver hex_driver0 (hex_4[0][3:0], HEX0);


// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX;
logic BEN, MIO_EN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC;








// Connect MAR to ADDR, which is also connected as an input into MEM2IO
//	MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//	input into MDR)
assign ADDR = MAR; 
assign MIO_EN = OE;
// Connect everything to the data path (you have to figure out this part)

// Our SRAM and I/O controller (note, this plugs into MDR/MAR)

Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset), .Run(Run), .Continue(Continue),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
   .Mem_OE(OE), .Mem_WE(WE) 
);

// SRAM WE register
//logic SRAM_WE_In, SRAM_WE;
//// SRAM WE synchronizer
//always_ff @(posedge Clk or posedge Reset_ah)
//begin
//	if (Reset_ah) SRAM_WE <= 1'b1; //resets to 1
//	else 
//		SRAM_WE <= SRAM_WE_In;
//end

logic [15:0] PC_IN, BUS, MDR_IN, LDR_IR, SUM, ALU_Output, SR1_Output, 
             SR2_Output, SR2MUX_OUT, ADDR1MUX_OUT, ADDR2MUX_OUT;

logic [2:0] DR, SR1MUX_OUT;

reg_16  PC_Register(
				.Clk(Clk),
				.Reset(Reset),	 
				.Load(LD_PC), 
				.D(PC_IN), 
				.Data_Out(PC)
				);
				
reg_16  MAR_Register(
				.Clk(Clk),
				.Reset(Reset),	 
				.Load(LD_MAR), 
				.D(BUS), 
				.Data_Out(MAR)
				);
				
				
reg_16  MDR_Register(
				.Clk(Clk),
				.Reset(Reset),	 
				.Load(LD_MDR), 
				.D(MDR_IN), 
				.Data_Out(MDR)
				);
				
				
reg_16  IR_Register(
				.Clk(Clk),
				.Reset(Reset),	 
				.Load(LD_IR), 
				.D(BUS), 
				.Data_Out(IR)
				);
				

mux4to1 PC_MUX(      .a(16'b0), 
							.b(BUS), 
							.c(ADDR1MUX_OUT+ADDR2MUX_OUT),
						   .d(PC+16'b0000000000000001),	
							.s(PCMUX),
							.out(PC_IN)
							);
							
mux2to1 MDR_MUX(
							.a(BUS), 
							.b(MDR_In), 
							.s(MIO_EN),
							.out(MDR_IN)
							);
							
Bus bus(.A(PC), .B(MDR), .C(ALU_Output), .D(ADDR1MUX_OUT+ADDR2MUX_OUT), .w(GatePC), .x(GateMDR), .y(GateALU), .z(GateMARMUX), .s(BUS));
							


registerfile reg_file(.Clk(Clk), .Reset(Reset), .LD(LD_REG),
					     .DR_In(DR),
					     .SR2(IR[2:0]), .SR1(SR1MUX_OUT),
					    .Bus_In(BUS),
					    .SR1_OUT(SR1_Output), .SR2_OUT(SR2_Output));
						 

alu ALU(.inputA(SR1_Output), .inputB(SR2MUX_OUT), .aluk(ALUK), .ALU_Out(ALU_Output));

mux2to1 ADDR1_MUX(
.a(PC),
.b(SR1_Output),
.s(ADDR1MUX),
.out(ADDR1MUX_OUT)
);

mux4to1 ADDR2_MUX(
.a(16'h0000000000000000),
.b({{10{IR[5]}}, IR[5:0]}),
.c({{7{IR[8]}}, IR[8:0]}),
.d({{5{IR[10]}}, IR[10:0]}),
.s(ADDR2MUX),
.out(ADDR2MUX_OUT));


mux2to1 SR2_MUX( 
.a(SR2_Output), 
.b({{11{IR[4]}}, IR[4:0]}), 
.s(SR2MUX),
.out(SR2MUX_OUT)
);

mux2to1_3bitinput SR1_MUX(
.a(IR[8:6]),
.b(IR[11:9]),
.s(SR1MUX),
.out(SR1MUX_OUT));

mux2to1_3bitinput DR_MUX(
.a(IR[11:9]),
.b(3'b111),
.s(DRMUX),
.out(DR));

ben BEN_Unit(.D(BUS),
.LD1(LD_CC), .LD2(LD_BEN), .Clk(Clk), .Reset(Reset),
.IR_Input(IR[11:9]),
.BEN_OUT(BEN));


endmodule
