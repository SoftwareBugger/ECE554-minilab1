module Multi_single
#(
    parameter WIDTH=8
)
(
    input [WIDTH-1:0] B,
    input [WIDTH-1:0] A,
    input FIFO_empty,
    input rst_n,
    input clk,
    input Clr,
    input EN,
    output EN_out,
    output FIFO_rd,
    output [WIDTH-1:0] B_next,
    output [3*WIDTH-1:0] C
);
    logic [WIDTH-1:0] B_ff, B_dff;
    logic EN_ff, EN_dff, EN_MAC;
    assign EN_out = EN_dff;
    assign B_next = B_dff;
    assign FIFO_rd = EN;
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            B_ff <= 0;
            B_dff <= 0;
            EN_ff <= 0;
            EN_dff <= 0;
        end
        else begin
            if (Clr) begin
                B_ff <= 0;
                B_dff <= 0;
                EN_ff <= 0;
                EN_dff <= 0;
            end
            else begin
                B_ff <= B;
                B_dff <= B_ff;
                EN_ff <= EN;
                EN_dff <= EN_ff;
            end
            if (EN | EN_ff) begin
                EN_MAC <= 1;
            end
            else begin
                EN_MAC <= 0;
            end
        end
    end
    MAC
    #(
        .DATA_WIDTH(WIDTH)
    ) mac
    (
        .clk(clk),
        .rst_n(rst_n),
        .En(EN_MAC),
        .Clr(Clr),
        .Ain(A),
        .Bin(B),
        .Cout(C)
    );

endmodule