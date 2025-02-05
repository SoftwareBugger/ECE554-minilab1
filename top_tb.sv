
`timescale 1ns / 1ps
module top_tb();

logic clk, rst_n, start, done, Clr;

logic [23:0] C [7:0];
logic [3:0] cnt;
//Expected values
logic [16:0] expected[7:0] = {16'h12cc, 16'h108c, 16'h0e4c, 16'h0c0c, 16'h09cc, 16'h078c, 16'h054C, 16'h030c};

//Instantiate top level
top minilab1(.clk(clk), .rst_n(rst_n), .start(start), .done(done), .C(C));


initial begin
  clk = 0;
  rst_n = 0;
  start = 0;

  @(negedge clk)
    rst_n = 1;

    //start computation
    $display("Starting Computations");
    @(negedge clk)
    start = 1;
    @(negedge clk)
    start = 0;

    //Check for timeout, continue if done asserted
    fork
      begin: timeout
        repeat(100000)@(posedge clk);
      if(!done)begin
        $display("Top Level timed out");
        $stop();
      end
      end : timeout;
      begin
        @(posedge done)
        disable timeout;
        @(posedge clk);
      end
    join

  //Check MAC Outputs
  $display("Computations Finished, Beginning MAC Check");
  for(int i = 0; i < 8; i++)begin
    cnt = i;

    $display("MAC %d expected contents:%h", i, expected[i]);
    $display("MAC %d contents:%h", i, C[i]);
    if(C[i] == expected[i])begin
	$display("TEST %d PASSED", i);
	end
    else begin
	$display("TEST %d FAILED", i);
	$stop;
    end
  end
  $display("YAHOO: Values Calculated Correctly");
  $stop();
end

always
  #5 clk = ~clk;

endmodule