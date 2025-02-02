module Multiplication
#(
    parameter NUM_MAC = 8,
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] A [NUM_MAC-1:0],
    input [WIDTH-1:0] B,
    input En,
    input Clr,
    input clk,
    input rst_n,
    input [NUM_MAC:0] FIFO_empty,
    output done,
    output [NUM_MAC:0] FIFO_rden,
    output [3*WIDTH-1:0] C [NUM_MAC-1:0]
);

logic [NUM_MAC-1:0] EN_inout;
logic [WIDTH-1:0] B_inout [NUM_MAC-1:0];
logic [NUM_MAC-2:0] EN_ff;
logic En_ff, set_done, pre_done;
always_ff @(posedge clk) begin
    if (rst_n == 0) begin
        EN_ff <= 0;
        set_done <= 0;
    end
    else begin
        EN_ff <= {EN_ff[NUM_MAC-2:0], En};
        set_done <= pre_done;
    end
end
Multi_single 
#(
    .WIDTH(WIDTH)
) multi_single [NUM_MAC-1:0]
(
    .B({B_inout[NUM_MAC-2:0], B}),
    .A(A),
    .FIFO_empty(FIFO_empty[NUM_MAC:1]),
    .rst_n(rst_n),
    .clk(clk),
    .EN({EN_inout[NUM_MAC-2:0], |EN_ff}),
    .EN_out(EN_inout[NUM_MAC-1:0]),
    .FIFO_rd(FIFO_rden[NUM_MAC:1]),
    .B_next(B_inout[NUM_MAC-1:0]),
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