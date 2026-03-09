/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-03-08 13:04:33
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-03-09 17:04:51
 * @Filename     : d_encode_5b6b_table.v
 * @Description  : 数据码5b/6b编码表,包括是否平衡码的标志位输出, 纯组合逻辑
 */

/*
! 模块功能:
  根据输入的5位数据(din_5b_edcba)和当前运行差异度(rd_of_5b6b),
  输出对应的6位编码(d_code_6b)和平衡标志(d_code_6b_balance_flag)。
* 思路:
  采用查表法,严格依据标准8b/10b编码表。
~ 注意:
  1. 此模块为纯组合逻辑,不包含时钟和复位。
  2. 输出 d_code_6b 和 d_code_6b_balance_flag 均为组合逻辑,由输入直接决定。
% 其它:
*/

`default_nettype none

module d_encode_5b6b_table
(
  input  wire [4:0] din_5b_edcba           , // 输入5位数据 {E,D,C,B,A}
  input  wire       rd_of_5b6b             , // 输入当前运行差异度：0 = RD-,1 = RD+
  output reg  [5:0] d_code_6b              , // 6位编码输出 {i,e,d,c,b,a}
  output reg        d_code_6b_balance_flag   // 平衡标志：1表示6B码平衡(3个1和3个0), 0表示不平衡
);


//++ 查表生成6b编码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
always @(*) begin
  case (din_5b_edcba)
    5'd00: if (rd_of_5b6b) d_code_6b = 6'b000110; else d_code_6b = 6'b111001; // D.00
    5'd01: if (rd_of_5b6b) d_code_6b = 6'b010001; else d_code_6b = 6'b101110; // D.01
    5'd02: if (rd_of_5b6b) d_code_6b = 6'b010010; else d_code_6b = 6'b101101; // D.02
    5'd03:                                    d_code_6b = 6'b100011;          // D.03(平衡码)
    5'd04: if (rd_of_5b6b) d_code_6b = 6'b010100; else d_code_6b = 6'b101011; // D.04
    5'd05:                                    d_code_6b = 6'b100101;          // D.05(平衡码)
    5'd06:                                    d_code_6b = 6'b100110;          // D.06(平衡码)
    5'd07: if (rd_of_5b6b) d_code_6b = 6'b111000; else d_code_6b = 6'b000111; // D.07(平衡码,两种变体)
    5'd08: if (rd_of_5b6b) d_code_6b = 6'b011000; else d_code_6b = 6'b100111; // D.08
    5'd09:                                    d_code_6b = 6'b101001;          // D.09(平衡码)
    5'd10:                                    d_code_6b = 6'b101010;          // D.10(平衡码)
    5'd11:                                    d_code_6b = 6'b001011;          // D.11(平衡码)
    5'd12:                                    d_code_6b = 6'b101100;          // D.12(平衡码)
    5'd13:                                    d_code_6b = 6'b001101;          // D.13(平衡码)
    5'd14:                                    d_code_6b = 6'b001110;          // D.14(平衡码)
    5'd15: if (rd_of_5b6b) d_code_6b = 6'b000101; else d_code_6b = 6'b111010; // D.15
    5'd16: if (rd_of_5b6b) d_code_6b = 6'b001001; else d_code_6b = 6'b110110; // D.16
    5'd17:                                    d_code_6b = 6'b110001;          // D.17(平衡码)
    5'd18:                                    d_code_6b = 6'b110010;          // D.18(平衡码)
    5'd19:                                    d_code_6b = 6'b010011;          // D.19(平衡码)
    5'd20:                                    d_code_6b = 6'b110100;          // D.20(平衡码)
    5'd21:                                    d_code_6b = 6'b010101;          // D.21(平衡码)
    5'd22:                                    d_code_6b = 6'b010110;          // D.22(平衡码)
    5'd23: if (rd_of_5b6b) d_code_6b = 6'b101000; else d_code_6b = 6'b010111; // D.23
    5'd24: if (rd_of_5b6b) d_code_6b = 6'b001100; else d_code_6b = 6'b110011; // D.24
    5'd25:                                    d_code_6b = 6'b011001;          // D.25(平衡码)
    5'd26:                                    d_code_6b = 6'b011010;          // D.26(平衡码)
    5'd27: if (rd_of_5b6b) d_code_6b = 6'b100100; else d_code_6b = 6'b011011; // D.27
    5'd28:                                    d_code_6b = 6'b011100;          // D.28(平衡码)
    5'd29: if (rd_of_5b6b) d_code_6b = 6'b100010; else d_code_6b = 6'b011101; // D.29
    5'd30: if (rd_of_5b6b) d_code_6b = 6'b100001; else d_code_6b = 6'b011110; // D.30
    5'd31: if (rd_of_5b6b) d_code_6b = 6'b001010; else d_code_6b = 6'b110101; // D.31
    default:                                   d_code_6b = 6'b000000;
  endcase
end
//-- 查表生成6b编码 ------------------------------------------------------------


//++ 生成d_code_6b_balance_flag  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
always @(*) begin
  case (din_5b_edcba)
    5'd0, 5'd1, 5'd2, 5'd4, 5'd8, 5'd15, 5'd16, 5'd23, 5'd24, 5'd27, 5'd29, 5'd30, 5'd31:
      d_code_6b_balance_flag = 1'b0;
    5'd3, 5'd5, 5'd6, 5'd7, 5'd9, 5'd10, 5'd11, 5'd12, 5'd13, 5'd14,
    5'd17, 5'd18, 5'd19, 5'd20, 5'd21, 5'd22, 5'd25, 5'd26, 5'd28:
      d_code_6b_balance_flag = 1'b1;
    default: d_code_6b_balance_flag = 1'b0;
  endcase
end
//-- 生成d_code_6b_balance_flag  ------------------------------------------------------------


endmodule
`resetall