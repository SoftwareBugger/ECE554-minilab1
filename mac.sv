module MAC #
(
parameter DATA_WIDTH = 8
)
(
input clk,
input rst_n,
input En,
input Clr,
input [DATA_WIDTH-1:0] Ain,
input [DATA_WIDTH-1:0] Bin,
output [DATA_WIDTH*3-1:0] Cout
);

logic [DATA_WIDTH*3-1:0] Cout_in, sum;
assign Cout = Cout_in;
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        Cout_in <= 0;
        sum <= 0;
    end
    else if (Clr) begin
        Cout_in <= 0;
        sum <= 0;
    end
    else if (En) begin
        sum <= (Ain * Bin);
        Cout_in <= Cout_in + sum;
    end
end

endmodule