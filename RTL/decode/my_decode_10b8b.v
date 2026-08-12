/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-08-11
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-08-11 22:23:03
 * @Filename     : decode_10b8b.v
 * @Description  : 10b8b 解码顶层模块（查表法，含 D 码与 K 码，静态组合校验）
 *                 增加 dout_8b_is_k 指示信号与 A7 合法性校验
 */

/*
! 模块功能: 10b8b 解码顶层模块（查表法, 含 D 码与 K 码，无 RD 跟踪）
* 思路:
* 1. 将10b输入拆分为低6b（{i,e,d,c,b,a}）和高4b（{j,h,g,f}）。
* 2. 低6b通过查表法译码为5b数据（dcode_5b），并产生非法码字指示（dcode_6b_invalid）。
*    表项包含全部 D 码和 K.28 码的6b编码。
* 3. 高4b通过查表法译码为3b数据（dcode_3b），并产生非法码字指示（dcode_4b_invalid）。
*    表项包含 D.x.0～D.x.7 及 K.x.7 的4b编码。
* 4. 组合合法性校验（仅针对 y=7 的 D 码）：
*    - 若 dcode_4b 为 A7 编码（0001/1110），且当前不是 K 码（~dout_8b_is_k_comb），
*      则要求 dcode_6b 必须属于可与 A7 合法搭配的集合（即满足条件1或条件2的码字），
*      否则判定 dcode_x_a7_invalid 有效。
*    - P7 编码（1000/0111）不进行额外校验，仅依赖 dcode_6b_invalid 和 dcode_4b_invalid。
* 5. 总错误标志 = ~dout_8b_is_k_comb & ( dcode_6b_invalid | dcode_4b_invalid | dcode_x_a7_invalid )。
* 6. K/D 识别：通过组合逻辑识别 K.28 专用6b 以及 K.x.7 (23,27,29,30) 的特定(4b,6b)组合。
* 7. 有效数据与错误标志、K/D标志随输入有效信号打一拍输出，实现 dout_8b_valid 与 dout_8b_error 对齐。
~ 注意:
~ 1. 本模块不含运行差异度（RD）校验，错误判断基于码字本身合法性及 A7 的静态搭配规则。
~ 2. dout_8b_valid 仅在 din_10b_valid 为高时拉高，下一拍如果输入无效则置 0。
~ 3. K.28.y 由专用6b编码（111100/000011）识别。该6b不在普通D码表中，但被K码组合逻辑单独处理，
~    不会引起误报错。
~ 4. K.x.7（x=23,27,29,30）因其6b与对应D码相同、4b为标准D.x.7的A7编码，通过特定组合识别，
~    不会与D.x.7混淆。
~ 5. 组合合法性校验仅针对 y=7 的情况，其他子码仅依靠6b/4b的独立合法标志。
~ 6. 合法的 D.x.7 字符（无论采用 P7 还是 A7）均可通过本模块正确解码并标记为有效数据。
% 其它
! 版本更新记录
* 版本号 |  发布时间    | 修改说明
* V1.0  | 2026-08-11 | 初始发布
*/

