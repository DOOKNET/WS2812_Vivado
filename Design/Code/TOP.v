module TOP(
	input	clk,
	input	rst_n,
	output 	RZ_data
);
//-------------------------------//
wire 	data_ready;
wire 	data_valid;
wire 	[23:0]	RGB;
wire 	tx_done;
//-------------------------------//

//-------------------------------//
RGB_Control			RGB_Control_inst0(
	.clk			(clk),
	.rst_n			(rst_n),
	.tx_done		(tx_done),
	.data_ready		(data_ready),
	.data_valid		(data_valid),
	.RGB			(RGB)
);
//-------------------------------//
RZ_Code				RZ_Code_inst1(
	.clk			(clk),
	.rst_n			(rst_n),
	.data_ready		(data_ready),
	.data_end		(data_valid),		
	.RGB			(RGB),
	.RZ_data		(RZ_data),	
	.tx_done		(tx_done)
);

endmodule
