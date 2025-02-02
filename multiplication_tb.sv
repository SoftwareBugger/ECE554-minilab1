`timescale 1ns / 1ps
module multiplication_tb();

    logic clk;
    logic rst_n;
    logic [7:0] A [7:0];
    logic [7:0] B;
    logic En;
    logic done;
    logic Clr;
    logic [8:0] FIFO_rden;
    logic [23:0] C [7:0];

    // FIFO signasls
    logic wren;
    logic [7:0] AnB_in [8:0];
    logic [8:0] full;
    logic [8:0] empty;
    parameter DEPTH = 8;
    parameter DATA_WIDTH = 8;

    // Set En when all fifos are full
    assign En = &full;


    Multiplication multiplication
    (
        .A(A),
        .B(B),
        .En(En),
        .Clr(Clr),
        .clk(clk),
        .rst_n(rst_n),
        .done(done),
        .FIFO_rden(FIFO_rden),
        .FIFO_empty(empty),
        .C(C)

    );

    FIFO
    #(
    .DEPTH(DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
    ) input_fifo [8:0]
    (
    .clk(clk),
    .rst_n(rst_n),
    .rden(FIFO_rden),
    .wren(wren),
    .i_data(AnB_in),
    .o_data({A[7], A[6], A[5], A[4], A[3], A[2], A[1], A[0], B}),
    .full(full),
    .empty(empty)
    );

    initial begin
        rst_n = 1'b1;
        clk = 1'b0;
        @(negedge clk) rst_n = 1'b1;
        @(negedge clk) rst_n = 1'b0;
        for (int i = 0; i < DEPTH; i++) begin
            @(negedge clk) begin
                rst_n = 1;
                wren = 1;
                // Fill A and B
                for (int j = 0; j < 9; j++) begin
                    AnB_in[j] = j+1;
                end
            end
        end
        @(negedge clk) begin
            wren = 0;
            if (!En) begin
                $display("En not asserted when FIFOs are filled!");
                $stop();
            end
        end
        @(posedge done) begin
            for (int i = 0; i < 8; i++) begin
                $display("C[%d]=%h", i, C[i]);
            end
            $stop();
        end

    end
    initial #10000 $stop();
    
    always #5 clk = ~clk;
endmodule