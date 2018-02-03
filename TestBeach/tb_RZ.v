`timescale	1ns/1ps

module	tb_RZ();

reg 	sclk;
reg 	rst_n;
wire 	RZ_data;

initial	sclk = 1;
always	#10	sclk = ~sclk;

initial	begin
	rst_n = 0;
	#100
	rst_n = 1;
end

//---------------------------//
TOP_r0			TOP_r0_inst(
	.clk		(sclk),
	.rst_n		(rst_n),
	.RZ_data	(RZ_data)
);
//---------------------------//

endmodule
