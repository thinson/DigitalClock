module control(clk, key_value, key_flag, reset, select,sel_enable, num, wrong_led,change1, change2,change3,switch, stop, watch_reset,hour_g,hour_d,minute_g,minute_d,second_g,second_d);
input clk, key_flag;
input[3:0] key_value,hour_g, hour_d,minute_g,minute_d,second_g,second_d;
output  reset;
output reg[2:0]  select;
output reg sel_enable;
output reg  change1,change2,change3,stop,switch,watch_reset;
output    num;
output reg wrong_led;
reg reset;
reg[3:0] num;
reg[2:0] count;
reg      count2; //12_to_24

/*
key_value 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
key       D # 0 * C 9 8 7 B 6  5  4  A  3  2  1
*/

always@(posedge clk)
begin
	if((key_value==4'd3)&&(key_flag)) begin reset<=0;end
	else begin reset<=1;end
	
	if((key_value==4'd0)&&(key_flag)&&(switch==1)) begin watch_reset<=0;end
	else begin watch_reset<=1;end
	
	//if((key_value==4'd8)&&key_flag) switch<=~switch;
	
	//if((key_value==4'd12)&&key_flag) count2<=~count2;
	
	//if((key_value==4'd4)&&key_flag&&switch)  stop<=~stop;
	
	/*case(key_value)
		4'd15: num<=1;
		4'd14: num<=2;
		4'd13: num<=3;
		4'd11: num<=4;
		4'd10: num<=5;
		4'd9: num<=6;
		4'd7: num<=7;
		4'd6: num<=8;
		4'd5: num<=9;
		4'd2: num<=0;
	endcase*/
	
	
	//12->24 or 24->12 
	if((!count2)&&(key_flag)) begin change1<=1;end
	else begin change1<=0;end
	
	if(count2) change2<=1;
	else change2<=0;
	
	if((count2)&&(key_flag))begin change3<=1;end
	else begin change3<=0;end
	//stopwatch
	
	
end

always@(posedge clk)
begin
	if(count!=0)
	begin
		sel_enable<=1;
		case(count)
			1:select<=3'b000;
			2:select<=3'b001;
			3:select<=3'b011;
			4:select<=3'b100;
			5:select<=3'b110;
			6:select<=3'b111;
		endcase
	end
	else sel_enable<=0;
	if(sel_enable)
	begin
		if(select==1&&num>=6) begin wrong_led<=1;sel_enable<=0;end
		if(select==4&&num>=6) begin wrong_led<=1;sel_enable<=0;end
		if(select==6&&num>=4&&(hour_g==4'd2)) begin wrong_led<=1;sel_enable<=0;end
		if(select==7&&num>=3&&(hour_d<4'd4)) begin wrong_led<=1;sel_enable<=0;end
		else if(select==7&&num>1&&(hour_d>=4'd4)) begin wrong_led<=1;sel_enable<=0;end
	end
	else  wrong_led<=0;
end


always@(negedge key_flag)
begin
	case(key_value)
	4'd8: switch<=~switch;
	4'd1: 
		begin
		if(count==6) count<=0;
		else
		begin
		case(count)
			0: num<=second_d;
			1: num<=second_g;
			2: num<=minute_d;
			3: num<=minute_g;
			4: num<=hour_d;
			5: num<=hour_g;
		endcase
		count<=count+1;
		end
		end
	4'd12: count2<=~count2;
	4'd4:  stop<=~stop;
    4'd15: if(sel_enable) num<=1;
	4'd14: if(sel_enable)num<=2;
	4'd13: if(sel_enable)num<=3;
	4'd11: if(sel_enable)num<=4;
	4'd10: if(sel_enable)num<=5;
	4'd9: if(sel_enable)num<=6;
	4'd7: if(sel_enable)num<=7;
	4'd6: if(sel_enable)num<=8;
	4'd5: if(sel_enable)num<=9;
	4'd2: if(sel_enable)num<=0;
	endcase
	/*if(key_value==4'd8) switch=~switch;
	if(key_value==4'd1)
	begin
		count<=count+1;
		if(count==7) count<=0;
	end*/
	//else if(key_value==4'd12) count2=~count2;
	
	//if(switch&&(key_value==4'd4)) stop=~stop;
end

//about stopwatch



endmodule

		