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

logic [63:0] readdata;
logic read;
logic datavalid, waitrequest;

typedef enum reg[1:0]{IDLE, MEM_READ, FILL_FIFO}state_t;
state_t state, nxt_state;

memory MEM(.clk(clk), .reset_n(rst_n), .address(address), .read(read), .readdata(readdata), .readdatavalid(datavalid), .waitrequest(waitrequest));


always_ff@(posedge clk, negedge rst_n)begin
  if(!rst_n)
    state <= IDLE;
  else
    state <= nxt_state;
end

always_comb begin
  nxt_state = state;
  wren = 0;
  done = 0;
  data_o = 0;
  read = 0;
  
  case(state)
	FILL_FIFO:begin
		if(fifo_full)begin
            done = 1'b1;
            nxt_state = IDLE;
        end
        else begin
            data_o = readdata[7:0];
            readdata = {8'h00, readdata[35:8]};
        end
		
	end
	
	MEM_READ:begin
		read = 1'b1;
		if(datavalid & ~waitrequest)
			nxt_state = FILL_FIFO;
	end
  
    ////////default -> IDLE///////
    default: if(start)begin
		nxt_state = MEM_READ;
	end
	
  endcase
end


endmodule