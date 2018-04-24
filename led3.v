module led3
(
   CLK_50MHz,
   switch,
   column,
   //列
   row
   //行

);
//时钟脉冲，开关，列，行声明

input           CLK_50MHz;
input   [7:0]   switch; 
//输入声明
output   [15:0]  column;
output   [15:0]  row;
//输出声明
reg   [15:0]   column_reg;
reg   [15:0]   row_reg;

reg   [31:0]   time_js = 32'h0;
reg   [31:0]   time_js_n = 32'h0;
reg   [31:0]   time_js2 = 32'h0;
reg   [31:0]   time_js2_n = 32'h0;
reg   [15:0]   column_n = 16'h1;
reg   [15:0]   row_n = 16'h0;
reg   [7:0]    switch_reg = 8'h0;
reg   [3:0]    js;
reg   [3:0]    js2;
reg   [3:0]    js_n = 4'h0;
reg   [15:0]   name_reg [0:15];
reg   [15:0]   number_reg2 [0:15];
reg   [15:0]   number_reg [0:15];
//？？
reg   [31:0]   CLK_REG;
reg   [31:0]   CLK_REG2;
reg            CLK_10KHz;
reg            CLK_10Hz;
//寄存器定义

parameter   [31:0] time_5ms = 32'd5;
parameter   [31:0] time_20ms = 32'd1000000;
parameter   [3:0]  set_js = 4'd15;
parameter   [5:0]  set_js2 = 6'd31;
//常量定义

always @(*)
begin
name_reg[0] = 16'h0100;
name_reg[1] = 16'h0000;
name_reg[2] = 16'h00FC;
name_reg[3] = 16'hFF44;
name_reg[4] = 16'h0054;
name_reg[5] = 16'h0254;
name_reg[6] = 16'h0254;
name_reg[7] = 16'h0255;
name_reg[8] = 16'h02FE;
name_reg[9] = 16'hFF54;
name_reg[10] = 16'h0254;
name_reg[11] = 16'h0254;
name_reg[12] = 16'h02F4;
name_reg[13] = 16'h0244;
name_reg[14] = 16'h1E44;
name_reg[15] = 16'h0000;
// 名字信息
number_reg[0] = 16'h0000;
number_reg[1] = 16'h0300;
number_reg[2] = 16'h02F2;
number_reg[3] = 16'h0292;
number_reg[4] = 16'h0292;
number_reg[5] = 16'h009E;
number_reg[6] = 16'h0000;
number_reg[7] = 16'h0000;
number_reg[8] = 16'h03F2;
number_reg[9] = 16'h0292;
number_reg[10] = 16'h0292;
number_reg[11] = 16'h029E;
number_reg[12] = 16'h0300;
number_reg[13] = 16'h0000;
number_reg[14] = 16'h0000;
number_reg[15] = 16'h0000;
//学号信息



end
//姓名和学号的定义，采用16进制，节省空间