`default_nettype none

module decode_10b8b
(
  input  wire [9:0] din_10b         , // {j,h,g,f,i,e,d,c,b,a}
  input  wire       din_10b_valid   , // 高电平有效

  output reg [7:0] dout_8b       , // {H,G,F,E,D,C,B,A}
  output reg       dout_8b_valid , // 高电平有效, 延时din_10b_valid一个clk周期
  output reg       dout_8b_is_k  , // 与dout_8b_valid对齐, 1表示输出为k码
  output reg       dout_8b_error , // 与dout_8b_valid对齐, 1表示输出错误

  input  wire clk
);


//++ 输入切分 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wire [3:0] dcode_4b = din_10b[9:6]; // 高4位, j,h,g
wire [5:0] dcode_6b = din_10b[5:0]; // 低6位, f,i,e,d,c,b,a

wire [9:0] kcode_10b = din_10b; // K码
//-- 输入切分 ------------------------------------------------------------


//++ D码-6b/5b解码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
reg [4:0] dcode_5b         ;
reg       dcode_6b_invalid ;
always @(*) begin
  case (dcode_6b)
    // 左RD-,  右RD+
    6'b111001, 6'b000110: begin dcode_5b = 5'd0;  dcode_6b_invalid = 1'b0; end // D.00
    6'b101110, 6'b010001: begin dcode_5b = 5'd1;  dcode_6b_invalid = 1'b0; end // D.01
    6'b101101, 6'b010010: begin dcode_5b = 5'd2;  dcode_6b_invalid = 1'b0; end // D.02
    6'b100011:            begin dcode_5b = 5'd3;  dcode_6b_invalid = 1'b0; end // D.03
    6'b101011, 6'b010100: begin dcode_5b = 5'd4;  dcode_6b_invalid = 1'b0; end // D.04
    6'b100101:            begin dcode_5b = 5'd5;  dcode_6b_invalid = 1'b0; end // D.05
    6'b100110:            begin dcode_5b = 5'd6;  dcode_6b_invalid = 1'b0; end // D.06
    6'b000111, 6'b111000: begin dcode_5b = 5'd7;  dcode_6b_invalid = 1'b0; end // D.07
    6'b100111, 6'b011000: begin dcode_5b = 5'd8;  dcode_6b_invalid = 1'b0; end // D.08
    6'b101001:            begin dcode_5b = 5'd9;  dcode_6b_invalid = 1'b0; end // D.09
    6'b101010:            begin dcode_5b = 5'd10; dcode_6b_invalid = 1'b0; end // D.10
    6'b001011:            begin dcode_5b = 5'd11; dcode_6b_invalid = 1'b0; end // D.11
    6'b101100:            begin dcode_5b = 5'd12; dcode_6b_invalid = 1'b0; end // D.12
    6'b001101:            begin dcode_5b = 5'd13; dcode_6b_invalid = 1'b0; end // D.13
    6'b001110:            begin dcode_5b = 5'd14; dcode_6b_invalid = 1'b0; end // D.14
    6'b111010, 6'b000101: begin dcode_5b = 5'd15; dcode_6b_invalid = 1'b0; end // D.15
    6'b110110, 6'b001001: begin dcode_5b = 5'd16; dcode_6b_invalid = 1'b0; end // D.16
    6'b110001:            begin dcode_5b = 5'd17; dcode_6b_invalid = 1'b0; end // D.17
    6'b110010:            begin dcode_5b = 5'd18; dcode_6b_invalid = 1'b0; end // D.18
    6'b010011:            begin dcode_5b = 5'd19; dcode_6b_invalid = 1'b0; end // D.19
    6'b110100:            begin dcode_5b = 5'd20; dcode_6b_invalid = 1'b0; end // D.20
    6'b010101:            begin dcode_5b = 5'd21; dcode_6b_invalid = 1'b0; end // D.21
    6'b010110:            begin dcode_5b = 5'd22; dcode_6b_invalid = 1'b0; end // D.22
    6'b010111, 6'b101000: begin dcode_5b = 5'd23; dcode_6b_invalid = 1'b0; end // D.23
    6'b110011, 6'b001100: begin dcode_5b = 5'd24; dcode_6b_invalid = 1'b0; end // D.24
    6'b011001:            begin dcode_5b = 5'd25; dcode_6b_invalid = 1'b0; end // D.25
    6'b011010:            begin dcode_5b = 5'd26; dcode_6b_invalid = 1'b0; end // D.26
    6'b011011, 6'b100100: begin dcode_5b = 5'd27; dcode_6b_invalid = 1'b0; end // D.27
    6'b011100:            begin dcode_5b = 5'd28; dcode_6b_invalid = 1'b0; end // D.28
    6'b011101, 6'b100010: begin dcode_5b = 5'd29; dcode_6b_invalid = 1'b0; end // D.29
    6'b011110, 6'b100001: begin dcode_5b = 5'd30; dcode_6b_invalid = 1'b0; end // D.30
    6'b110101, 6'b001010: begin dcode_5b = 5'd31; dcode_6b_invalid = 1'b0; end // D.31
    default:              begin dcode_5b = 5'd0;  dcode_6b_invalid = 1'b1; end // 无效输入
  endcase
end
//-- D码-6b/5b解码 ------------------------------------------------------------


//++ D码-4b/3b解码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
reg [2:0] dcode_3b;
reg       dcode_4b_invalid;
always @(*) begin
  case (dcode_4b)
    // 左RD-,  右RD+
    4'b1101, 4'b0010 : begin dcode_3b = 3'd0; dcode_4b_invalid = 1'b0; end // D.x.0
    4'b1001          : begin dcode_3b = 3'd1; dcode_4b_invalid = 1'b0; end // D.x.1
    4'b1010          : begin dcode_3b = 3'd2; dcode_4b_invalid = 1'b0; end // D.x.2
    4'b0011, 4'b1100 : begin dcode_3b = 3'd3; dcode_4b_invalid = 1'b0; end // D.x.3
    4'b1011, 4'b0100 : begin dcode_3b = 3'd4; dcode_4b_invalid = 1'b0; end // D.x.4
    4'b0101          : begin dcode_3b = 3'd5; dcode_4b_invalid = 1'b0; end // D.x.5
    4'b0110          : begin dcode_3b = 3'd6; dcode_4b_invalid = 1'b0; end // D.x.6
    4'b1000, 4'b0111 : begin dcode_3b = 3'd7; dcode_4b_invalid = 1'b0; end // D.x.P7
    4'b0001, 4'b1110 : begin dcode_3b = 3'd7; dcode_4b_invalid = 1'b0; end // D.x.A7（用于D.23/27/29/30.7）
    default          : begin dcode_3b = 3'd0; dcode_4b_invalid = 1'b1; end // 无效输入
  endcase
end
//-- D码-4b/3b解码 ------------------------------------------------------------


//++ K码解码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
reg [7:0] kcode_8b;
reg       dout_8b_is_k_comb; // 组合逻辑K码指示，最终会寄存到 dout_8b_is_k
always @(*) begin
  case (din_10b)
    // 左RD-,  右RD+
    10'b0010_111100, 10'b1101_000011: begin kcode_8b = 8'b000_11100; dout_8b_is_k_comb = 1'b1; end // K.28.0
    10'b1001_111100, 10'b0110_000011: begin kcode_8b = 8'b001_11100; dout_8b_is_k_comb = 1'b1; end // K.28.1
    10'b1010_111100, 10'b0101_000011: begin kcode_8b = 8'b010_11100; dout_8b_is_k_comb = 1'b1; end // K.28.2
    10'b1100_111100, 10'b0011_000011: begin kcode_8b = 8'b011_11100; dout_8b_is_k_comb = 1'b1; end // K.28.3
    10'b0100_111100, 10'b1011_000011: begin kcode_8b = 8'b100_11100; dout_8b_is_k_comb = 1'b1; end // K.28.4
    10'b0101_111100, 10'b1010_000011: begin kcode_8b = 8'b101_11100; dout_8b_is_k_comb = 1'b1; end // K.28.5
    10'b0110_111100, 10'b1001_000011: begin kcode_8b = 8'b110_11100; dout_8b_is_k_comb = 1'b1; end // K.28.6
    10'b0001_111100, 10'b1110_000011: begin kcode_8b = 8'b111_11100; dout_8b_is_k_comb = 1'b1; end // K.28.7
    10'b0001_010111, 10'b1110_101000: begin kcode_8b = 8'b111_10111; dout_8b_is_k_comb = 1'b1; end // K.23.7
    10'b0001_011011, 10'b1110_100100: begin kcode_8b = 8'b111_11011; dout_8b_is_k_comb = 1'b1; end // K.27.7
    10'b0001_011101, 10'b1110_100010: begin kcode_8b = 8'b111_11101; dout_8b_is_k_comb = 1'b1; end // K.29.7
    10'b0001_011110, 10'b1110_100001: begin kcode_8b = 8'b111_11110; dout_8b_is_k_comb = 1'b1; end // K.30.7
    default: begin kcode_8b = 8'd0; dout_8b_is_k_comb = 1'b0; end // 非K码
  endcase
end
//-- K码解码 ------------------------------------------------------------


//++ D.x.A7合法检测 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*
A7 选择条件(满足任一即选 A7，否则选 P7):
条件1: rd > 0 且 e == 0 且 i == 0
条件2: rd < 0 且 e == 1 且 i == 1
*/
reg dcode_6b_rd_p_and_e_i_zero; // 条件1可能对应的6B码字集合
always @(*) begin
  dcode_6b_rd_p_and_e_i_zero = 1'b0;
  case (dcode_6b)
    // RD+ 与平衡码 (i=0, e=0)
    6'b000110: dcode_6b_rd_p_and_e_i_zero = 1'b1; // D.00 RD+
    6'b001011: dcode_6b_rd_p_and_e_i_zero = 1'b1; // D.11 平衡码
    6'b001101: dcode_6b_rd_p_and_e_i_zero = 1'b1; // D.13 平衡码
    6'b001110: dcode_6b_rd_p_and_e_i_zero = 1'b1; // D.14 平衡码
    6'b000101: dcode_6b_rd_p_and_e_i_zero = 1'b1; // D.15 RD+
    6'b001001: dcode_6b_rd_p_and_e_i_zero = 1'b1; // D.16 RD+
    6'b001100: dcode_6b_rd_p_and_e_i_zero = 1'b1; // D.24 RD+
    6'b001010: dcode_6b_rd_p_and_e_i_zero = 1'b1; // D.31 RD+
    default: ;
  endcase
end

reg dcode_6b_rd_n_and_e_i_one; // 条件2可能对应的6B码字集合
always @(*) begin
  dcode_6b_rd_n_and_e_i_one = 1'b0;
  case (dcode_6b)
    // RD‑ 与 平衡码 (i=1, e=1)
    6'b111001: dcode_6b_rd_n_and_e_i_one = 1'b1; // D.00 RD‑
    6'b111010: dcode_6b_rd_n_and_e_i_one = 1'b1; // D.15 RD‑
    6'b110110: dcode_6b_rd_n_and_e_i_one = 1'b1; // D.16 RD‑
    6'b110001: dcode_6b_rd_n_and_e_i_one = 1'b1; // D.17 平衡码
    6'b110010: dcode_6b_rd_n_and_e_i_one = 1'b1; // D.18 平衡码
    6'b110100: dcode_6b_rd_n_and_e_i_one = 1'b1; // D.20 平衡码
    6'b110011: dcode_6b_rd_n_and_e_i_one = 1'b1; // D.24 RD‑
    6'b110101: dcode_6b_rd_n_and_e_i_one = 1'b1; // D.31 RD‑
    default: ;
  endcase
end

reg dcode_x_a7_invalid;
always @(*) begin
  if (~dout_8b_is_k_comb && (dcode_4b == 4'b1110 || dcode_4b == 4'b0001)) // D.x.A7
    if (dcode_6b_rd_p_and_e_i_zero || dcode_6b_rd_n_and_e_i_one)
      dcode_x_a7_invalid = 1'b0;
    else
      dcode_x_a7_invalid = 1'b1;
  else
    dcode_x_a7_invalid = 1'b0;
end
//-- D.x.A7合法检测 ------------------------------------------------------------


//++ 生成8b输出与K/D指示 ++++++++++++++++++++++++++++++++++++++++++++++++++
always @(posedge clk) begin
  if (din_10b_valid)
    if (dout_8b_is_k_comb)
      dout_8b <= kcode_8b;
    else
      dout_8b <= {dcode_3b, dcode_5b};
  else
    dout_8b <= dout_8b;
end

always @(posedge clk) begin
  if (din_10b_valid)
    dout_8b_valid <= 1'b1;
  else
    dout_8b_valid <= 1'b0;
end

wire dout_8b_error_comb = ~dout_8b_is_k_comb
                            && (dcode_6b_invalid
                              || dcode_4b_invalid
                              || dcode_x_a7_invalid
                              );

always @(posedge clk) begin
  if (din_10b_valid)
    dout_8b_error <= dout_8b_error_comb;
  else
    dout_8b_error <= 1'b0;
end

always @(posedge clk) begin
  if (din_10b_valid)
    dout_8b_is_k <= dout_8b_is_k_comb;
  else
    dout_8b_is_k <= 1'b0;
end
//-- 生成8b输出与K/D指示 --------------------------------------------------


endmodule
`resetall