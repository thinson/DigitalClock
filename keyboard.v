module keyboard(clk, reset, row, col, key_value,key_flag);
input clk,reset;
input [3:0] row;
output [3:0] col;
output [3:0] key_value;
output key_flag;

reg [3:0] col;
reg [3:0] key_value;
reg [2:0] state;  //状态标志
reg key_flag;   //按键标志位
reg [3:0] col_reg;  //寄存扫描列值
reg [3:0] row_reg;  //寄存扫描行值

always @(posedge clk)
	if(!reset) begin col<=4'b0000;state<=0;end
	else
	begin
		case (state)
			0:
			begin
				col[3:0]<=4'b0000;
				key_flag<=1'b0;
				if(row[3:0]!=4'b1111) begin state<=1;col[3:0]<=4'b1110;end //有键按下，扫描第一行
				else state<=0;
			end
			1: 
			begin
				if(row[3:0]!=4'b1111) begin state<=5;end   //判断是否是第一行
				else  begin state<=2;col[3:0]<=4'b1101;end  //扫描第二行
			end
			2:
			begin   
				if(row[3:0]!=4'b1111) begin state<=5;end    //判断是否是第二行
				else  begin state<=3;col[3:0]<=4'b1011;end  //扫描第三行
			end
			3:
			begin   
				if(row[3:0]!=4'b1111) begin state<=5;end   //判断是否是第三一行
				else  begin state<=4;col[3:0]<=4'b0111;end  //扫描第四行
			end
			4:
			begin   
				if(row[3:0]!=4'b1111) begin state<=5;end  //判断是否是第一行
				else  state<=0;
			end
			5:
			begin 
				if(row[3:0]!=4'b1111)
				begin
					col_reg<=col;  //保存扫描列值
					row_reg<=row;  //保存扫描行值
					state<=5;
					key_flag<=1'b1;  //有键按下
				end            
				else
					begin state<=0;end
			end   
		endcase
	end

 always @(clk or col_reg or row_reg)
 begin
 if(key_flag==1'b1)
                begin
                     case ({col_reg,row_reg})
                      8'b1110_1110:key_value<=0;
                      8'b1110_1101:key_value<=1;
                      8'b1110_1011:key_value<=2;
                      8'b1110_0111:key_value<=3;
                      8'b1101_1110:key_value<=4;
                      8'b1101_1101:key_value<=5;
                      8'b1101_1011:key_value<=6;
                      8'b1101_0111:key_value<=7;
                      8'b1011_1110:key_value<=8;
                      8'b1011_1101:key_value<=9;
                      8'b1011_1011:key_value<=10;
                      8'b1011_0111:key_value<=11;
                      8'b0111_1110:key_value<=12;
                      8'b0111_1101:key_value<=13;
                      8'b0111_1011:key_value<=14;
                      8'b0111_0111:key_value<=15;    
                     endcase
              end  
end  
   
endmodule