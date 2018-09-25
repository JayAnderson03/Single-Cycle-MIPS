module top_cpu
();

  logic clk;
  logic rst;
  logic halt;

  cpu_v2 CPU ( .clk(clk), .rst(rst), .halt(halt)  );


    initial begin
        clk = 1'b0 ;
        while(1) begin
                #500 clk = 1'b0 ;
                #500 clk = 1'b1 ;
        end
    end



   initial begin
      repeat(100) @(posedge clk) ; 
      $finish(1) ; 
   end


   initial begin
    if ( $test$plusargs("wave") )  begin
      $vcdpluson(0,top_cpu_v2);
      $vcdplusmemon(0,top_cpu_v2);
    end
   end


    parameter prtdbg=0;
    always @(posedge clk ) begin
     #1
    if (rst==1)
    begin
        $write("%d ", $time );
        $write("PC %d ", CPU.PC  );
        $write("IR %x ", CPU.IR  );
        $write("a %x ", CPU.a  );
        $write("b %x ", CPU.b  );
        //$write("W %x ", CPU.W  );
        $write("PCin %d", CPU.PCin);
        $display(" ");
    end

    end

    always @(posedge clk) begin
      #4


      if (rst==1)
      begin
        for(int i = 0; i < 16; i++)
          $write("R%1x %x  ", i, CPU.registers.R[i] );
        $display(" ");
      end
    end


    always @(posedge clk) begin
      #10
      if (halt)
      begin
       $finish(0);
      end
    end

    int fd;


   int adr, val;

  initial begin

    rst = 1'b0;
    @(negedge clk);
    @(negedge clk);

   fd = $fopen("loader.o8", "r");
   while (  2 == $fscanf(fd, "%h %h", adr, val ) )
   begin
         CPU.MEM.mem[adr] = val;
   end

    @(negedge clk);
    @(negedge clk);
    #5
    rst = 1'b1;

   end


endmodule // top_cpu