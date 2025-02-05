
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module minilab1_proj(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output	reg	     [6:0]		HEX0,
	output	reg	     [6:0]		HEX1,
	output	reg	     [6:0]		HEX2,
	output	reg	     [6:0]		HEX3,
	output	reg	     [6:0]		HEX4,
	output	reg	     [6:0]		HEX5,
	
	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW
);

	localparam DATA_WIDTH = 8;
	localparam DEPTH = 8;

	localparam FILL = 2'd0;
	localparam EXEC = 2'd1;
	localparam DONE = 2'd2;

	parameter HEX_0 = 7'b1000000;		// zero
	parameter HEX_1 = 7'b1111001;		// one
	parameter HEX_2 = 7'b0100100;		// two
	parameter HEX_3 = 7'b0110000;		// three
	parameter HEX_4 = 7'b0011001;		// four
	parameter HEX_5 = 7'b0010010;		// five
	parameter HEX_6 = 7'b0000010;		// six
	parameter HEX_7 = 7'b1111000;		// seven
	parameter HEX_8 = 7'b0000000;		// eight
	parameter HEX_9 = 7'b0011000;		// nine
	parameter HEX_10 = 7'b0001000;	// ten
	parameter HEX_11 = 7'b0000011;	// eleven
	parameter HEX_12 = 7'b1000110;	// twelve
	parameter HEX_13 = 7'b0100001;	// thirteen
	parameter HEX_14 = 7'b0000110;	// fourteen
	parameter HEX_15 = 7'b0001110;	// fifteen
	parameter OFF   = 7'b1111111;		// all off


	logic clk, rst_n, start, done, SW_FF, SW2_FF, Clr;

	logic [23:0] C [7:0];
	logic [6:0] HEXs [5:0];

	assign clk = CLOCK_50;
	assign rst_n = KEY[0];
	assign start = KEY[1]  & ~SW_FF;
	assign Clr = KEY[2]  & ~SW2_FF;

	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			SW_FF <= 1;
			SW2_FF <= 1;
			{HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} <= {HEX_0, HEX_0, HEX_0, HEX_0, HEX_0, HEX_0};
		end
		else begin
			SW_FF <= KEY[1];
			SW2_FF <= KEY[2];
			{HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} <= {HEXs[0], HEXs[1], HEXs[2], HEXs[3], HEXs[4], HEXs[5]};
		end
	end


	//Instantiate top level
	top minilab1(.clk(clk), .rst_n(rst_n), .start(start), .done(done), .C(C), .Clr(Clr));

	always @(*) begin
		case (C[{SW[3], SW[2], SW[1]}][3:0]) 
			4'b1111: begin
				HEXs[0] = HEX_15;
			end
			4'b1110: begin
				HEXs[0] = HEX_14;
			end
			4'b1101: begin
				HEXs[0] = HEX_13;
			end
			4'b1100: begin
				HEXs[0] = HEX_12;
			end
			4'b1011: begin
				HEXs[0] = HEX_11;
			end
			4'b1010: begin
				HEXs[0] = HEX_10;
			end
			4'b1001: begin
				HEXs[0] = HEX_9;
			end
			4'b1000: begin
				HEXs[0] = HEX_8;
			end
			4'b0111: begin
				HEXs[0] = HEX_7;
			end
			4'b0110: begin
				HEXs[0] = HEX_6;
			end
			4'b0101: begin
				HEXs[0] = HEX_5;
			end
			4'b0100: begin
				HEXs[0] = HEX_4;
			end
			4'b0011: begin
				HEXs[0] = HEX_3;
			end
			4'b0010: begin
				HEXs[0] = HEX_2;
			end
			4'b0001: begin
				HEXs[0] = HEX_1;
			end
			default: begin
				HEXs[0] = HEX_0;
			end
		endcase

		case (C[{SW[3], SW[2], SW[1]}][7:4]) 
			4'b1111: begin
				HEXs[1] = HEX_15;
			end
			4'b1110: begin
				HEXs[1] = HEX_14;
			end
			4'b1101: begin
				HEXs[1] = HEX_13;
			end
			4'b1100: begin
				HEXs[1] = HEX_12;
			end
			4'b1011: begin
				HEXs[1] = HEX_11;
			end
			4'b1010: begin
				HEXs[1] = HEX_10;
			end
			4'b1001: begin
				HEXs[1] = HEX_9;
			end
			4'b1000: begin
				HEXs[1] = HEX_8;
			end
			4'b0111: begin
				HEXs[1] = HEX_7;
			end
			4'b0110: begin
				HEXs[1] = HEX_6;
			end
			4'b0101: begin
				HEXs[1] = HEX_5;
			end
			4'b0100: begin
				HEXs[1] = HEX_4;
			end
			4'b0011: begin
				HEXs[1] = HEX_3;
			end
			4'b0010: begin
				HEXs[1] = HEX_2;
			end
			4'b0001: begin
				HEXs[1] = HEX_1;
			end
			default: begin
				HEXs[1] = HEX_0;
			end
		endcase

		case (C[{SW[3], SW[2], SW[1]}][11:8]) 
			4'b1111: begin
				HEXs[2] = HEX_15;
			end
			4'b1110: begin
				HEXs[2] = HEX_14;
			end
			4'b1101: begin
				HEXs[2] = HEX_13;
			end
			4'b1100: begin
				HEXs[2] = HEX_12;
			end
			4'b1011: begin
				HEXs[2] = HEX_11;
			end
			4'b1010: begin
				HEXs[2] = HEX_10;
			end
			4'b1001: begin
				HEXs[2] = HEX_9;
			end
			4'b1000: begin
				HEXs[2] = HEX_8;
			end
			4'b0111: begin
				HEXs[2] = HEX_7;
			end
			4'b0110: begin
				HEXs[2] = HEX_6;
			end
			4'b0101: begin
				HEXs[2] = HEX_5;
			end
			4'b0100: begin
				HEXs[2] = HEX_4;
			end
			4'b0011: begin
				HEXs[2] = HEX_3;
			end
			4'b0010: begin
				HEXs[2] = HEX_2;
			end
			4'b0001: begin
				HEXs[2] = HEX_1;
			end
			default: begin
				HEXs[2] = HEX_0;
			end
		endcase

		case (C[{SW[3], SW[2], SW[1]}][15:12]) 
			4'b1111: begin
				HEXs[3] = HEX_15;
			end
			4'b1110: begin
				HEXs[3] = HEX_14;
			end
			4'b1101: begin
				HEXs[3] = HEX_13;
			end
			4'b1100: begin
				HEXs[3] = HEX_12;
			end
			4'b1011: begin
				HEXs[3] = HEX_11;
			end
			4'b1010: begin
				HEXs[3] = HEX_10;
			end
			4'b1001: begin
				HEXs[3] = HEX_9;
			end
			4'b1000: begin
				HEXs[3] = HEX_8;
			end
			4'b0111: begin
				HEXs[3] = HEX_7;
			end
			4'b0110: begin
				HEXs[3] = HEX_6;
			end
			4'b0101: begin
				HEXs[3] = HEX_5;
			end
			4'b0100: begin
				HEXs[3] = HEX_4;
			end
			4'b0011: begin
				HEXs[3] = HEX_3;
			end
			4'b0010: begin
				HEXs[3] = HEX_2;
			end
			4'b0001: begin
				HEXs[3] = HEX_1;
			end
			default: begin
				HEXs[3] = HEX_0;
			end
		endcase

		case (C[{SW[3], SW[2], SW[1]}][19:16]) 
			4'b1111: begin
				HEXs[4] = HEX_15;
			end
			4'b1110: begin
				HEXs[4] = HEX_14;
			end
			4'b1101: begin
				HEXs[4] = HEX_13;
			end
			4'b1100: begin
				HEXs[4] = HEX_12;
			end
			4'b1011: begin
				HEXs[4] = HEX_11;
			end
			4'b1010: begin
				HEXs[4] = HEX_10;
			end
			4'b1001: begin
				HEXs[4] = HEX_9;
			end
			4'b1000: begin
				HEXs[4] = HEX_8;
			end
			4'b0111: begin
				HEXs[4] = HEX_7;
			end
			4'b0110: begin
				HEXs[4] = HEX_6;
			end
			4'b0101: begin
				HEXs[4] = HEX_5;
			end
			4'b0100: begin
				HEXs[4] = HEX_4;
			end
			4'b0011: begin
				HEXs[4] = HEX_3;
			end
			4'b0010: begin
				HEXs[4] = HEX_2;
			end
			4'b0001: begin
				HEXs[4] = HEX_1;
			end
			default: begin
				HEXs[4] = HEX_0;
			end
		endcase

		case (C[{SW[3], SW[2], SW[1]}][23:20]) 
			4'b1111: begin
				HEXs[5] = HEX_15;
			end
			4'b1110: begin
				HEXs[5] = HEX_14;
			end
			4'b1101: begin
				HEXs[5] = HEX_13;
			end
			4'b1100: begin
				HEXs[5] = HEX_12;
			end
			4'b1011: begin
				HEXs[5] = HEX_11;
			end
			4'b1010: begin
				HEXs[5] = HEX_10;
			end
			4'b1001: begin
				HEXs[5] = HEX_9;
			end
			4'b1000: begin
				HEXs[5] = HEX_8;
			end
			4'b0111: begin
				HEXs[5] = HEX_7;
			end
			4'b0110: begin
				HEXs[5] = HEX_6;
			end
			4'b0101: begin
				HEXs[5] = HEX_5;
			end
			4'b0100: begin
				HEXs[5] = HEX_4;
			end
			4'b0011: begin
				HEXs[5] = HEX_3;
			end
			4'b0010: begin
				HEXs[5] = HEX_2;
			end
			4'b0001: begin
				HEXs[5] = HEX_1;
			end
			default: begin
				HEXs[5] = HEX_0;
			end
		endcase
	end

	




endmodule
