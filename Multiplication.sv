module Multiplication
(
    input [8-1:0] A [8-1:0],
    input [8-1:0] B,
    input En,
    input Clr,
    input clk,
    input rst_n,
    input [8:0] FIFO_empty,
    output done,
    output [8:0] FIFO_rden,
    output [3*8-1:0] C [8-1:0]
);

logic [8-1:0] EN_inout;
logic [8-1:0] B_inout [8-1:0];
logic [8-2:0] EN_ff;
logic En_ff, set_done, pre_done;
always_ff @(posedge clk) begin
    if (rst_n == 0) begin
        EN_ff <= 0;
        set_done <= 0;
    end
    else begin
        EN_ff <= {EN_ff[8-2:0], En};
        set_done <= pre_done;
    end
end
Multi_single 
#(
    .WIDTH(8)
) multi_single [8-1:0]
(
    .B({B_inout[6], B_inout[5], B_inout[4], B_inout[3], B_inout[2], B_inout[1], B_inout[0], B}),
    .A(A),
    .FIFO_empty(FIFO_empty[8:1]),
    .rst_n(rst_n),
    .clk(clk),
    .EN({EN_inout[8-2:0], |EN_ff}),
	 .Clr(Clr),
    .EN_out(EN_inout[8-1:0]),
    .FIFO_rd(FIFO_rden[8:1]),
    .B_next(B_inout[8-1:0]),
    .C(C)
);
assign FIFO_rden[0] = FIFO_rden[1];
assign done = set_done;
assign pre_done = &FIFO_empty;
// logic [15:0] En_ff;
// logic [7:0] B_in [6:0];
// assign FIFO_rden = {En_ff[14], En_ff[12], En_ff[10], En_ff[8], En_ff[6], En_ff[4], En_ff[2], En_ff[0], En_ff[0]};
// MAC mac [7:0]
// (
// .clk(clk),
// .rst_n(rst_n),
// .En({En_ff[15], En_ff[13], En_ff[11], En_ff[9], En_ff[7], En_ff[5], En_ff[3], En_ff[1]}),
// .Clr(Clr),
// .Ain(A),
// .Bin({B_in, B}),
// .Cout(C)
// );

// always_ff @(posedge clk, negedge rst_n) begin
//     if (!rst_n) begin
//         En_ff <= 0;
//     end
//     else begin
//         En_ff <= ({(En_ff << 1) | En_ff[0]} | {14'h0000, En});
//     end
// end

// always_ff @(posedge clk, negedge rst_n) begin
//     if (!rst_n) begin
//         for (int i = 0; i < 7; i++) begin
//             B_in[i] <= 0;
//         end
//     end
//     else begin
//         if (FIFO_rden[2]) B_in[0] <= B;
//         for (int i = 1; i < 7; i++) begin
//             if (FIFO_rden[i+2]) B_in[i] <= B_in[i-1];
//         end
//     end
// end


endmodule