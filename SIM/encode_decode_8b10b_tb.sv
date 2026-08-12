/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-03-08 22:00:00
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-08-12 14:37:21
 * @Filename     : encode_decode_8b10b_tb.sv
 * @Description  : 8b/10b编码器+解码器联合测试平台
 *                 自动比对解码输出与原始输入
 */

`timescale 1ns/1ps

module encode_decode_8b10b_tb;

timeunit 1ns;
timeprecision 1ps;

// ---------- 参数与信号 ----------
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
  K_28_0, K_28_1, K_28_2, K_28_3,
  K_28_4, K_28_5, K_28_6, K_28_7,
  K_23_7, K_27_7, K_29_7, K_30_7
};

logic        clk;
logic        rstn;
logic [7:0]  din_8b;
logic        din_8b_valid;
logic        din_8b_is_k_or_d_n;   // 1: K码, 0: D码
logic [9:0]  dout_10b;
logic        dout_10b_valid;
logic        din_k_error;
logic        dout_k_error;

// 解码器信号
logic [7:0]  dec_dout_8b;
logic        dec_dout_8b_is_k;
logic        dec_dout_8b_valid;
logic        dec_dout_8b_error;

// ---------- 实例化编码器（显式连接，只连接实际存在的端口）----------
encode_8b10b #(
    .ERROR_DETECT_EN(1)
) dut_enc (
    .clk                (clk),
    .rstn               (rstn),
    .din_8b             (din_8b),
    .din_8b_valid       (din_8b_valid),
    .din_8b_is_k_or_d_n (din_8b_is_k_or_d_n),
    .dout_10b           (dout_10b),
    .dout_10b_valid     (dout_10b_valid),
    .din_k_error        (din_k_error),
    .dout_k_error       (dout_k_error)
);

// ---------- 实例化解码器（显式连接，暂时无复位，建议后续给解码器添加rstn）----------
decode_10b8b u_dec (
    .din_10b       (dout_10b),
    .din_10b_valid (dout_10b_valid),
    .dout_8b       (dec_dout_8b),
    .dout_8b_is_k  (dec_dout_8b_is_k),
    .dout_8b_valid (dec_dout_8b_valid),
    .dout_8b_error (dec_dout_8b_error),
    .clk           (clk)
);

// ---------- 时钟 ----------
localparam CLKT = 2;
initial begin
  clk = 0;
  forever #(CLKT/2) clk = ~clk;
end

// ---------- 文件输出 ----------
integer file;

// ---------- 期望数据队列（用于自动比对）----------
// 每项格式：bit8 = is_k, bit7:0 = data
logic [8:0] exp_q [$];

// ---------- 主测试流程 ----------
int cnt;
int k_cnt;
initial begin
  // 复位
  rstn = 0;
  #(CLKT*9.51);
  rstn = 1;

  cnt   = 0;
  din_8b = 0;
  din_8b_valid = 0;
  din_8b_is_k_or_d_n = 0;

  file = $fopen("C:/_myJGY/17_Markdown/_myOpenSource/verilog-function-module--8b10b_encode/SIM/test.txt", "w");
  if (file == 0) begin
    $error("Failed to open output file");
    $finish;
  end

  #(CLKT*2);

  // ===== 1. 数据 0~255 =====
  din_8b_valid = 1;
  repeat (256) begin
    din_8b_is_k_or_d_n = 0;
    #CLKT;
    din_8b = din_8b + 1;
    cnt = cnt + 1;
  end
  din_8b_valid = 0;

  #(CLKT*2);

  // ===== 2. 控制码（12个码循环3遍）=====
  k_cnt = 0;
  din_8b_valid = 1;
  din_8b_is_k_or_d_n = 1;
  repeat (36) begin
    din_8b = K_ARRAY[k_cnt % 12];
    #CLKT;
    k_cnt = k_cnt + 1;
  end
  din_8b_is_k_or_d_n = 0;
  din_8b_valid = 0;

  #(CLKT*2);

  // ===== 3. 数据 255~0 倒序 =====
  din_8b_valid = 1;
  din_8b_is_k_or_d_n = 0;
  for (int i = 255; i >= 0; i--) begin
    din_8b = i;
    #CLKT;
  end
  din_8b_valid = 0;

  // 等待流水线排空（编码延迟+解码延迟+余量）
  #(CLKT * 10);

  // 关闭文件
  $fclose(file);

  // 检查队列是否已空（意味着所有输出均已比对）
  if (exp_q.size() != 0) begin
    $error("ERROR: Expected queue not empty, size = %0d", exp_q.size());
  end

  $display("\n=== Test finished !!! ===");
  #(CLKT*10);
  $finish;
end

// ---------- 期望数据入队（在输入有效时）----------
always @(posedge clk) begin
  if (din_8b_valid) begin
    exp_q.push_back({din_8b_is_k_or_d_n, din_8b});
  end
end

// ---------- 解码输出比对与错误检查 ----------
always @(posedge clk) begin
  if (dec_dout_8b_valid) begin
    logic [8:0] exp;
    if (exp_q.size() == 0) begin
      $error("Decode output valid but no expected data in queue");
    end else begin
      exp = exp_q.pop_front();
      // 检查 is_k 标志
      if (exp[8] !== dec_dout_8b_is_k) begin
        $error("IS_K mismatch: exp=%0b, got=%0b at time %t",
               exp[8], dec_dout_8b_is_k, $time);
      end
      // 检查数据
      if (exp[7:0] !== dec_dout_8b) begin
        $error("DATA mismatch: exp=0x%h, got=0x%h at time %t",
               exp[7:0], dec_dout_8b, $time);
      end
      // 检查解码错误标志（合法输入不应报错）
      if (dec_dout_8b_error) begin
        $error("Decode error flag asserted unexpectedly at time %t", $time);
      end
    end
  end
end

// ---------- 写入编码输出到文件 ----------
always @(posedge clk) begin
  if (dout_10b_valid) begin
    $fdisplay(file, "%h", dout_10b);
  end
end

// ---------- 超时保护 ----------
initial begin
  #(CLKT * 200000);
  $error("Simulation timeout");
  $finish;
end

endmodule