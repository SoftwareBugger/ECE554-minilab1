module fifo_filler
(
    input clk,
    input rst_n,
    input logic start,
    input logic fifo_full,
    input logic [31:0] address,
    output logic wren,
    output logic done,
    output logic[7:0] data_o
);

logic [63:0] readdata, shiftdata;
logic read, sm_shift;
logic datavalid, waitrequest;

typedef enum reg[1:0]{IDLE, MEM_READ, PUSH_BYTE, EVALUATE}state_t;
state_t state, nxt_state;

memory mem_access(.clk(clk), .reset_n(rst_n), .address(address), .read(read), .readdata(readdata), .readdatavalid(datavalid), .waitrequest(waitrequest));

always_ff@(posedge clk, negedge rst_n)begin
  if(!rst_n)
    state <= IDLE;
  else
    state <= nxt_state;
end

always_ff@(posedge clk, negedge rst_n)begin
  if(!rst_n)
    shiftdata <= 0;
  else if(sm_shift)
    shiftdata <= {8'h00, shiftdata[63:8]};
  else if(datavalid)
    shiftdata <= readdata;
end


always_comb begin
  nxt_state = state;
  wren = 0;
  done = 0;
  data_o = 0;
  read = 0;
  sm_shift = 0;
  case(state)
	PUSH_BYTE:begin
            data_o = shiftdata[7:0];
            sm_shift = 1'b1;
	    wren = 1'b1;
	    nxt_state = EVALUATE;
	end
	
	EVALUATE:begin
	if(fifo_full)begin
            done = 1'b1;
            nxt_state = IDLE;
            end
	else
	  nxt_state = PUSH_BYTE;
	end

	MEM_READ:begin
		if(datavalid)begin
			nxt_state = PUSH_BYTE;
		end
		read = 1'b1;
	end
  
    ////////default -> IDLE///////
    default: if(start)begin
		nxt_state = MEM_READ;
	end
	
  endcase
end


endmodule