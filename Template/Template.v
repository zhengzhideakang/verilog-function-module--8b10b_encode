/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-08-10 22:24:47
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-08-12 14:36:01
 * @Filename     :
 * @Description  : 实例化8b10b编码示例
*/


//++ 实例化8b10b编码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wire [7:0] din_8b             ; // 输入8位数据 {H, G, F, E, D, C, B, A}
wire       din_8b_valid       ; // 输入有效指示, 高电平有效
wire       din_8b_is_k_or_d_n ; // 输入数据类型标志: 1 = K码, 0 = D码
wire [9:0] dout_10b           ; // 输出10位编码 {j, h, g, f, i, e, d, c, b, a}
wire       dout_10b_valid     ; // 输出有效, 高电平有效, 比din_8b_valid延时1个clk时钟周期

wire din_k_error  ; // 输入8b K码错误
wire dout_k_error ; // 输出10b K码错误

encode_8b10b #(
  .ERROR_DETECT_EN(0)
) encode_8b10b_u0 (
  .din_8b             (din_8b             ),
  .din_8b_valid       (din_8b_valid       ),
  .din_8b_is_k_or_d_n (din_8b_is_k_or_d_n ),
  .dout_10b           (dout_10b           ),
  .dout_10b_valid     (dout_10b_valid     ),
  .din_k_error        (din_k_error        ),
  .dout_k_error       (dout_k_error       ),
  .clk  (clk  ),
  .rstn (rstn )
);
//-- 实例化8b10b编码 ------------------------------------------------------------


//++ 实例化10b8b解码 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wire [9:0] din_10b       ;
wire       din_10b_valid ;
wire [7:0] dout_8b       ;
wire       dout_8b_is_k  ;
wire       dout_8b_valid ;
wire       dout_8b_error ;

decode_10b8b u_decode_10b8b (
  .din_10b       	(din_10b        ),
  .din_10b_valid 	(din_10b_valid  ),
  .dout_8b       	(dout_8b        ),
  .dout_8b_is_k  	(dout_8b_is_k   ),
  .dout_8b_valid 	(dout_8b_valid  ),
  .dout_8b_error 	(dout_8b_error  ),
  .clk           	(clk            )
);
//-- 实例化10b8b解码 ------------------------------------------------------------