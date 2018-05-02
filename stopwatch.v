module stopwatch(CLK_100Hz,reset,stop, ms_d, ms_g, second_d, second_g,minute_d, minute_g);
input CLK_100Hz,reset,stop;
output reg[3:0] ms_d, ms_g, second_d, second_g,minute_d, minute_g;


always @(posedge CLK_100Hz)  
begin  
  if(!reset) ms_d<=0;
  else if(stop) ms_d<=ms_d;
  else if(ms_d==9)  
    ms_d<=0;  
  else  
    ms_d<=ms_d+1;  
end  
  
always @(posedge CLK_100Hz)  
begin  
  if(!reset) ms_g<=0;
  else if(stop) ms_g<=ms_g;  
  else if(ms_d==9)  
    begin  
      if(ms_g==9)  
        ms_g<=0;  
      else  
        ms_g<=ms_g+1;  
    end  
  end  
assign cout_s=((ms_d==9)&&(ms_g==9))?1:0;  
  
always @(posedge CLK_100Hz)  
begin  
  if(!reset)  
        second_d <= 0;
  else if(stop) second_d<=second_d;  
  else if(cout_s)  
    begin  
     if(second_d==9)  
        second_d <= 0;  
     else   
        second_d <=second_d+1;  
    end  
end  
  
always @(posedge CLK_100Hz)  
begin  
  if(!reset)  
    second_g <= 0; 
  else if(stop) minute_g<=minute_g; 
  else if(cout_s)  
    begin  
    if(second_d==9)  
      begin  
      if(second_g==5)  
        second_g <= 0;  
      else   
        second_g<= second_g+1;  
      end  
    end  
end  
  
assign cout_m = ((second_d==9)&&(second_g==5))?1:0;  
  
always @(posedge CLK_100Hz)  
begin  
  if(!reset)  
        minute_d <= 0;  
  else if(stop) minute_d<=minute_d;
  else if(cout_m&&cout_s)  
  begin  
       if(minute_d==9)  
        minute_d <=0;  
       else  
        minute_d <= minute_d + 1;  
  end  
end  
  
always @(posedge CLK_100Hz)  
begin  
  if(!reset)  
        minute_g <= 0;  
  else if(stop) minute_g<=minute_g;
  else if(cout_m&&cout_s)  
  begin  
      if(minute_d==9)  
        minute_g<=minute_g+1;  
  end  
end
 
endmodule 