/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-03-08 13:04:33
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-03-09 17:06:05
 * @Filename     : k_encode_8b10b_table.v
 * @Description  : 控制码8b/10b编码表,包括是否平衡码的标志位输出, 纯组合逻辑
 */

/*
! 模块功能:
  根据输入的高3位(din_3b_hgf)和低5位(din_5b_edcba)组合成的8位K码索引,
  以及当前运行差异度(rd_of_k_8b10b),输出对应的10位K码编码(k_code_10b)和平衡标志(k_code_10b_balance_flag)。
* 思路:
  采用查表法,严格依据标准8b/10b控制字符编码表。
~ 注意:
  1. 此模块为纯组合逻辑,不包含时钟和复位。
  2. 输出 k_code_10b 和 k_code_10b_balance_flag 均为组合逻辑,由输入直接决定。
  3. 输入组合 {din_3b_hgf, din_5b_edcba} 必须为有效的K码索引,否则输出为0。
% 其它:
  平衡标志 k_code_10b_balance_flag 为1表示该10位K码平衡(5个1和5个0),为0表示不平衡。
*/

`default_nettype none

module k_encode_8b10b_table
(
  input  wire [7:0] din_8b                  , // 输入8位
  input  wire       rd_of_k_8b10b           , // 当前运行差异度：0 = RD-，1 = RD+
  output reg  [9:0] k_code_10b              , // 10位K码输出 {j,h,g,f,i,e,d,c,b,a}
  output reg        k_code_10b_balance_flag // 平衡标志：1表示10B码平衡(5个1和5个0)，0表示不平衡
);


//++ 查表生成10bK码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
always @(*) begin
  case (din_8b)
    8'b000_11100: // K.28.0
      if (rd_of_k_8b10b) k_code_10b = 10'b1101_000011; else k_code_10b = 10'b0010_111100;
    8'b001_11100: // K.28.1
      if (rd_of_k_8b10b) k_code_10b = 10'b0110_000011; else k_code_10b = 10'b1001_111100;
    8'b010_11100: // K.28.2
      if (rd_of_k_8b10b) k_code_10b = 10'b0101_000011; else k_code_10b = 10'b1010_111100;
    8'b011_11100: // K.28.3
      if (rd_of_k_8b10b) k_code_10b = 10'b0011_000011; else k_code_10b = 10'b1100_111100;
    8'b100_11100: // K.28.4
      if (rd_of_k_8b10b) k_code_10b = 10'b1011_000011; else k_code_10b = 10'b0100_111100;
    8'b101_11100: // K.28.5
      if (rd_of_k_8b10b) k_code_10b = 10'b1010_000011; else k_code_10b = 10'b0101_111100;
    8'b110_11100: // K.28.6
      if (rd_of_k_8b10b) k_code_10b = 10'b1001_000011; else k_code_10b = 10'b0110_111100;
    8'b111_11100: // K.28.7
      if (rd_of_k_8b10b) k_code_10b = 10'b1110_000011; else k_code_10b = 10'b0001_111100;
    8'b111_10111: // K.23.7
      if (rd_of_k_8b10b) k_code_10b = 10'b1110_101000; else k_code_10b = 10'b0001_010111;
    8'b111_11011: // K.27.7
      if (rd_of_k_8b10b) k_code_10b = 10'b1110_100100; else k_code_10b = 10'b0001_011011;
    8'b111_11101: // K.29.7
      if (rd_of_k_8b10b) k_code_10b = 10'b1110_100010; else k_code_10b = 10'b0001_011101;
    8'b111_11110: // K.30.7
      if (rd_of_k_8b10b) k_code_10b = 10'b1110_100001; else k_code_10b = 10'b0001_011110;
    default:        k_code_10b = 10'b0;
  endcase
end
//-- 查表生成10bK码 ------------------------------------------------------------


//++ 生成k_code_10b_balance_flag平衡标志 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
always @(*) begin
  case (din_8b)
    8'b000_11100, 8'b100_11100, 8'b111_11100, // K.28.0, K.28.4, K.28.7
    8'b111_10111, 8'b111_11011, 8'b111_11101, 8'b111_11110: // K.23.7, K.27.7, K.29.7, K.30.7
      k_code_10b_balance_flag = 1'b1;  // 平衡码
    8'b001_11100, 8'b010_11100, 8'b011_11100, // K.28.1, K.28.2, K.28.3
    8'b101_11100, 8'b110_11100:                // K.28.5, K.28.6
      k_code_10b_balance_flag = 1'b0;  // 不平衡码
    default: k_code_10b_balance_flag = 1'b0;
  endcase
end
//-- 生成k_code_10b_balance_flag平衡标志 ----------------------------------------------------------


endmodule
`resetall