always @(posedge CLK_50MHz)
begin
   CLK_REG <= (CLK_REG == 32'd5000)? 32'd0:(CLK_REG + 1'd1);
   //将50Mhz的时钟分频成10khz
   CLK_10KHz <= (CLK_REG > 32'd2500)? 1'b0:1'b1;
   //
end

//
always @(posedge CLK_50MHz)
begin
   CLK_REG2 <= (CLK_REG2 == 32'd5000000)? 32'd0:(CLK_REG2 + 1'd1);
   CLK_10Hz <= (CLK_REG2 > 32'd2500000)? 1'b0:1'b1;
   
end



always @(*)
begin
   if(time_js == time_5ms)
      time_js <= 32'h0;
   else
      time_js <= time_js + 32'h1;
end

//
always @(posedge CLK_10KHz)
begin
   js <= (js == set_js)? 4'h0:(js + 1'd1);
end
//

//
always @(posedge CLK_10Hz)
begin
   js2 <= (js2 == 4'h0)? set_js2:(js2 - 1'd1);
end
//



//
always @(posedge CLK_50MHz)
begin
   column_reg <= column_n;
   row_reg <= row_n;
   
end
//
always @(*)
begin

if((switch[0] == 1'b0) && (switch[1] == 1'b0) )
begin
   case(js)
      4'd0 :begin column_n = 16'b0000000000000001; end
      4'd1 :begin column_n = 16'b0000000000000010; end
      4'd2 :begin column_n = 16'b0000000000000100; end
      4'd3 :begin column_n = 16'b0000000000001000; end
      4'd4 :begin column_n = 16'b0000000000010000; end
      4'd5 :begin column_n = 16'b0000000000100000; end
      4'd6 :begin column_n = 16'b0000000001000000; end
      4'd7 :begin column_n = 16'b0000000010000000; end
      4'd8 :begin column_n = 16'b0000000100000000; end
      4'd9 :begin column_n = 16'b0000001000000000; end
      4'd10 :begin column_n = 16'b0000010000000000; end
      4'd11 :begin column_n = 16'b0000100000000000; end
      4'd12 :begin column_n = 16'b0001000000000000; end
      4'd13 :begin column_n = 16'b0010000000000000; end
      4'd14 :begin column_n = 16'b0100000000000000; end
      4'd15 :begin column_n = 16'b1000000000000000; end
   endcase
   
      row_n = ~name_reg[js];
end

if((switch[0] == 1'b0) && (switch[1] == 1'b1) )
begin
   case(js)
      4'd0 :begin column_n = 16'b0000000000000001; end
      4'd1 :begin column_n = 16'b0000000000000010; end
      4'd2 :begin column_n = 16'b0000000000000100; end
      4'd3 :begin column_n = 16'b0000000000001000; end
      4'd4 :begin column_n = 16'b0000000000010000; end
      4'd5 :begin column_n = 16'b0000000000100000; end
      4'd6 :begin column_n = 16'b0000000001000000; end
      4'd7 :begin column_n = 16'b0000000010000000; end
      4'd8 :begin column_n = 16'b0000000100000000; end
      4'd9 :begin column_n = 16'b0000001000000000; end
      4'd10 :begin column_n = 16'b0000010000000000; end
      4'd11 :begin column_n = 16'b0000100000000000; end
      4'd12 :begin column_n = 16'b0001000000000000; end
      4'd13 :begin column_n = 16'b0010000000000000; end
      4'd14 :begin column_n = 16'b0100000000000000; end
      4'd15 :begin column_n = 16'b1000000000000000; end
   endcase
   
      row_n = ~number_reg[js];
end

if((switch[0] == 1'b1) && (switch[1] == 1'b0) )
begin
   case(js + js2)
      4'd0 :begin column_n = 16'b0000000000000001; end
      4'd1 :begin column_n = 16'b0000000000000010; end
      4'd2 :begin column_n = 16'b0000000000000100; end
      4'd3 :begin column_n = 16'b0000000000001000; end
      4'd4 :begin column_n = 16'b0000000000010000; end
      4'd5 :begin column_n = 16'b0000000000100000; end
      4'd6 :begin column_n = 16'b0000000001000000; end
      4'd7 :begin column_n = 16'b0000000010000000; end
      4'd8 :begin column_n = 16'b0000000100000000; end
      4'd9 :begin column_n = 16'b0000001000000000; end
      4'd10 :begin column_n = 16'b0000010000000000; end
      4'd11 :begin column_n = 16'b0000100000000000; end
      4'd12 :begin column_n = 16'b0001000000000000; end
      4'd13 :begin column_n = 16'b0010000000000000; end
      4'd14 :begin column_n = 16'b0100000000000000; end
      4'd15 :begin column_n = 16'b1000000000000000; end
   endcase
   
      row_n = ~name_reg[js];
end

if((switch[0] == 1'b1) && (switch[1] == 1'b1) )
begin

number_reg2[0] = (number_reg[0] << js2) | (number_reg[0] >> (4'd15 - js2));
number_reg2[1] = (number_reg[1] << js2) | (number_reg[1] >> (4'd15 - js2));
number_reg2[2] = (number_reg[2] << js2) | (number_reg[2] >> (4'd15 - js2));
number_reg2[3] = (number_reg[3] << js2) | (number_reg[3] >> (4'd15 - js2));
number_reg2[4] = (number_reg[4] << js2) | (number_reg[4] >> (4'd15 - js2));
number_reg2[5] = (number_reg[5] << js2) | (number_reg[5] >> (4'd15 - js2));
number_reg2[6] = (number_reg[6] << js2) | (number_reg[6] >> (4'd15 - js2));
number_reg2[7] = (number_reg[7] << js2) | (number_reg[7] >> (4'd15 - js2));
number_reg2[8] = (number_reg[8] << js2) | (number_reg[8] >> (4'd15 - js2));
number_reg2[9] = (number_reg[9] << js2) | (number_reg[9] >> (4'd15 - js2));
number_reg2[10] = (number_reg[10] << js2) | (number_reg[10] >> (4'd15 - js2));
number_reg2[11] = (number_reg[11] << js2) | (number_reg[11] >> (4'd15 - js2));
number_reg2[12] = (number_reg[12] << js2) | (number_reg[12] >> (4'd15 - js2));
number_reg2[13] = (number_reg[13] << js2) | (number_reg[13] >> (4'd15 - js2));
number_reg2[14] = (number_reg[14] << js2) | (number_reg[14] >> (4'd15 - js2));
number_reg2[15] = (number_reg[15] << js2) | (number_reg[15] >> (4'd15 - js2));
   case(js)
      4'd0 :begin column_n = 16'b0000000000000001; end
      4'd1 :begin column_n = 16'b0000000000000010; end
      4'd2 :begin column_n = 16'b0000000000000100; end
      4'd3 :begin column_n = 16'b0000000000001000; end
      4'd4 :begin column_n = 16'b0000000000010000; end
      4'd5 :begin column_n = 16'b0000000000100000; end
      4'd6 :begin column_n = 16'b0000000001000000; end
      4'd7 :begin column_n = 16'b0000000010000000; end
      4'd8 :begin column_n = 16'b0000000100000000; end
      4'd9 :begin column_n = 16'b0000001000000000; end
      4'd10 :begin column_n = 16'b0000010000000000; end
      4'd11 :begin column_n = 16'b0000100000000000; end
      4'd12 :begin column_n = 16'b0001000000000000; end
      4'd13 :begin column_n = 16'b0010000000000000; end
      4'd14 :begin column_n = 16'b0100000000000000; end
      4'd15 :begin column_n = 16'b1000000000000000; end
   endcase
   
      row_n = ~number_reg2[js];
end

end

assign column = column_reg;
assign row = row_reg;

endmodule