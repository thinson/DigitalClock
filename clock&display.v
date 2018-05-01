module clock (CLK_50M, time_led, warn_led, sel);  

input         CLK_50M;
output[7:0]   time_led;
output        warn_led;
output[2:0]   sel;
reg[3:0]      hour_g,hour_d,minute_g,minute_d,second_g,second_d;  
wire          cout_s,cout_m;  
wire[3:0]     line;
wire[0:0]     reset;

reg[31:0]     CLK_REG;
reg[31:0]     CLK_REG2;
reg[31:0]     CLK_REG3;
reg[3:0]      disp_data;
reg           CLK_1Hz;
reg           CLK_2Hz;
reg           CLK_1kHz;
reg[7:0]      time_led_reg;
reg           warn_led_reg;        
reg[2:0]      sel_reg;

assign line=4'd10;
assign reset=1'b1;
/**************分频模块***************/

//1hz分频
always @(posedge CLK_50M)
begin
   CLK_REG <= (CLK_REG == 32'd50000000)? 32'd0:(CLK_REG + 1'd1);
   CLK_1Hz <= (CLK_REG > 32'd25000000)? 1'b0:1'b1;
end

//2hz分频
always @(posedge CLK_50M)
begin
   CLK_REG2 <= (CLK_REG2 == 32'd25000000)? 32'd0:(CLK_REG2 + 1'd1);
   CLK_2Hz <= (CLK_REG2 > 32'd12500000)? 1'b0:1'b1;
end

//1khz分频
always @(posedge CLK_50M)
begin
   CLK_REG3 <= (CLK_REG3 == 32'd50000)? 32'd0:(CLK_REG3 + 1'd1);
   CLK_1kHz <= (CLK_REG3 > 32'd25000)? 1'b0:1'b1;
end


/*************时钟显示逻辑************/
always @(posedge CLK_1Hz)  
begin  
  if(!reset) second_d<=0;  
  else if(second_d==9)  
    second_d<=0;  
  else  
    second_d<=second_d+1;  
end  
  
always @(posedge CLK_1Hz)  
begin  
  if(!reset) second_g<=0;  
  else if(second_d==9)  
    begin  
      if(second_g==5)  
        second_g<=0;  
      else  
        second_g<=second_g+1;  
    end  
  end  
assign cout_s=((second_d==9)&&(second_g==5))?1:0;  
  
always @(posedge CLK_1Hz)  
begin  
  if(!reset)  
        minute_d <= 0;  
  else if(cout_s)  
    begin  
     if(minute_d==9)  
        minute_d <= 0;  
     else   
        minute_d <=minute_d+1;  
    end  
end  
  
always @(posedge CLK_1Hz)  
begin  
  if(!reset)  
    minute_g <= 0;  
  else if(cout_s)  
    begin  
    if(minute_d==9)  
      begin  
      if(minute_g==5)  
        minute_g <= 0;  
      else   
        minute_g<= minute_g+1;  
      end  
    end  
end  
  
assign cout_m = ((minute_d==9)&&(minute_g==5))?1:0;  
  
always @(posedge CLK_1Hz)  
begin  
  if(!reset)  
        hour_d <= 0;  
  else if(cout_m&&cout_s)  
  begin  
    if((hour_d==3)&&(hour_g==2))  
      hour_d<=0;  
    else  
       if(hour_d==9)  
        hour_d <=0;  
       else  
        hour_d <= hour_d + 1;  
  end  
end  
  
always @(posedge CLK_1Hz)  
begin  
  if(!reset)  
        hour_g <= 0;  
  else if(cout_m&&cout_s)  
  begin  
      if((hour_d==3)&&(hour_g==2))  
        hour_g <= 0;  
      else if(hour_d==9)  
        hour_g<=hour_g+1;  
  end  
end  


/*****************调整时间模块*********************/
/*
always @(posedge CLK_1Hz)  
begin  
    if(add_s)  
      begin  
        if((hour_d==3)&&(hour_g==2))  
          begin  
            hour_g<=0;  
            hour_d<=0;  
          end  
        else  
          if(hour_d==9)  
            begin  
              hour_d<=0;  
              hour_g<=hour_g+1;  
            end  
          else  
            hour_d<=hour_d+1;  
      end  
    end  
      
    always @(posedge CLK_1Hz)  
    begin  
     if(add_f)  
        begin  
          if((minute_d==9)&&(minute_g==5))  
            begin  
              minute_d<=0;  
              minute_g<=0;  
            end  
          else   
            if(minute_d==9)  
              begin  
                minute_d<=0;  
                minute_g<=minute_g+1;  
              end  
            else  
              minute_d<=minute_d+1;  
        end  
      end  
      */

/********************整点报时模块*********************/  
always @(posedge CLK_2Hz)  
begin  
    if(!reset)   
    begin  
        warn_led_reg<=0;  
        end  
    else 
        begin
          if((minute_g==5)&&(minute_d==9)) 
            begin  
              if(second_g==5)  
                begin  
                  if((second_d==5)||(second_d==6)||(second_d==7)||(second_d==8)||(second_d==9))  
                    warn_led_reg<=1;  
                  else  
                    begin  
                    warn_led_reg<=0;  
                    end  
                end
            end
          if((minute_g==0)&&(minute_d==0)&&(second_g==0)&&(second_d==0))  
            warn_led_reg<=1;
        end	
      end  

/***********************数码管显示模块***************************/
//位选信号控制,1khz作为时钟信号
always@(posedge CLK_1kHz)
begin
    if(!reset)
        sel_reg<=3'd0;
    else if(sel_reg == 3'd7)
        sel_reg<=3'd0;
    else
        sel_reg<=sel_reg+1'b1;
end

//输出内容传入disp_data
always@(*)
    if(!reset)
        disp_data<=4'd0;
    else      
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
        default : time_led_reg<=8'hff;
        endcase
    end
end

assign time_led = time_led_reg;
assign warn_led = warn_led_reg;
assign sel = sel_reg;
endmodule  