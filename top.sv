module top(
    input clk,
    input rst_n,
    input start,
    input Clr,
    output [23:0] C [7:0],
    output done
);

    logic [7:0] A [7:0];
    logic [7:0] B;
    logic En;
    logic [8:0] FIFO_rden;
    logic [23:0] set_C [7:0];

    // FIFO signasls
    logic [8:0] wren;
    logic [7:0] AnB_in;
    logic [8:0] full;
    logic [8:0] empty;
    parameter DEPTH = 8;
    parameter DATA_WIDTH = 8;

    // Set En when all fifos are full
    assign En = &full;
    logic filler_done;

    logic filler_write;
    logic[31:0] address;
    logic start_filler;
    logic filler_en;
    logic [3:0] cnt;

    fifo_filler filler
    (
        .clk(clk),
        .rst_n(rst_n),
        .start(filler_en),
        .fifo_full(full[cnt]),
        .address(address),
        .wren(filler_write),
        .done(filler_done),
        .data_o(AnB_in)
    );
    Multiplication multiply
    (
        .A(A),
        .B(B),
        .En(En),
        .Clr(Clr),
        .clk(clk),
        .rst_n(rst_n),
        .FIFO_empty(empty),
        .done(done),
        .FIFO_rden(FIFO_rden),
        .C(set_C)
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
    typedef enum reg[1:0]{IDLE, FILL, MULTI, DONE}state_t;
    state_t state, nxt_state;
    always_ff@(posedge clk, negedge rst_n)begin
        if(!rst_n)
            state <= IDLE;
        else
            state <= nxt_state;
    end

    
    
    logic clr_cnt;
    logic inc_cnt;

    assign address = cnt;
    assign wren = filler_write << address;
    assign C = set_C;

    always_ff @(negedge rst_n, posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
        end
        else if (clr_cnt) begin
            cnt <= 0;
        end
        else if (inc_cnt) begin
            cnt <= cnt + 1;
        end
    end

    
    always_ff @(negedge rst_n, posedge clk) begin
        if (!rst_n) filler_en <= 0;
        else filler_en <= start_filler;
    end

    always_comb begin
        nxt_state = state;
        clr_cnt = 0;
        start_filler = 0;
        inc_cnt = 0;
        case(state)
            IDLE:begin
                if (start) begin
                    clr_cnt = 1;
                    start_filler = 1;
                    nxt_state = FILL;
                end
            end
            FILL:begin
                if (full[cnt]) begin
                    if (cnt != 8) begin
                        inc_cnt = 1;
                        start_filler = 1;
                    end
                    else begin
                        nxt_state = MULTI;
                    end
                end
            end
            MULTI: begin
                if (done) nxt_state = IDLE;
            end
            
        endcase
    end


endmodule