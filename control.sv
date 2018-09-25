module control
(
	input logic [5:0] opcode,
	input logic [5:0] func,
	input logic zero,
	output logic [12:0] control
);

  always_comb begin
    unique case(opcode)
	000000 : control[ 
	100011 :
	101011 :
	000100 :
    endcase
  end

endmodule