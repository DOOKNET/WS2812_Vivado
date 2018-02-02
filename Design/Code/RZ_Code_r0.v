module RZ_Code_r0(
	input	clk,
	input	rst_n,
	input	data_ready,		//握手信号，拉高开始工作
	input	data_valid,		//数据结束信号，在最后一帧时拉高
	input	[23:0]	RGB,	//RGB数据
	output	RZ_data,		//单极性归零码
	output	tx_done			//发送结束标志
);

//----------------------------//
reg		data_ready_r0;		//存储输入信号
reg		data_ready_r1;
wire 	data_ready_pose;	//上升沿
reg		[4:0]	step;		//状态机执行步骤


//---------检测上升沿---------//
always @(posedge clk negedge rst_n) begin
	if(!rst_n)	begin
		data_ready_r0 <= 0;
		data_ready_r1 <= 0;
	end
	else	begin
		data_ready_r0 <= data_ready;
		data_ready_r1 <= data_ready_r0;
	end
end
//----------------------------//
assign	data_ready_pose = data_ready_r0 & ~data_ready_r1;
//-----------状态机------------//
always @(posedge clk negedge rst_n) begin
	if(!rst_n || !data_ready)	begin
		step <= 0;
	end
	else	begin
		case (step)
		0:
			if(data_ready_pose)	begin
				step <= 1;
			end
			else	begin
				step <= 0;
			end
		1:
			if(cnt_rst == )
		  default: 
		endcase
end


//----------------------------//
//----------------------------//

//----------------------------//
//----------------------------//


endmodule