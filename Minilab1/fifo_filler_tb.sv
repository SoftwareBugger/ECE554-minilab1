`timescale 1ns / 1ps

module fifo_filler_tb();

logic clk, rst_n, rden;
logic[63:0] fifo_data;
logic[7:0] fifo_byte;

//filler signals
logic start, full, wren, done;
logic[31:0] address;
logic[7:0] data_o;

//FIFO signals
logic [7:0] fifo_data_in[9];
logic [7:0] fifo_data_out[9];
logic fifo_wren[9];
logic fifo_rden[9];
logic fifo_full[9];

//Generate FIFOs
genvar i;
generate
    for(i = 0; i < 9; i++)
        FIFO fifo_instance(
            .clk(clk), 
            .rst_n(rst_n), 
            .rden(fifo_rden[i]), 
            .wren(fifo_wren[i]), 
            .i_data(fifo_data_in[i]), 
            .o_data(fifo_data_out[i]),
            .full(fifo_full[i]),
            .empty());
endgenerate

//Instantiate filler
fifo_filler filler(.clk(clk), .rst_n(rst_n), .start(start), .fifo_full(full), .address(address), .wren(wren), .done(done), .data_o(data_o));

initial begin
  clk = 0;
  rst_n = 0;
  start = 0;
  address = 0;

  @(negedge clk)
    rst_n = 1;

  //Fill FIFOs using filler module
  repeat(2)@(posedge clk);
  $display("Starting FIFO Filling");
  for(int i = 0; i < 9; i++)begin
    //set interconnects to correct FIFO and set address
    fifo_wren[i] = wren;
    fifo_data_in[i] = data_o;
    full = fifo_full[i];
    address = i;

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
      end
    join
  end

  //Check FIFO outputs
  $display("Done Filling FIFOs, Beginning Contents Check");
  for(int i = 0; i < 9; i++)begin
    //set interconnect
    fifo_rden[i] = rden;
    fifo_byte = fifo_data_out[i];

    //get FIFO content
    rden = 1'b1;
    repeat(8)@(posedge clk)
      fifo_data = {fifo_byte, fifo_data[63:8]};
    rden = 1'b0;

    $display("FIFO %d contents:%h", i, fifo_data);
  end

end

always
  #5 clk = ~clk;

endmodule
