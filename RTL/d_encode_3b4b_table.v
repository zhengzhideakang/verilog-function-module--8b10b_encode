/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-03-08 13:04:33
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-03-09 17:05:11
 * @Filename     : d_encode_3b4b_table.v
 * @Description  : 数据码3b/4b编码表,包括是否平衡码的标志位输出, 纯组合逻辑
 */

/*
! 模块功能:
  根据输入的3位数据(din_3b_hgf)和当前运行差异度(rd_of_3b4b),
  输出对应的4位编码(d_code_4b)和平衡标志(d_code_4b_balance_flag)。
* 思路:
  采用查表法,严格依据标准8b/10b编码表。
~ 注意:
  1. 此模块为纯组合逻辑,不包含时钟和复位。
  2. 输出 d_code_4b 和 d_code_4b_balance_flag 均为组合逻辑,由输入直接决定。
% 其它:
  对于输入3'd7(D.x.7), 如果满足: [rd > O且(e = i = 0)]或者[rd < 0且(e = i = 1)],则选择A7编码输出,
  否则选择P7编码输出
*/

`default_nettype none

module d_encode_3b4b_table
(
  input  wire [2:0] din_3b_hgf             , // 输入3位数据 {H,G,F}
  input  wire       rd_of_3b4b             , // 输入当前运行差异度: 0 = RD-,1 = RD+
  input  wire [1:0] d_code_6b_ie           , // 输入前一步骤的6位编码输出的高两位, 用于判断A7/P7输出
  output reg  [3:0] d_code_4b              , // 4位编码输出 {j,h,g,f}
  output reg        d_code_4b_balance_flag // 平衡标志: 1表示4B码平衡(2个1和2个0), 0表示不平衡
);


//++ 查表生成4b编码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
always @(*) begin
  case (din_3b_hgf)
    3'd0: if (rd_of_3b4b) d_code_4b = 4'b0010; else d_code_4b = 4'b1101; // D.x.0
    3'd1:                                    d_code_4b = 4'b1001;        // D.x.1(平衡码)
    3'd2:                                    d_code_4b = 4'b1010;        // D.x.2(平衡码)
    3'd3: if (rd_of_3b4b) d_code_4b = 4'b1100; else d_code_4b = 4'b0011; // D.x.3(平衡, 但顺序变化)
    3'd4: if (rd_of_3b4b) d_code_4b = 4'b0100; else d_code_4b = 4'b1011; // D.x.4
    3'd5:                                    d_code_4b = 4'b0101;        // D.x.5(平衡码)
    3'd6:                                    d_code_4b = 4'b0110;        // D.x.6(平衡码)
    3'd7:
      if (rd_of_3b4b)
        if (d_code_6b_ie == 2'b00)
          d_code_4b = 4'b0001; // A7编码RD+输出
        else
          d_code_4b = 4'b1000; // P7编码RD+输出
      else
        if (d_code_6b_ie == 2'b11)
          d_code_4b = 4'b1110; // A7编码RD-输出
        else
          d_code_4b = 4'b0111; // P7编码RD-输出
    default:                                 d_code_4b = 4'b0000;
  endcase
end
//-- 查表生成4b编码 ------------------------------------------------------------


//++ 生成d_code_4b_balance_flag +++++++++++++++++++++++++++++++++++++++++++++++
always @(*) begin
  case (din_3b_hgf)
    3'd0, 3'd4, 3'd7: d_code_4b_balance_flag = 1'b0; // 不平衡码
    3'd1, 3'd2, 3'd3, 3'd5, 3'd6: d_code_4b_balance_flag = 1'b1; // 平衡码
    default:                d_code_4b_balance_flag = 1'b0;
  endcase
end
//-- 生成d_code_4b_balance_flag ------------------------------------------------


endmodule

`resetall