/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-03-08 10:40:22
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-03-09 17:07:17
 * @Filename     : encode_8b10b.v
 * @Description  : 8b10b编码顶层
*/

/*
! 模块功能: 8b10b编码顶层模块
* 思路:
* 1.
* 8b/10b 编码器（查表法实现）
* 基于 IBM 8b/10b 编码方案
* 特性：
* - 支持全部 256 个数据字符（D.x.y）
* - 支持全部 12 个控制字符（K.x.y）
* - 运行差异度（RD）控制以实现直流平衡
* - 流水线输出，延迟2个时钟周期
* - 初始 RD = 负极性（RD-）
* - 支持输入/输出k码错误检测
~ 注意:
~ 1.
% 其它
*/

`default_nettype none

module encode_8b10b
#(
  parameter [0:0] ERROR_DETECT_EN = 1'b1 // 1(默认)表示使能错误检查; 0表示不使能
)(
  input  wire [7:0] din_8b            , // 输入8位数据 {H, G, F, E, D, C, B, A}
  input  wire       din_8b_valid      , // 输入有效指示, 高电平有效
  input  wire       din_8b_is_k_or_d_n, // 输入数据类型标志: 1 = K码, 0 = D码

  output reg [9:0] dout_10b, // 输出10位编码 {j, h, g, f, i, e, d, c, b, a}
  output reg       dout_10b_valid, // 输出有效, 高电平指示, 比din_8b_valid延时2个clk时钟周期

  output reg din_k_error, // 输入8b K码错误
  output reg dout_k_error, // 输出10b K码错误

  input  wire clk,
  input  wire rstn
);


//++ 输入锁存 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
reg [7:0] din_8b_locked;
always @(posedge clk) begin
  if (din_8b_valid)
    din_8b_locked <= din_8b;
end

reg din_8b_is_k_or_d_n_locked;
always @(posedge clk) begin
  if (din_8b_valid)
    din_8b_is_k_or_d_n_locked <= din_8b_is_k_or_d_n;
end
//-- 输入锁存 ------------------------------------------------------------


//++ 数据码5b/6b编码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
reg current_rd; //* 当前编码周期内的初始不平衡度, 默认初始值为0, 表示RD-; 1表示RD+

wire [4:0] din_5b_edcba = din_8b_locked[4:0];
wire       rd_of_5b6b = current_rd; //* 当前不平衡度作为数据码5b6b编码的控制信号
wire [5:0] d_code_6b;
wire       d_code_6b_balance_flag;
// 查5b/6b编码表, 纯组合逻辑
d_encode_5b6b_table d_encode_5b6b_table_inst (
  .din_5b_edcba          (din_5b_edcba          ), // 输入, 5位数据 {E,D,C,B,A}
  .rd_of_5b6b            (rd_of_5b6b            ), // 输入, 当前运行差异度：0 = RD-,1 = RD+
  .d_code_6b             (d_code_6b             ), // 输出, 6位编码 {i,e,d,c,b,a}
  .d_code_6b_balance_flag(d_code_6b_balance_flag)  // 输出, 平衡标志：1表示6B码平衡, 0表示不平衡
);
//-- 数据码5b/6b编码 ------------------------------------------------------------


//++ 数据码3b/4b编码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wire [2:0] din_3b_hgf = din_8b_locked[7:5]; // 高3位
// 依据6b码平衡标志生成3b/4b编码的RD, 平衡则不变, 否则反转
wire       rd_of_3b4b = d_code_6b_balance_flag ? rd_of_5b6b : ~rd_of_5b6b;
wire [1:0] d_code_6b_ie = d_code_6b[5:4]; // 6位编码输出的高两位, 用于判断A7/P7输出
wire [3:0] d_code_4b;
wire       d_code_4b_balance_flag;
// 查3b/4b编码表, 纯组合逻辑
d_encode_3b4b_table d_encode_3b4b_table_inst (
  .din_3b_hgf             (din_3b_hgf             ), // 输入, 3位数据{H, G, F}
  .rd_of_3b4b             (rd_of_3b4b             ), // 输入
  .d_code_6b_ie           (d_code_6b_ie           ), // 输入
  .d_code_4b              (d_code_4b              ), // 输出
  .d_code_4b_balance_flag (d_code_4b_balance_flag )  // 输出
);
//-- 数据码3b/4b编码 ------------------------------------------------------------


//++ 控制码8b/10b编码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wire       rd_of_k_8b10b = current_rd; //* 当前不平衡度作为控制码编码的控制信号
wire [9:0] k_code_10b;
wire       k_code_10b_balance_flag;
k_encode_8b10b_table k_encode_8b10b_table_inst (
  .din_8b                 (din_8b_locked          ), // 输入
  .rd_of_k_8b10b          (rd_of_k_8b10b          ), // 输入
  .k_code_10b             (k_code_10b             ), // 输出
  .k_code_10b_balance_flag(k_code_10b_balance_flag)  // 输出
);
//-- 控制码8b/10b编码 ------------------------------------------------------------


//++ RD更新 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
reg din_8b_valid_r1;
always @(posedge clk) begin
  din_8b_valid_r1 <= din_8b_valid;
end

always @(posedge clk) begin
  if (~rstn)
    current_rd <= 1'b0;
  else if (din_8b_valid_r1
          && ((din_8b_is_k_or_d_n_locked && ~k_code_10b_balance_flag)
                // 5b/6b与3b/4b都平衡或都不平衡, 则最终RD不反转; 否则, 反转
              || (~din_8b_is_k_or_d_n_locked && d_code_6b_balance_flag != d_code_4b_balance_flag)
              )
          )
    current_rd <= ~current_rd;
  else
    current_rd <= current_rd;
end
//-- RD更新 ------------------------------------------------------------


//++ 最终8b/10b编码输出 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
always @(posedge clk) begin
  if (din_8b_valid_r1) // din_8b_valid_r1 与 din_8b_is_k_or_d_n_locked 是对齐的
    if (din_8b_is_k_or_d_n_locked)
      dout_10b <= k_code_10b;
    else
      dout_10b <= {d_code_4b, d_code_6b};
  else
    dout_10b <= dout_10b;
end

always @(posedge clk) begin
  if (din_8b_valid_r1)
    dout_10b_valid <= 1'b1; // 输出的10编码相较输入8b延迟两个clk周期
  else
    dout_10b_valid <= 1'b0;
end
//-- 最终8b/10b编码输出 ------------------------------------------------------------


//++ 输入/输出错误检出 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
generate
if (ERROR_DETECT_EN) begin
  // 因8b10b编码的控制码是固定的12种, 所以, 如果输入的控制码不是这12个中的一个, 则报错
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

  wire din_8b_is_not_k =   din_8b != K_28_0
                        && din_8b != K_28_1
                        && din_8b != K_28_2
                        && din_8b != K_28_3
                        && din_8b != K_28_4
                        && din_8b != K_28_5
                        && din_8b != K_28_6
                        && din_8b != K_28_7
                        && din_8b != K_23_7
                        && din_8b != K_27_7
                        && din_8b != K_29_7
                        && din_8b != K_30_7;

  always @(posedge clk) begin
    if (~rstn)
      din_k_error <= 1'b0;
    else if (din_8b_is_k_or_d_n && din_8b_valid && din_8b_is_not_k)
      din_k_error <= 1'b1;
    else
      din_k_error <= 1'b0;
  end

  always @(posedge clk) begin
    if (~rstn)
      dout_k_error <= 1'b0;
    else if (din_8b_valid_r1 && din_8b_is_k_or_d_n_locked && k_code_10b == 'd0)
      dout_k_error <= 1'b1;
    else
      dout_k_error <= 1'b0;
  end
end else begin // 不使能错误检查则错误指示信号始终为0
  always @(*) begin
    din_k_error = 1'b0;
  end

  always @(*) begin
    dout_k_error = 1'b0;
  end
end
endgenerate
//-- 输入/输出错误检出 ------------------------------------------------------------


endmodule
`resetall