/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-03-08 22:00:00
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-03-09 17:11:59
 * @Filename     : tb_encode_8b10b.sv
 * @Description  : 8b/10b编码器测试平台（修正存储类问题）
 */

`timescale 1ns/1ps

module tb_encode_8b10b;


//++ 仿真时间尺度 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
timeunit 1ns;
timeprecision 1ps;
//-- 仿真时间尺度 ------------------------------------------------------------


//++ 实例化测试模块 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
localparam [7:0] K_28_0 = 8'b000_11100;
localparam [7:0] K_28_1 = 8'b001_11100;
localparam [7:0] K_28_2 = 8'b010_11100;
localparam [7:0] K_28_3 = 8'b011_11100;
localparam [7:0] K_28_4 = 8'b100_11100;
localparam [7:0] K_28_5 = 8'b101_11100;
localparam [7:0] K_28_6 = 8'b110_11100;
localparam [7:0] K_28_7 = 8'b111_11100;
localparam [7:0] K_23_7 = 8'b111_10111;
localparam [7:0] K_27_7 = 8'b111_11011;
localparam [7:0] K_29_7 = 8'b111_11101;
localparam [7:0] K_30_7 = 8'b111_11110;
logic [7:0] K_ARRAY [12] = {
  K_28_0
  , K_28_1
  , K_28_2
  , K_28_3
  , K_28_4
  , K_28_5
  , K_28_6
  , K_28_7
  , K_23_7
  , K_27_7
  , K_29_7
  , K_30_7
};

logic        clk;
logic        rstn;
logic [7:0]  din_8b;
logic        din_8b_valid;
logic        din_8b_is_k_or_d_n;
logic [9:0]  dout_10b;
logic        dout_10b_valid;
logic din_k_error;
logic dout_k_error;

encode_8b10b #(.ERROR_DETECT_EN(1)) dut(.*);
//-- 实例化测试模块 ------------------------------------------------------------


//++ 生成时钟 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
localparam CLKT = 2;
initial begin
  clk = 0;
  forever #(CLKT / 2) clk = ~clk;
end
//-- 生成时钟 ------------------------------------------------------------


//++ 输出文件句柄 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
integer file;  // 文件指针
//-- 输出文件句柄 ------------------------------------------------------------


//++ 主测试流程 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
localparam DOUT_DELAY = 2; // 输出延迟时钟周期数（与DUT一致）
int cnt;
int k_cnt;
initial begin
  // 模块复位
  rstn = 0;
  #(CLKT*10.5);
  rstn = 1;
  // 初始化
  cnt = 0;
  din_8b = 0;
  din_8b_valid = 0;
  din_8b_is_k_or_d_n = 0;

  // 打开输出文件（若文件已存在则覆盖）
  file = $fopen("C:/_myJGY/17_Markdown/_myOpenSource/verilog-function-module--8b10b_encode/SIM/test.txt", "w");
  if (file == 0) begin
    $error("Failed to open output file");
    $finish;
  end

  #(CLKT*2);
  // ===== 1. 数据码 0~255 正向 =====
  din_8b_valid = 1;
  repeat (256) begin // 0~255
    din_8b_is_k_or_d_n = 0;
    #CLKT;
    din_8b = din_8b + 1;
    cnt = cnt + 1;
  end
  din_8b_valid = 0;  // 停止输入数据

  #(CLKT*2);
  // ===== 2. 控制码（12个码循环3遍） =====
  k_cnt = 0;
  din_8b_valid = 1;
  din_8b_is_k_or_d_n = 1;
  repeat (36) begin // 循环输入12个控制码, 循环3遍
    din_8b = K_ARRAY[k_cnt % 12];
    #CLKT;
    k_cnt = k_cnt + 1;
  end
  din_8b_is_k_or_d_n = 0;
  din_8b_valid = 0;  // 停止输入数据

  #(CLKT*2);
  // ===== 3. 数据码 255~0 倒序 =====
  din_8b_valid = 1;
  din_8b_is_k_or_d_n = 0;
  for (int i = 255; i >= 0; i--) begin
    din_8b = i;
    #CLKT;
  end
  din_8b_valid = 0;

  // 等待所有输出处理完毕（考虑流水线延迟）
  #(CLKT * (DOUT_DELAY + 2));

  // 关闭文件
  $fclose(file);

  // 测试完成
  $display("\n=== test finish !!! ===");
  #(CLKT*10);
  $finish;
end
//-- 主测试流程 ------------------------------------------------------------


//++ 输出数据写入文件 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// 在每个时钟上升沿检查输出有效标志，若有效则将当前10b数据写入文件（十六进制格式）
always @(posedge clk) begin
  if (dout_10b_valid) begin
    $fdisplay(file, "%h", dout_10b);  // 每行一个十六进制值
  end
end
//-- 输出数据写入文件 --------------------------------------------------------


//++ 仿真超时保护 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
initial begin
  #(CLKT * 200000);
  $error("Simulation timeout");
  $finish;
end
//-- 仿真超时保护 ------------------------------------------------------------


endmodule