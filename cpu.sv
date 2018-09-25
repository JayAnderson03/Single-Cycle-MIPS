module cpu 
(
	input logic rst,
	input logic clk	
);

  parameter ibw = 32;
  parameter dbw = 32;
  parameter aw  = 32;


  /* Datapath Logic */
  //Instruction logic
  logic [ibw-1:0] IR;

  //ALU result and register data
  logic [dbw-1:0] ALU, s, t, regData, data;
  
  //PC output and input
  logic [aw-1:0] PC, PCin, PCinc, PCb;
  
  //Register addresses
  logic [4:0] rs, rt, rd;

  //opcode
  logic [5:0] opcode;

  //Control Signals
  logic RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
  logic [2:0] ALUOp

  logic Zero;


  //Program Counter
  dff #(aw)  regPC (.d(PCin), .q(PC), .clk(clk), .rst(rst), .en(1'b1));

  //Instruction Memory
  memory  #( .bW( ibw ), .aW( aw ), .eC( 50 )   )  iMEM
      ( .writeAddr(  ), .readAddr ( PC ),
        .writeData(  ),
        .readData ( IR ),
        .writeEn  ( 1'b0 ), // memory is read-only
        .clk      ( clk )
      );

  //Split instructions
  assign opcode = IR[31:26];
  assign rs     = IR[25:21] ;
  assign rt     = IR[20:16]  ;
  assign rd     = RegDst ? IR[15:11] : IR[20:16];
  
  //Control Unit
  control cUnit(.opcode(opcode), .func(IR[5:0]), .zero(zero));

  //Registers
  rf #(dbw, 32) registers
      ( .ra( rs ), .rb( rt ), .rd( rd ), .a( s ), .b( t ), .d( regData ),
        .writed( RegWrite ),
        .clk( clk ), .rst( rst )
      );

  //ALU
  ALU myALU(.a(s), .b((ALUSrc ? '{16'b0,IR[15:0]} : t)), .ALUc(ALUOp), .zero(zero), .d(ALU));

  //Data Memory
  memory  #( .bW( ibw ), .aW( aw ), .eC( 50 )   )  dMEM
      ( .writeAddr( ALU ), .readAddr ( PC ),
        .writeData( t ),
        .readData ( data ),
        .writeEn  ( MemWrite ), 
        .clk      ( clk )
      );

  //Mux driving data to be written to registers
  assign regData = MemtoReg ? data : ALU;

  //PC increment 
  assign PCinc = PC+4'b1000;

  //Branching Logic
  assign PCb = (Branch & zero) ? ('{14'b0,IR[15:0],2'b0})+PCinc : PCinc;

  //Jump Logic
  assign PCin = Jump ? jumping : PCb;

endmodule