module clock(CLK_1Hz, reset, select, select_enable, num, second_d, second_g, minute_d, minute_g, hour_d, hour_g, change1,change2,change3);
input CLK_1Hz,change1,change2,change3; //12.24change
input reset,select_enable;
input[2:0] select;
input[3:0] num;
output  reg[3:0] second_d, second_g, minute_d, minute_g, hour_d, hour_g;
wire   cout_s,cout_m;

always @(posedge CLK_1Hz)  
begin  
  if(!reset) second_d<=0;
  else if(select_enable&&select==3'd0)
  begin
		second_d<=num;
  end
  else if(second_d==9)  
    second_d<=0;  
  else  
    second_d<=second_d+1;  
end  
  
always @(posedge CLK_1Hz)  
begin  
  if(!reset) second_g<=5;
  else if(select_enable&&select==3'd1)
  begin
		second_g<=num;
  end  
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
        minute_d <= 9;  
  else if(select_enable&&select==3'd3)
  begin
		minute_d<=num;
  end
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
    minute_g <= 5;
  else if(select_enable&&select==3'd4)
  begin
		minute_g<=num;
  end  
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
        hour_d <= 1;
  else if(select_enable&&select==3'd6)
  begin
		hour_d<=num;
  end
  else if(change1&&(hour_g>=1)&&(hour_d>=2))
  begin
		hour_d<=hour_d-2;
  end
  
  else if(change3&&(hour_g<=1)&&(hour_d<2))
  begin
		hour_d<=hour_d+2;
  end
  
  else if(cout_m&&cout_s&&!change2)  
  begin  
    if((hour_d==3)&&(hour_g==2))  
      hour_d<=0;  
    else  
       if(hour_d==9)  
        hour_d <=0;  
       else  
        hour_d <= hour_d + 1;  
  end
  else if(cout_m&&cout_s&&change2)  
  begin  
    if((hour_d==1)&&(hour_g==1))  
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
        hour_g <= 1; 
  //tz
  else if(select_enable&&select==3'd7)
  begin
		hour_g<=num;
  end
  //24->12
  else if(change1&&(hour_g>=1)&&(hour_d>=2))
  begin
		hour_g<=hour_g-1;
  end
  
  else if(change3&&(hour_g<=1)&&(hour_d<2))
  begin
		hour_g<=hour_g+1;
  end
  
  else if(cout_m&&cout_s&&!change2)  
  begin
      if((hour_d==3)&&(hour_g==2))  
        hour_g <= 0;  
      else if(hour_d==9)  
        hour_g<=hour_g+1;  
  end
  else if(cout_m&&cout_s&&change2)
  begin
      if((hour_d==1)&&(hour_g==1))  
        hour_g <= 0;  
      else if(hour_d==9)  
        hour_g<=hour_g+1;  
  end
end 
endmodule