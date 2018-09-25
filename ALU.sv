module ALU
(
	input logic [31:0] a,
	input logic [31:0] b,
	input logic [2:0] ALUc,
	output logic [31:0] d,
	output logic zero
);
   always_comb begin
    // alu control
    unique case (ALUc)
     000 : d = a & b; //AND
     001 : d = a | b; //OR
     010 : d = a + b; //add
     110 : d = a - b; //subtract
     
    endcase
   end

  assign zero = a-b=='0;

endmodule 