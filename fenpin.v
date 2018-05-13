module fenpin (clk,clk_1HZ,clk_2HZ,clk_100HZ,clk_1KHZ,high);
input clk;
output clk_1HZ,clk_2HZ,clk_100HZ,clk_1KHZ,high;
reg clk_1HZ,clk_2HZ,clk_100HZ,clk_1KHZ,high;
reg[26:0] count1=0,count2=0,count3=0,count4=0;
always@(*)
begin
	high<=1;
end

always@(posedge clk)
begin 
        count1<=count1+1;

        if(count1<25000000)
                clk_1HZ<=1;
        else if(count1<49999999)
                clk_1HZ<=0;
        if(count1==49999999)
                count1<=0;
            
        count2<=count2+1;
        
        if(count2<12500000)
                clk_2HZ<=1;
        else if(count2<24999999)
                clk_2HZ<=0;  
        if(count2==24999999)
                count2<=0;
            
        count3<=count3+1;

        if(count3<250000)
                clk_100HZ<=1;
        else if(count3<499999)
                clk_100HZ<=0;  
        if(count3==499999)
                count3<=0;
                
        count4<=count4+1;

        if(count4<25000)
                clk_1KHZ<=1;
        else if(count4<49999)
                clk_1KHZ<=0;  
        if(count4==49999)
                count4<=0;

end
endmodule
