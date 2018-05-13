module display(CLK_1kHz, CLK_2Hz, second_d, second_g, minute_d, minute_g, hour_d, hour_g, time_led, warn_led, sel,ms_d, ms_g, second_dd, second_gg,minute_dd, minute_gg, switch);
input CLK_1kHz, CLK_2Hz;
input switch;
input[3:0] second_d, second_g, minute_d, minute_g, hour_d, hour_g;
input[3:0] ms_d, ms_g, second_dd, second_gg,minute_dd, minute_gg;
output[7:0]   time_led;
output        warn_led;
output[2:0]   sel;

reg[7:0]    time_led_reg;
reg        warn_led_reg;
reg[2:0]   sel_reg;
reg[3:0]   disp_data;
wire   reset;
reg    line_count;
reg[3:0]    line;
assign reset=1'b1;
//time
always@(posedge CLK_1kHz)
begin
    if(!reset)
        sel_reg<=3'd0;
    else if(sel_reg == 3'd7)
        sel_reg<=3'd0;
    else
        sel_reg<=sel_reg+1'b1;
end
//line

always@(posedge CLK_2Hz)
begin
	line_count<=~line_count;
	if(line_count==0) line<=4'd10;
	else line<=4'd11;
	
end

//输出内容传入disp_data
always@(*)
    if(!reset)
        disp_data<=4'd0;
    else
    begin
		if(switch==0)
		begin
        case(sel)
            0:disp_data<=hour_g;
            1:disp_data<=hour_d;
            2:disp_data<=line;
            3:disp_data<=minute_g;
            4:disp_data<=minute_d;
            5:disp_data<=line;
            6:disp_data<=second_g;
            7:disp_data<=second_d;
            default :disp_data<=4'd0;
        endcase
		end
		
		else if(switch==1)
		begin
        case(sel)
            0:disp_data<=minute_gg;
            1:disp_data<=minute_dd;
            2:disp_data<=line;
            3:disp_data<=second_gg;
            4:disp_data<=second_dd;
            5:disp_data<=line;
            6:disp_data<=ms_g;
            7:disp_data<=ms_d;
            default :disp_data<=4'd0;
        endcase
		end
	end

//always@(*)
//disp_data<=4'd9;

always@(*)
begin
    if(!reset)
        time_led_reg<=8'hff;
    else
    begin
        case(disp_data)
        4'd0: time_led_reg<=8'b11111100;
        4'd1: time_led_reg<=8'b01100000;
        4'd2: time_led_reg<=8'b11011010;
        4'd3: time_led_reg<=8'b11110010;
        4'd4: time_led_reg<=8'b01100110;
        4'd5: time_led_reg<=8'b10110110;
        4'd6: time_led_reg<=8'b10111110;
        4'd7: time_led_reg<=8'b11100000;
        4'd8: time_led_reg<=8'b11111110;
        4'd9: time_led_reg<=8'b11110110;
        4'd10: time_led_reg<=8'b00000010;
        4'd11: time_led_reg<=8'b00000000;
        default : time_led_reg<=8'hff;
        endcase
    end
end



//warn
always @(posedge CLK_2Hz)  
begin  
    if(!reset)   
    begin  
        warn_led_reg<=0;
        end  
    else
	    begin
			if(second_g==5&&second_d>=5&&minute_d==9&&minute_g==5)
				warn_led_reg<=~warn_led_reg;
			else warn_led_reg<=0;
		end
end

assign time_led = time_led_reg;
assign warn_led = warn_led_reg;
assign sel = sel_reg;

endmodule