/*
 *  The register file.  ra, rb, and rd are the address of the a, b, and d registers.
 *  The signal writed must be a 1 for the destination (d) register to be written.
 */
module rf
#(
   bw = 8,
   aw = 4
 )
 (
  input  logic [aw-1:0] ra,
  input  logic [aw-1:0] rb,
  input  logic [aw-1:0] rd,
  output logic [bw-1:0] a,
  output logic [bw-1:0] b,
  input  logic [bw-1:0] d,
  input  logic          writed,
  input  logic          clk,
  input  logic          rst
 );

  parameter nr = 1 << aw;

  logic  [bw-1:0] R    [nr-1:0];

  assign a = R[ra];
  assign b = R[rb];

  always_ff @(posedge clk) begin
        priority case (1'b1)
          (~rst) : R<='{default:32'b0};
          (writed) : R[rd] <= d;
        endcase
  end
endmodule // rf

