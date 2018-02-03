module RGB_Control_r0(
	input	clk,
	input	rst_n,
	input	tx_done,
	output	reg	data_ready,
	output	reg	data_valid,
	output	reg	[23:0]	RGB
);

//------------------------------//
reg		[23:0]	RGB_reg	[0:4];
reg		[2:0]	i;
reg		[31:0]	cnt;
//------------------------------//

//------------------------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		cnt <= 0;
		data_ready <= 0;
	end
	else if(cnt == 1000)	begin
		cnt <= cnt + 1;
		data_ready <= 1;
	end
	else if(cnt == 40000)	begin
		cnt <= cnt + 1;
		data_ready <= 0;
	end
	else if(cnt == 45000)	begin
		cnt <= 0;
		data_ready <= 1;
	end
	else	begin
		cnt <= cnt + 1;
	end
end
//------------------------------//

//------------------------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n || !data_ready)	begin
		i <= 0;
		data_valid <= 0;
		RGB <= 0;	//24'b11111111_11111111_11111111;
		RGB_reg[0]	<= 24'b11111111_00000000_11111111;
		RGB_reg[1]	<= 24'b00000000_11111111_00000000;
		RGB_reg[2]	<= 24'b10101010_01010101_10101010;
		RGB_reg[3]	<= 24'b10100101_01000011_11010101;
		RGB_reg[4]	<= 24'b10100101_01000011_11010101;
	end
	else	begin
		case (i)
			0,1,2,3:
				if(tx_done)	begin
					data_valid <= 0;
					RGB <= RGB_reg[i];
					i <= i + 1;
				end
			4:
				if(tx_done)	begin
					data_valid <= 1;
					RGB <= RGB_reg[i];
					i <= 0;
				end
			default: i <= 0;
		endcase
	end
end
//------------------------------//

endmodule
