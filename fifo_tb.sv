`timescale 1ns / 1ps
module fifo_tb();
    parameter DEPTH = 8;
    parameter DATA_WIDTH = 8;
    logic clk, rst_n, rden, wren, full, empty;
    logic [DATA_WIDTH-1:0] i_data, o_data;
    FIFO
    #(
    .DEPTH(DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
    ) input_fifo
    (
    .clk(clk),
    .rst_n(rst_n),
    .rden(rden),
    .wren(wren),
    .i_data(i_data),
    .o_data(o_data),
    .full(full),
    .empty(empty)
    );
    // FIFO input_fifo
    // (
	//  .aclr(~rst_n),
	//  .data(i_data),
    //  .rdclk(clk),
	//  .rdreq(rden),
	//  .wrclk(clk),
	//  .wrreq(wren),
	//  .q(o_data),
	//  .rdempty(empty),
	//  .wrfull(full)
    // );
    initial begin
        clk = 0;
        rst_n = 1;
        rden = 0;
        wren = 1;
        @(negedge clk) rst_n = 0;
	    @(negedge clk);
        for (int i = 0; i < DEPTH; i++) begin
            @(negedge clk) begin
                rst_n = 1;
                wren = 1;
                i_data = 8 - i;
            end
        end
        @(negedge clk) begin
            if (!full) begin
                $display("Not full after all space written!");
                $stop();
            end
            rden = 1;
            wren = 0;
        end
        for (int i = 0; i < DEPTH-1; i++) begin
            @(negedge clk) begin
                if (o_data != 8 - i) begin
                    $display("Data mismatched: Is %d should be %d", o_data, 8 - i);
                    $stop();
                end
                rden = 1;
            end
        end
        @(negedge clk) begin
            if (!empty) begin
                $display("Should be empty after read");
                $stop();
            end
        end
        $display("Yahoo! All test passed!");
        $stop();

    end
    always #5 clk = ~clk;
endmodule