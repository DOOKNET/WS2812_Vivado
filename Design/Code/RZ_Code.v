module RZ_Code(
	input	clk,
	input	rst_n,
	input	data_ready,		//握手信号，拉高开始工作
	input	data_end,		//数据结束信号，在最后一帧时拉高
	input	[23:0]	RGB,	//RGB数据
	output	RZ_data,		//单极性归零码
	output	reg	tx_done		//发送结束标志
);

//--------------------------------------//
reg		data_ready_r0;
reg		data_ready_r1;
wire 	data_ready_pose;	//上升沿
reg		[4:0]	step;		//状态机执行步骤
reg		[31:0]	cnt;		//计数器
reg 	tx_en;				//发送使能信号
reg		RGB_RZ;				//待转换成归零码的RGB数据
reg		data_out;			//单极性归零码
//--------------------------------------//

//--------------检测上升沿--------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		data_ready_r0 <= 0;
		data_ready_r1 <= 0;
	end
	else	begin
		data_ready_r0 <= data_ready;
		data_ready_r1 <= data_ready_r0;
	end
end
//--------------------------------------//
assign	data_ready_pose = data_ready_r0 & ~data_ready_r1;
//----------------状态机-----------------//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n || !data_ready)	begin
		step <= 0;
		cnt <= 0;
		tx_done <= 0;
		RGB_RZ <= 0;
		tx_en <= 0;
	end
	else	begin
		case (step)
			0:
				if(data_ready_pose)	begin			//检测到上升沿，开始工作
					step <= 1;
				end
				else	begin
					step <= 0;
				end
			1:
				if(cnt == 32'd14998)	begin		//RESET时间(300us*50M=15000)
					tx_done <= 1;					//输出脉冲，提醒更新数据
					cnt <= cnt + 1;
				end
				else if(cnt == 32'd14999)	begin	//RESET结束
					cnt <= 0;
					tx_done <= 0;
					tx_en <= 1;
					step <= 2;
				end
				else	begin
					cnt <= cnt + 1;
				end
			2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24:
				if(cnt == 32'd0)	begin
					RGB_RZ <= RGB[25-step];			//从高到低逐次发送24bit
					cnt <= cnt + 1;
				end
				else if(cnt == 32'd62)	begin		//计数一个码元周期(62.5=1.25us * 50M) <<<<<<<<<<<
					cnt <= 0;
					step <= step + 1;
				end
				else	begin
					cnt <= cnt + 1;
				end
			25:
				if((cnt == 32'd30) && data_end)	begin
					step <= step + 1;
					cnt <= cnt + 1;
				end
				else if(cnt == 32'd0)	begin
					RGB_RZ <= RGB[0];
					cnt <= cnt + 1;
				end
				else if(cnt == 32'd61)	begin
					tx_done <= 1;
					cnt <= cnt + 1;
				end
				else if(cnt == 32'd62)	begin
					cnt <= 0;
					tx_done <= 0;
					step <= 2;
				end
				else	begin
					cnt <= cnt + 1;
				end
			26:
				if(cnt == 32'd62)	begin
					cnt <= 0;
					tx_en <= 0;
					step <= 1;
					RGB_RZ <= 0;
				end
				else	begin
					cnt <=cnt + 1;
				end
			default: step <= 1;
		endcase
	end
end
//--------------------------------------//

//-------------单极性归零码--------------//
always @(posedge clk or negedge rst_n) begin
	if((!rst_n) || (!tx_en))	begin
		data_out <= 0;
	end
	else if((RGB_RZ == 0) && (tx_en == 1))	begin
		if(cnt <= 32'd15)	begin		//零码高电平，0.3us*50M=15 <<<<<<<<<<<<<<<<<<
			data_out <= 1;
		end
		else	begin
			data_out <= 0;
		end
	end
	else if((RGB_RZ == 1) && (tx_en == 1))	begin
		if(cnt <= 32'd45)	begin		//一码高电平，0.9us*50M=45 <<<<<<<<<<<<<<<<<<
			data_out <= 1;
		end
		else	begin
			data_out <= 0;
		end
	end
	else	begin
		data_out <= data_out;
	end
end
//----------------------------------------//
assign	RZ_data = data_out;

endmodule
