/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-08-11
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-08-12 11:45:56
 * @Filename     : decode_10b8b.v
 * @Description  : 10b8b 解码模块（查表法，含 D 码与 K 码，带有效与错误信号）
 *                 输入 din_10b_valid 指示当前符号有效，
 *                 输出 dout_8b_valid 与数据对齐，dout_8b_error 指示非法码字。
 */

/*
! 模块功能: 带 valid 握手与错误指示的 10b8b 解码器
* 思路:
* 1. 组合逻辑查表：调用独立查找表模块，将 10bit 编码映射为 9bit {is_k, 8bit_data}
* 2. 同步输出：在 clk 上升沿，当 din_10b_valid 有效时寄存查表结果；否则保持数据。
*    valid 信号通过打拍对齐数据输出。
* 3. 错误检测：查找表对非法码字输出固定值（is_k=1, data=0x00），以此生成 dout_8b_error。
~ 注意:
~ 1. 输出与输入之间有一个时钟周期的延迟
~ 2. 未定义码字输出错误标志：dout_8b_is_k=1, dout_8b=0x00, dout_8b_error=1
~ 3. 当 din_10b_valid=0 时，输出数据保持上一有效值，valid 和 error 拉低
*/

`default_nettype none

module decode_10b8b
(
  input wire [9:0] din_10b       ,
  input wire       din_10b_valid ,

  output wire [7:0] dout_8b       ,
  output wire       dout_8b_is_k  ,
  output wire       dout_8b_valid ,
  output wire       dout_8b_error ,

  input  wire clk
);


//++ 实例化查找表 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wire [8:0] decode_table_dout_9b;

decode_10b8b_table u_decode_10b8b_table(
  .decode_table_din_10b (din_10b              ),
  .decode_table_dout_9b (decode_table_dout_9b )
);
//-- 实例化查找表 ------------------------------------------------------------


//++ 输出 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
reg [8:0] decode_table_dout_9b_r1;
always @(posedge clk) begin
  if (din_10b_valid)
    decode_table_dout_9b_r1 <= decode_table_dout_9b;
  else
    decode_table_dout_9b_r1 <= decode_table_dout_9b_r1;
end

reg din_10b_valid_r1;
always @(posedge clk) begin
  din_10b_valid_r1 <= din_10b_valid;
end

assign dout_8b      = decode_table_dout_9b_r1 [7:0] ;
assign dout_8b_is_k = decode_table_dout_9b_r1 [8  ] ;

assign dout_8b_error = decode_table_dout_9b_r1 == 9'b1_0000_0000;

assign dout_8b_valid = din_10b_valid_r1;
//-- 输出 ------------------------------------------------------------


endmodule
`resetall