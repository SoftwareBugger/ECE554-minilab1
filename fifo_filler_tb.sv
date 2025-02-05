`timescale 1ns / 1ps

module fifo_filler_tb();

logic clk, rst_n, rden;
logic[63:0] fifo_data;
logic[7:0] fifo_byte;

//filler signals
logic start, full, wren, done;
logic[31:0] address;
logic[7:0] data_o;

// control
logic [4:0] cnt;

//FIFO signals
logic [7:0] fifo_data_in[9];
logic [7:0] fifo_data_out[9];
logic fifo_wren[9];
logic fifo_rden[9];
logic fifo_full[9];

//Expected values
logic [63:0] expected[8:0] = {64'h8182838485868788, 64'h7172737475767778, 64'h6162636465666768,
	64'h5152535455565758, 64'h4142434445464748, 64'h3132333435363738, 64'h2122232425262728,
	64'h1112131415161718, 64'h0102030405060708};

//Generate FIFOs
genvar i;
generate
    for(i = 0; i < 9; i++)
        FIFO fifo_instance(
            .clk(clk), 
            .rst_n(rst_n), 
            .rden(fifo_rden[i]), 
            .wren(fifo_wren[i]), 
            .i_data(data_o),//fifo_data_in[i]), 
            .o_data(fifo_data_out[i]),
            .full(fifo_full[i]),
            .empty());
endgenerate

//Instantiate filler
fifo_filler filler(.clk(clk), .rst_n(rst_n), .start(start), .fifo_full(full), .address(address), .wren(wren), .done(done), .data_o(data_o));

always_comb begin

  for (int i = 0; i < 9; i++) begin
    fifo_wren[i] = 0;
    fifo_rden[i] = 0;
    if (i==cnt & wren) begin
      fifo_wren[i] = wren;
    end 
    if (i==cnt & rden) begin
      fifo_rden[i] = rden;
    end
  end
end

assign full = fifo_full[cnt];
assign fifo_byte = fifo_data_out[cnt];


initial begin
  clk = 0;
  rst_n = 0;
  start = 0;
  address = 0;
  cnt = 0;
  fifo_data = '0;

  @(negedge clk)
    rst_n = 1;

  //Fill FIFOs using filler module
  repeat(2)@(posedge clk);
  $display("Starting FIFO Filling");
  for(int i = 0; i < 9; i++)begin
    address = i;
    cnt = i;

    //start memory read
    @(negedge clk)
    start = 1;
    @(negedge clk)
    start = 0;

    //Check for timeout, continue if done asserted
    fork
      begin: timeout
        repeat(1000)@(posedge clk);
      if(!done)begin
        $display("Filler timed out");
        $stop();
      end
      end : timeout;
      begin
        @(posedge done)
        disable timeout;
        @(posedge clk);
      end
    join
  end

  //Check FIFO outputs
  $display("Done Filling FIFOs, Beginning Contents Check");
  for(int i = 0; i < 9; i++)begin
    cnt = i;

    //get FIFO content
    rden = 1'b1;
    repeat(9)@(posedge clk)
      fifo_data = {fifo_byte, fifo_data[63:8]};
    rden = 1'b0;


    $display("FIFO %d expected contents:%h", i, expected[i]);
    $display("FIFO %d contents:%h", i, fifo_data);
    if(fifo_data === expected[i])begin
	$display("TEST %d PASSED", i);
	end
    else begin
	$display("TEST %d FAILED", i);
	$stop;
    end
  end
  $display("YAHOO: FIFO's filled correctly");
  $stop();
end

always
  #5 clk = ~clk;

endmodule
