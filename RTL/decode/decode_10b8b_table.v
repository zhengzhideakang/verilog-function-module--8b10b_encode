/*
 * @Author       : Xu Xiaokang
 * @Email        :
 * @Date         : 2026-08-11
 * @LastEditors  : Xu Xiaokang
 * @LastEditTime : 2026-08-12 11:40:49
 * @Filename     : decode_10b8b_table.v
 * @Description  : 10b8b解码表
 */

/*
! 模块功能:
* 思路:
* 1.组合逻辑查表：将 10bit 编码映射为 9bit {is_k, 8bit_data}
~ 注意:
*/

`default_nettype none

module decode_10b8b_table
(
  input  wire [9:0] decode_table_din_10b ,
  output wire [8:0] decode_table_dout_9b // 组合逻辑查表结果，bit8为is_k，bit[7:0]为数据
);


//++ 查找表 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
reg [8:0] decode_table_dout_9b_tmp;

assign decode_table_dout_9b = decode_table_dout_9b_tmp;

always @(*) begin
  case (decode_table_din_10b)
    // 数据字符 D11.7+ ~ D14.7+
    10'b0001001011 : decode_table_dout_9b_tmp = 9'b011101011;  // D11.7+
    10'b0001001101 : decode_table_dout_9b_tmp = 9'b011101101;  // D13.7+
    10'b0001001110 : decode_table_dout_9b_tmp = 9'b011101110;  // D14.7+
    // 控制字符 K19.7+ ~ K30.7+
    10'b0001010011 : decode_table_dout_9b_tmp = 9'b111110011;  // K19.7+
    10'b0001010101 : decode_table_dout_9b_tmp = 9'b111110101;  // K21.7+
    10'b0001010110 : decode_table_dout_9b_tmp = 9'b111110110;  // K22.7+
    10'b0001010111 : decode_table_dout_9b_tmp = 9'b111110111;  // K23.7+
    10'b0001011001 : decode_table_dout_9b_tmp = 9'b111111001;  // K25.7+
    10'b0001011010 : decode_table_dout_9b_tmp = 9'b111111010;  // K26.7+
    10'b0001011011 : decode_table_dout_9b_tmp = 9'b111111011;  // K27.7+
    10'b0001011101 : decode_table_dout_9b_tmp = 9'b111111101;  // K29.7+
    10'b0001011110 : decode_table_dout_9b_tmp = 9'b111111110;  // K30.7+
    // 控制字符 K3.7+ ~ K1.7+
    10'b0001100011 : decode_table_dout_9b_tmp = 9'b111100011;  // K3.7+
    10'b0001100101 : decode_table_dout_9b_tmp = 9'b111100101;  // K5.7+
    10'b0001100110 : decode_table_dout_9b_tmp = 9'b111100110;  // K6.7+
    10'b0001100111 : decode_table_dout_9b_tmp = 9'b111101000;  // K8.7+
    10'b0001101001 : decode_table_dout_9b_tmp = 9'b111101001;  // K9.7+
    10'b0001101010 : decode_table_dout_9b_tmp = 9'b111101010;  // K10.7+
    10'b0001101011 : decode_table_dout_9b_tmp = 9'b111100100;  // K4.7+
    10'b0001101100 : decode_table_dout_9b_tmp = 9'b111101100;  // K12.7+
    10'b0001101101 : decode_table_dout_9b_tmp = 9'b111100010;  // K2.7+
    10'b0001101110 : decode_table_dout_9b_tmp = 9'b111100001;  // K1.7+
    // 控制字符 K17.7+ ~ K28.7+
    10'b0001110001 : decode_table_dout_9b_tmp = 9'b111110001;  // K17.7+
    10'b0001110010 : decode_table_dout_9b_tmp = 9'b111110010;  // K18.7+
    10'b0001110011 : decode_table_dout_9b_tmp = 9'b111111000;  // K24.7+
    10'b0001110100 : decode_table_dout_9b_tmp = 9'b111110100;  // K20.7+
    10'b0001110101 : decode_table_dout_9b_tmp = 9'b111111111;  // K31.7+
    10'b0001110110 : decode_table_dout_9b_tmp = 9'b111110000;  // K16.7+
    10'b0001111000 : decode_table_dout_9b_tmp = 9'b111100111;  // K7.7+
    10'b0001111001 : decode_table_dout_9b_tmp = 9'b111100000;  // K0.7+
    10'b0001111010 : decode_table_dout_9b_tmp = 9'b111101111;  // K15.7+
    10'b0001111100 : decode_table_dout_9b_tmp = 9'b111111100;  // K28.7+
    // 数据字符 D11.0+ ~ D30.0+
    10'b0010001011 : decode_table_dout_9b_tmp = 9'b000001011;  // D11.0+
    10'b0010001101 : decode_table_dout_9b_tmp = 9'b000001101;  // D13.0+
    10'b0010001110 : decode_table_dout_9b_tmp = 9'b000001110;  // D14.0+
    10'b0010010011 : decode_table_dout_9b_tmp = 9'b000010011;  // D19.0+
    10'b0010010101 : decode_table_dout_9b_tmp = 9'b000010101;  // D21.0+
    10'b0010010110 : decode_table_dout_9b_tmp = 9'b000010110;  // D22.0+
    10'b0010010111 : decode_table_dout_9b_tmp = 9'b000010111;  // D23.0+
    10'b0010011001 : decode_table_dout_9b_tmp = 9'b000011001;  // D25.0+
    10'b0010011010 : decode_table_dout_9b_tmp = 9'b000011010;  // D26.0+
    10'b0010011011 : decode_table_dout_9b_tmp = 9'b000011011;  // D27.0+
    10'b0010011100 : decode_table_dout_9b_tmp = 9'b000011100;  // D28.0+
    10'b0010011101 : decode_table_dout_9b_tmp = 9'b000011101;  // D29.0+
    10'b0010011110 : decode_table_dout_9b_tmp = 9'b000011110;  // D30.0+
    // 数据字符 D3.0+ ~ D15.0+
    10'b0010100011 : decode_table_dout_9b_tmp = 9'b000000011;  // D3.0+
    10'b0010100101 : decode_table_dout_9b_tmp = 9'b000000101;  // D5.0+
    10'b0010100110 : decode_table_dout_9b_tmp = 9'b000000110;  // D6.0+
    10'b0010100111 : decode_table_dout_9b_tmp = 9'b000001000;  // D8.0+
    10'b0010101001 : decode_table_dout_9b_tmp = 9'b000001001;  // D9.0+
    10'b0010101010 : decode_table_dout_9b_tmp = 9'b000001010;  // D10.0+
    10'b0010101011 : decode_table_dout_9b_tmp = 9'b000000100;  // D4.0+
    10'b0010101100 : decode_table_dout_9b_tmp = 9'b000001100;  // D12.0+
    10'b0010101101 : decode_table_dout_9b_tmp = 9'b000000010;  // D2.0+
    10'b0010101110 : decode_table_dout_9b_tmp = 9'b000000001;  // D1.0+
    // 数据字符 D17.0+ ~ K28.0+
    10'b0010110001 : decode_table_dout_9b_tmp = 9'b000010001;  // D17.0+
    10'b0010110010 : decode_table_dout_9b_tmp = 9'b000010010;  // D18.0+
    10'b0010110011 : decode_table_dout_9b_tmp = 9'b000011000;  // D24.0+
    10'b0010110100 : decode_table_dout_9b_tmp = 9'b000010100;  // D20.0+
    10'b0010110101 : decode_table_dout_9b_tmp = 9'b000011111;  // D31.0+
    10'b0010110110 : decode_table_dout_9b_tmp = 9'b000010000;  // D16.0+
    10'b0010111000 : decode_table_dout_9b_tmp = 9'b000000111;  // D7.0+
    10'b0010111001 : decode_table_dout_9b_tmp = 9'b000000000;  // D0.0+
    10'b0010111010 : decode_table_dout_9b_tmp = 9'b000001111;  // D15.0+
    10'b0010111100 : decode_table_dout_9b_tmp = 9'b100011100;  // K28.0+
    // 控制字符 K28.3+，数据 D15.3+ ~ D20.3+
    10'b0011000011 : decode_table_dout_9b_tmp = 9'b101111100;  // K28.3+
    10'b0011000101 : decode_table_dout_9b_tmp = 9'b001101111;  // D15.3+
    10'b0011000110 : decode_table_dout_9b_tmp = 9'b001100000;  // D0.3+
    10'b0011000111 : decode_table_dout_9b_tmp = 9'b001100111;  // D7.3+
    10'b0011001001 : decode_table_dout_9b_tmp = 9'b001110000;  // D16.3+
    10'b0011001010 : decode_table_dout_9b_tmp = 9'b001111111;  // D31.3+
    10'b0011001011 : decode_table_dout_9b_tmp = 9'b001101011;  // D11.3+
    10'b0011001100 : decode_table_dout_9b_tmp = 9'b001111000;  // D24.3+
    10'b0011001101 : decode_table_dout_9b_tmp = 9'b001101101;  // D13.3+
    10'b0011001110 : decode_table_dout_9b_tmp = 9'b001101110;  // D14.3+
    // 数据 D1.3+ ~ D12.3+
    10'b0011010001 : decode_table_dout_9b_tmp = 9'b001100001;  // D1.3+
    10'b0011010010 : decode_table_dout_9b_tmp = 9'b001100010;  // D2.3+
    10'b0011010011 : decode_table_dout_9b_tmp = 9'b001110011;  // D19.3+
    10'b0011010100 : decode_table_dout_9b_tmp = 9'b001100100;  // D4.3+
    10'b0011010101 : decode_table_dout_9b_tmp = 9'b001110101;  // D21.3+
    10'b0011010110 : decode_table_dout_9b_tmp = 9'b001110110;  // D22.3+
    10'b0011011000 : decode_table_dout_9b_tmp = 9'b001101000;  // D8.3+
    10'b0011011001 : decode_table_dout_9b_tmp = 9'b001111001;  // D25.3+
    10'b0011011010 : decode_table_dout_9b_tmp = 9'b001111010;  // D26.3+
    10'b0011011100 : decode_table_dout_9b_tmp = 9'b001111100;  // D28.3+
    // 数据 D30.3+ ~ D20.3+
    10'b0011100001 : decode_table_dout_9b_tmp = 9'b001111110;  // D30.3+
    10'b0011100010 : decode_table_dout_9b_tmp = 9'b001111101;  // D29.3+
    10'b0011100011 : decode_table_dout_9b_tmp = 9'b001100011;  // D3.3+
    10'b0011100100 : decode_table_dout_9b_tmp = 9'b001111011;  // D27.3+
    10'b0011100101 : decode_table_dout_9b_tmp = 9'b001100101;  // D5.3+
    10'b0011100110 : decode_table_dout_9b_tmp = 9'b001100110;  // D6.3+
    10'b0011101000 : decode_table_dout_9b_tmp = 9'b001110111;  // D23.3+
    10'b0011101001 : decode_table_dout_9b_tmp = 9'b001101001;  // D9.3+
    10'b0011101010 : decode_table_dout_9b_tmp = 9'b001101010;  // D10.3+
    10'b0011101100 : decode_table_dout_9b_tmp = 9'b001101100;  // D12.3+
    // 数据 D17.3+ ~ D20.3+
    10'b0011110001 : decode_table_dout_9b_tmp = 9'b001110001;  // D17.3+
    10'b0011110010 : decode_table_dout_9b_tmp = 9'b001110010;  // D18.3+
    10'b0011110100 : decode_table_dout_9b_tmp = 9'b001110100;  // D20.3+
    // 数据 D11.4+ ~ D30.4+
    10'b0100001011 : decode_table_dout_9b_tmp = 9'b010001011;  // D11.4+
    10'b0100001101 : decode_table_dout_9b_tmp = 9'b010001101;  // D13.4+
    10'b0100001110 : decode_table_dout_9b_tmp = 9'b010001110;  // D14.4+
    10'b0100010011 : decode_table_dout_9b_tmp = 9'b010010011;  // D19.4+
    10'b0100010101 : decode_table_dout_9b_tmp = 9'b010010101;  // D21.4+
    10'b0100010110 : decode_table_dout_9b_tmp = 9'b010010110;  // D22.4+
    10'b0100010111 : decode_table_dout_9b_tmp = 9'b010010111;  // D23.4+
    10'b0100011001 : decode_table_dout_9b_tmp = 9'b010011001;  // D25.4+
    10'b0100011010 : decode_table_dout_9b_tmp = 9'b010011010;  // D26.4+
    10'b0100011011 : decode_table_dout_9b_tmp = 9'b010011011;  // D27.4+
    10'b0100011100 : decode_table_dout_9b_tmp = 9'b010011100;  // D28.4+
    10'b0100011101 : decode_table_dout_9b_tmp = 9'b010011101;  // D29.4+
    10'b0100011110 : decode_table_dout_9b_tmp = 9'b010011110;  // D30.4+
    // 数据 D3.4+ ~ D15.4+
    10'b0100100011 : decode_table_dout_9b_tmp = 9'b010000011;  // D3.4+
    10'b0100100101 : decode_table_dout_9b_tmp = 9'b010000101;  // D5.4+
    10'b0100100110 : decode_table_dout_9b_tmp = 9'b010000110;  // D6.4+
    10'b0100100111 : decode_table_dout_9b_tmp = 9'b010001000;  // D8.4+
    10'b0100101001 : decode_table_dout_9b_tmp = 9'b010001001;  // D9.4+
    10'b0100101010 : decode_table_dout_9b_tmp = 9'b010001010;  // D10.4+
    10'b0100101011 : decode_table_dout_9b_tmp = 9'b010000100;  // D4.4+
    10'b0100101100 : decode_table_dout_9b_tmp = 9'b010001100;  // D12.4+
    10'b0100101101 : decode_table_dout_9b_tmp = 9'b010000010;  // D2.4+
    10'b0100101110 : decode_table_dout_9b_tmp = 9'b010000001;  // D1.4+
    // 数据 D17.4+ ~ K28.4+
    10'b0100110001 : decode_table_dout_9b_tmp = 9'b010010001;  // D17.4+
    10'b0100110010 : decode_table_dout_9b_tmp = 9'b010010010;  // D18.4+
    10'b0100110011 : decode_table_dout_9b_tmp = 9'b010011000;  // D24.4+
    10'b0100110100 : decode_table_dout_9b_tmp = 9'b010010100;  // D20.4+
    10'b0100110101 : decode_table_dout_9b_tmp = 9'b010011111;  // D31.4+
    10'b0100110110 : decode_table_dout_9b_tmp = 9'b010010000;  // D16.4+
    10'b0100111000 : decode_table_dout_9b_tmp = 9'b010000111;  // D7.4+
    10'b0100111001 : decode_table_dout_9b_tmp = 9'b010000000;  // D0.4+
    10'b0100111010 : decode_table_dout_9b_tmp = 9'b010001111;  // D15.4+
    10'b0100111100 : decode_table_dout_9b_tmp = 9'b110011100;  // K28.4+
    // 控制 K28.2+，数据 D15.5+ ~ D14.5+
    10'b0101000011 : decode_table_dout_9b_tmp = 9'b101011100;  // K28.2+
    10'b0101000101 : decode_table_dout_9b_tmp = 9'b010101111;  // D15.5+
    10'b0101000110 : decode_table_dout_9b_tmp = 9'b010100000;  // D0.5+
    10'b0101000111 : decode_table_dout_9b_tmp = 9'b010100111;  // D7.5+
    10'b0101001001 : decode_table_dout_9b_tmp = 9'b010110000;  // D16.5+
    10'b0101001010 : decode_table_dout_9b_tmp = 9'b010111111;  // D31.5+
    10'b0101001011 : decode_table_dout_9b_tmp = 9'b010101011;  // D11.5+
    10'b0101001100 : decode_table_dout_9b_tmp = 9'b010111000;  // D24.5+
    10'b0101001101 : decode_table_dout_9b_tmp = 9'b010101101;  // D13.5+
    10'b0101001110 : decode_table_dout_9b_tmp = 9'b010101110;  // D14.5+
    // 数据 D1.5+ ~ D30.5-
    10'b0101010001 : decode_table_dout_9b_tmp = 9'b010100001;  // D1.5+
    10'b0101010010 : decode_table_dout_9b_tmp = 9'b010100010;  // D2.5+
    10'b0101010011 : decode_table_dout_9b_tmp = 9'b010110011;  // D19.5+
    10'b0101010100 : decode_table_dout_9b_tmp = 9'b010100100;  // D4.5+
    10'b0101010101 : decode_table_dout_9b_tmp = 9'b010110101;  // D21.5+
    10'b0101010110 : decode_table_dout_9b_tmp = 9'b010110110;  // D22.5+
    10'b0101010111 : decode_table_dout_9b_tmp = 9'b010110111;  // D23.5-
    10'b0101011000 : decode_table_dout_9b_tmp = 9'b010101000;  // D8.5+
    10'b0101011001 : decode_table_dout_9b_tmp = 9'b010111001;  // D25.5+
    10'b0101011010 : decode_table_dout_9b_tmp = 9'b010111010;  // D26.5+
    10'b0101011011 : decode_table_dout_9b_tmp = 9'b010111011;  // D27.5-
    10'b0101011100 : decode_table_dout_9b_tmp = 9'b010111100;  // D28.5+
    10'b0101011101 : decode_table_dout_9b_tmp = 9'b010111101;  // D29.5-
    10'b0101011110 : decode_table_dout_9b_tmp = 9'b010111110;  // D30.5-
    // 数据 D30.5+ ~ D1.5-
    10'b0101100001 : decode_table_dout_9b_tmp = 9'b010111110;  // D30.5+
    10'b0101100010 : decode_table_dout_9b_tmp = 9'b010111101;  // D29.5+
    10'b0101100011 : decode_table_dout_9b_tmp = 9'b010100011;  // D3.5+
    10'b0101100100 : decode_table_dout_9b_tmp = 9'b010111011;  // D27.5+
    10'b0101100101 : decode_table_dout_9b_tmp = 9'b010100101;  // D5.5+
    10'b0101100110 : decode_table_dout_9b_tmp = 9'b010100110;  // D6.5+
    10'b0101100111 : decode_table_dout_9b_tmp = 9'b010101000;  // D8.5-
    10'b0101101000 : decode_table_dout_9b_tmp = 9'b010110111;  // D23.5+
    10'b0101101001 : decode_table_dout_9b_tmp = 9'b010101001;  // D9.5+
    10'b0101101010 : decode_table_dout_9b_tmp = 9'b010101010;  // D10.5+
    10'b0101101011 : decode_table_dout_9b_tmp = 9'b010100100;  // D4.5-
    10'b0101101100 : decode_table_dout_9b_tmp = 9'b010101100;  // D12.5+
    10'b0101101101 : decode_table_dout_9b_tmp = 9'b010100010;  // D2.5-
    10'b0101101110 : decode_table_dout_9b_tmp = 9'b010100001;  // D1.5-
    // 数据 D17.5+ ~ D15.5-
    10'b0101110001 : decode_table_dout_9b_tmp = 9'b010110001;  // D17.5+
    10'b0101110010 : decode_table_dout_9b_tmp = 9'b010110010;  // D18.5+
    10'b0101110011 : decode_table_dout_9b_tmp = 9'b010111000;  // D24.5-
    10'b0101110100 : decode_table_dout_9b_tmp = 9'b010110100;  // D20.5+
    10'b0101110101 : decode_table_dout_9b_tmp = 9'b010111111;  // D31.5-
    10'b0101110110 : decode_table_dout_9b_tmp = 9'b010110000;  // D16.5-
    10'b0101111000 : decode_table_dout_9b_tmp = 9'b010100111;  // D7.5-
    10'b0101111001 : decode_table_dout_9b_tmp = 9'b010100000;  // D0.5-
    10'b0101111010 : decode_table_dout_9b_tmp = 9'b010101111;  // D15.5-
    10'b0101111100 : decode_table_dout_9b_tmp = 9'b110111100;  // K28.5-
    // 控制 K28.1+，数据 D15.6+ ~ D14.6+
    10'b0110000011 : decode_table_dout_9b_tmp = 9'b100111100;  // K28.1+
    10'b0110000101 : decode_table_dout_9b_tmp = 9'b011001111;  // D15.6+
    10'b0110000110 : decode_table_dout_9b_tmp = 9'b011000000;  // D0.6+
    10'b0110000111 : decode_table_dout_9b_tmp = 9'b011000111;  // D7.6+
    10'b0110001001 : decode_table_dout_9b_tmp = 9'b011010000;  // D16.6+
    10'b0110001010 : decode_table_dout_9b_tmp = 9'b011011111;  // D31.6+
    10'b0110001011 : decode_table_dout_9b_tmp = 9'b011001011;  // D11.6+
    10'b0110001100 : decode_table_dout_9b_tmp = 9'b011011000;  // D24.6+
    10'b0110001101 : decode_table_dout_9b_tmp = 9'b011001101;  // D13.6+
    10'b0110001110 : decode_table_dout_9b_tmp = 9'b011001110;  // D14.6+
    // 数据 D1.6+ ~ D30.6-
    10'b0110010001 : decode_table_dout_9b_tmp = 9'b011000001;  // D1.6+
    10'b0110010010 : decode_table_dout_9b_tmp = 9'b011000010;  // D2.6+
    10'b0110010011 : decode_table_dout_9b_tmp = 9'b011010011;  // D19.6+
    10'b0110010100 : decode_table_dout_9b_tmp = 9'b011000100;  // D4.6+
    10'b0110010101 : decode_table_dout_9b_tmp = 9'b011010101;  // D21.6+
    10'b0110010110 : decode_table_dout_9b_tmp = 9'b011010110;  // D22.6+
    10'b0110010111 : decode_table_dout_9b_tmp = 9'b011010111;  // D23.6-
    10'b0110011000 : decode_table_dout_9b_tmp = 9'b011001000;  // D8.6+
    10'b0110011001 : decode_table_dout_9b_tmp = 9'b011011001;  // D25.6+
    10'b0110011010 : decode_table_dout_9b_tmp = 9'b011011010;  // D26.6+
    10'b0110011011 : decode_table_dout_9b_tmp = 9'b011011011;  // D27.6-
    10'b0110011100 : decode_table_dout_9b_tmp = 9'b011011100;  // D28.6+
    10'b0110011101 : decode_table_dout_9b_tmp = 9'b011011101;  // D29.6-
    10'b0110011110 : decode_table_dout_9b_tmp = 9'b011011110;  // D30.6-
    // 数据 D30.6+ ~ D1.6-
    10'b0110100001 : decode_table_dout_9b_tmp = 9'b011011110;  // D30.6+
    10'b0110100010 : decode_table_dout_9b_tmp = 9'b011011101;  // D29.6+
    10'b0110100011 : decode_table_dout_9b_tmp = 9'b011000011;  // D3.6+
    10'b0110100100 : decode_table_dout_9b_tmp = 9'b011011011;  // D27.6+
    10'b0110100101 : decode_table_dout_9b_tmp = 9'b011000101;  // D5.6+
    10'b0110100110 : decode_table_dout_9b_tmp = 9'b011000110;  // D6.6+
    10'b0110100111 : decode_table_dout_9b_tmp = 9'b011001000;  // D8.6-
    10'b0110101000 : decode_table_dout_9b_tmp = 9'b011010111;  // D23.6+
    10'b0110101001 : decode_table_dout_9b_tmp = 9'b011001001;  // D9.6+
    10'b0110101010 : decode_table_dout_9b_tmp = 9'b011001010;  // D10.6+
    10'b0110101011 : decode_table_dout_9b_tmp = 9'b011000100;  // D4.6-
    10'b0110101100 : decode_table_dout_9b_tmp = 9'b011001100;  // D12.6+
    10'b0110101101 : decode_table_dout_9b_tmp = 9'b011000010;  // D2.6-
    10'b0110101110 : decode_table_dout_9b_tmp = 9'b011000001;  // D1.6-
    // 数据 D17.6+ ~ D15.6-
    10'b0110110001 : decode_table_dout_9b_tmp = 9'b011010001;  // D17.6+
    10'b0110110010 : decode_table_dout_9b_tmp = 9'b011010010;  // D18.6+
    10'b0110110011 : decode_table_dout_9b_tmp = 9'b011011000;  // D24.6-
    10'b0110110100 : decode_table_dout_9b_tmp = 9'b011010100;  // D20.6+
    10'b0110110101 : decode_table_dout_9b_tmp = 9'b011011111;  // D31.6-
    10'b0110110110 : decode_table_dout_9b_tmp = 9'b011010000;  // D16.6-
    10'b0110111000 : decode_table_dout_9b_tmp = 9'b011000111;  // D7.6-
    10'b0110111001 : decode_table_dout_9b_tmp = 9'b011000000;  // D0.6-
    10'b0110111010 : decode_table_dout_9b_tmp = 9'b011001111;  // D15.6-
    10'b0110111100 : decode_table_dout_9b_tmp = 9'b111011100;  // K28.6-
    // 数据 D15.7- ~ D12.7-
    10'b0111000101 : decode_table_dout_9b_tmp = 9'b011101111;  // D15.7-
    10'b0111000110 : decode_table_dout_9b_tmp = 9'b011100000;  // D0.7-
    10'b0111000111 : decode_table_dout_9b_tmp = 9'b011100111;  // D7.7-
    10'b0111001001 : decode_table_dout_9b_tmp = 9'b011110000;  // D16.7-
    10'b0111001010 : decode_table_dout_9b_tmp = 9'b011111111;  // D31.7-
    10'b0111001011 : decode_table_dout_9b_tmp = 9'b011101011;  // D11.7-
    10'b0111001100 : decode_table_dout_9b_tmp = 9'b011111000;  // D24.7-
    10'b0111001101 : decode_table_dout_9b_tmp = 9'b011101101;  // D13.7-
    10'b0111001110 : decode_table_dout_9b_tmp = 9'b011101110;  // D14.7-
    // 数据 D1.7- ~ D12.7-
    10'b0111010001 : decode_table_dout_9b_tmp = 9'b011100001;  // D1.7-
    10'b0111010010 : decode_table_dout_9b_tmp = 9'b011100010;  // D2.7-
    10'b0111010011 : decode_table_dout_9b_tmp = 9'b011110011;  // D19.7-
    10'b0111010100 : decode_table_dout_9b_tmp = 9'b011100100;  // D4.7-
    10'b0111010101 : decode_table_dout_9b_tmp = 9'b011110101;  // D21.7-
    10'b0111010110 : decode_table_dout_9b_tmp = 9'b011110110;  // D22.7-
    10'b0111011000 : decode_table_dout_9b_tmp = 9'b011101000;  // D8.7-
    10'b0111011001 : decode_table_dout_9b_tmp = 9'b011111001;  // D25.7-
    10'b0111011010 : decode_table_dout_9b_tmp = 9'b011111010;  // D26.7-
    10'b0111011100 : decode_table_dout_9b_tmp = 9'b011111100;  // D28.7-
    // 数据 D30.7- ~ D12.7-
    10'b0111100001 : decode_table_dout_9b_tmp = 9'b011111110;  // D30.7-
    10'b0111100010 : decode_table_dout_9b_tmp = 9'b011111101;  // D29.7-
    10'b0111100011 : decode_table_dout_9b_tmp = 9'b011100011;  // D3.7-
    10'b0111100100 : decode_table_dout_9b_tmp = 9'b011111011;  // D27.7-
    10'b0111100101 : decode_table_dout_9b_tmp = 9'b011100101;  // D5.7-
    10'b0111100110 : decode_table_dout_9b_tmp = 9'b011100110;  // D6.7-
    10'b0111101000 : decode_table_dout_9b_tmp = 9'b011110111;  // D23.7-
    10'b0111101001 : decode_table_dout_9b_tmp = 9'b011101001;  // D9.7-
    10'b0111101010 : decode_table_dout_9b_tmp = 9'b011101010;  // D10.7-
    10'b0111101100 : decode_table_dout_9b_tmp = 9'b011101100;  // D12.7-
    // 数据 D19.7+ ~ D30.7+
    10'b1000010011 : decode_table_dout_9b_tmp = 9'b011110011;  // D19.7+
    10'b1000010101 : decode_table_dout_9b_tmp = 9'b011110101;  // D21.7+
    10'b1000010110 : decode_table_dout_9b_tmp = 9'b011110110;  // D22.7+
    10'b1000010111 : decode_table_dout_9b_tmp = 9'b011110111;  // D23.7+
    10'b1000011001 : decode_table_dout_9b_tmp = 9'b011111001;  // D25.7+
    10'b1000011010 : decode_table_dout_9b_tmp = 9'b011111010;  // D26.7+
    10'b1000011011 : decode_table_dout_9b_tmp = 9'b011111011;  // D27.7+
    10'b1000011100 : decode_table_dout_9b_tmp = 9'b011111100;  // D28.7+
    10'b1000011101 : decode_table_dout_9b_tmp = 9'b011111101;  // D29.7+
    10'b1000011110 : decode_table_dout_9b_tmp = 9'b011111110;  // D30.7+
    // 数据 D3.7+ ~ D15.7+
    10'b1000100011 : decode_table_dout_9b_tmp = 9'b011100011;  // D3.7+
    10'b1000100101 : decode_table_dout_9b_tmp = 9'b011100101;  // D5.7+
    10'b1000100110 : decode_table_dout_9b_tmp = 9'b011100110;  // D6.7+
    10'b1000100111 : decode_table_dout_9b_tmp = 9'b011101000;  // D8.7+
    10'b1000101001 : decode_table_dout_9b_tmp = 9'b011101001;  // D9.7+
    10'b1000101010 : decode_table_dout_9b_tmp = 9'b011101010;  // D10.7+
    10'b1000101011 : decode_table_dout_9b_tmp = 9'b011100100;  // D4.7+
    10'b1000101100 : decode_table_dout_9b_tmp = 9'b011101100;  // D12.7+
    10'b1000101101 : decode_table_dout_9b_tmp = 9'b011100010;  // D2.7+
    10'b1000101110 : decode_table_dout_9b_tmp = 9'b011100001;  // D1.7+
    // 数据 D17.7+ ~ D15.7+
    10'b1000110001 : decode_table_dout_9b_tmp = 9'b011110001;  // D17.7+
    10'b1000110010 : decode_table_dout_9b_tmp = 9'b011110010;  // D18.7+
    10'b1000110011 : decode_table_dout_9b_tmp = 9'b011111000;  // D24.7+
    10'b1000110100 : decode_table_dout_9b_tmp = 9'b011110100;  // D20.7+
    10'b1000110101 : decode_table_dout_9b_tmp = 9'b011111111;  // D31.7+
    10'b1000110110 : decode_table_dout_9b_tmp = 9'b011110000;  // D16.7+
    10'b1000111000 : decode_table_dout_9b_tmp = 9'b011100111;  // D7.7+
    10'b1000111001 : decode_table_dout_9b_tmp = 9'b011100000;  // D0.7+
    10'b1000111010 : decode_table_dout_9b_tmp = 9'b011101111;  // D15.7+
    // 控制 K28.6+，数据 D15.1+ ~ D14.1+
    10'b1001000011 : decode_table_dout_9b_tmp = 9'b111011100;  // K28.6+
    10'b1001000101 : decode_table_dout_9b_tmp = 9'b000101111;  // D15.1+
    10'b1001000110 : decode_table_dout_9b_tmp = 9'b000100000;  // D0.1+
    10'b1001000111 : decode_table_dout_9b_tmp = 9'b000100111;  // D7.1+
    10'b1001001001 : decode_table_dout_9b_tmp = 9'b000110000;  // D16.1+
    10'b1001001010 : decode_table_dout_9b_tmp = 9'b000111111;  // D31.1+
    10'b1001001011 : decode_table_dout_9b_tmp = 9'b000101011;  // D11.1+
    10'b1001001100 : decode_table_dout_9b_tmp = 9'b000111000;  // D24.1+
    10'b1001001101 : decode_table_dout_9b_tmp = 9'b000101101;  // D13.1+
    10'b1001001110 : decode_table_dout_9b_tmp = 9'b000101110;  // D14.1+
    // 数据 D1.1+ ~ D30.1-
    10'b1001010001 : decode_table_dout_9b_tmp = 9'b000100001;  // D1.1+
    10'b1001010010 : decode_table_dout_9b_tmp = 9'b000100010;  // D2.1+
    10'b1001010011 : decode_table_dout_9b_tmp = 9'b000110011;  // D19.1+
    10'b1001010100 : decode_table_dout_9b_tmp = 9'b000100100;  // D4.1+
    10'b1001010101 : decode_table_dout_9b_tmp = 9'b000110101;  // D21.1+
    10'b1001010110 : decode_table_dout_9b_tmp = 9'b000110110;  // D22.1+
    10'b1001010111 : decode_table_dout_9b_tmp = 9'b000110111;  // D23.1-
    10'b1001011000 : decode_table_dout_9b_tmp = 9'b000101000;  // D8.1+
    10'b1001011001 : decode_table_dout_9b_tmp = 9'b000111001;  // D25.1+
    10'b1001011010 : decode_table_dout_9b_tmp = 9'b000111010;  // D26.1+
    10'b1001011011 : decode_table_dout_9b_tmp = 9'b000111011;  // D27.1-
    10'b1001011100 : decode_table_dout_9b_tmp = 9'b000111100;  // D28.1+
    10'b1001011101 : decode_table_dout_9b_tmp = 9'b000111101;  // D29.1-
    10'b1001011110 : decode_table_dout_9b_tmp = 9'b000111110;  // D30.1-
    // 数据 D30.1+ ~ D1.1-
    10'b1001100001 : decode_table_dout_9b_tmp = 9'b000111110;  // D30.1+
    10'b1001100010 : decode_table_dout_9b_tmp = 9'b000111101;  // D29.1+
    10'b1001100011 : decode_table_dout_9b_tmp = 9'b000100011;  // D3.1+
    10'b1001100100 : decode_table_dout_9b_tmp = 9'b000111011;  // D27.1+
    10'b1001100101 : decode_table_dout_9b_tmp = 9'b000100101;  // D5.1+
    10'b1001100110 : decode_table_dout_9b_tmp = 9'b000100110;  // D6.1+
    10'b1001100111 : decode_table_dout_9b_tmp = 9'b000101000;  // D8.1-
    10'b1001101000 : decode_table_dout_9b_tmp = 9'b000110111;  // D23.1+
    10'b1001101001 : decode_table_dout_9b_tmp = 9'b000101001;  // D9.1+
    10'b1001101010 : decode_table_dout_9b_tmp = 9'b000101010;  // D10.1+
    10'b1001101011 : decode_table_dout_9b_tmp = 9'b000100100;  // D4.1-
    10'b1001101100 : decode_table_dout_9b_tmp = 9'b000101100;  // D12.1+
    10'b1001101101 : decode_table_dout_9b_tmp = 9'b000100010;  // D2.1-
    10'b1001101110 : decode_table_dout_9b_tmp = 9'b000100001;  // D1.1-
    // 数据 D17.1+ ~ K28.1-
    10'b1001110001 : decode_table_dout_9b_tmp = 9'b000110001;  // D17.1+
    10'b1001110010 : decode_table_dout_9b_tmp = 9'b000110010;  // D18.1+
    10'b1001110011 : decode_table_dout_9b_tmp = 9'b000111000;  // D24.1-
    10'b1001110100 : decode_table_dout_9b_tmp = 9'b000110100;  // D20.1+
    10'b1001110101 : decode_table_dout_9b_tmp = 9'b000111111;  // D31.1-
    10'b1001110110 : decode_table_dout_9b_tmp = 9'b000110000;  // D16.1-
    10'b1001111000 : decode_table_dout_9b_tmp = 9'b000100111;  // D7.1-
    10'b1001111001 : decode_table_dout_9b_tmp = 9'b000100000;  // D0.1-
    10'b1001111010 : decode_table_dout_9b_tmp = 9'b000101111;  // D15.1-
    10'b1001111100 : decode_table_dout_9b_tmp = 9'b100111100;  // K28.1-
    // 控制 K28.5+，数据 D15.2+ ~ D14.2+
    10'b1010000011 : decode_table_dout_9b_tmp = 9'b110111100;  // K28.5+
    10'b1010000101 : decode_table_dout_9b_tmp = 9'b001001111;  // D15.2+
    10'b1010000110 : decode_table_dout_9b_tmp = 9'b001000000;  // D0.2+
    10'b1010000111 : decode_table_dout_9b_tmp = 9'b001000111;  // D7.2+
    10'b1010001001 : decode_table_dout_9b_tmp = 9'b001010000;  // D16.2+
    10'b1010001010 : decode_table_dout_9b_tmp = 9'b001011111;  // D31.2+
    10'b1010001011 : decode_table_dout_9b_tmp = 9'b001001011;  // D11.2+
    10'b1010001100 : decode_table_dout_9b_tmp = 9'b001011000;  // D24.2+
    10'b1010001101 : decode_table_dout_9b_tmp = 9'b001001101;  // D13.2+
    10'b1010001110 : decode_table_dout_9b_tmp = 9'b001001110;  // D14.2+
    // 数据 D1.2+ ~ D30.2-
    10'b1010010001 : decode_table_dout_9b_tmp = 9'b001000001;  // D1.2+
    10'b1010010010 : decode_table_dout_9b_tmp = 9'b001000010;  // D2.2+
    10'b1010010011 : decode_table_dout_9b_tmp = 9'b001010011;  // D19.2+
    10'b1010010100 : decode_table_dout_9b_tmp = 9'b001000100;  // D4.2+
    10'b1010010101 : decode_table_dout_9b_tmp = 9'b001010101;  // D21.2+
    10'b1010010110 : decode_table_dout_9b_tmp = 9'b001010110;  // D22.2+
    10'b1010010111 : decode_table_dout_9b_tmp = 9'b001010111;  // D23.2-
    10'b1010011000 : decode_table_dout_9b_tmp = 9'b001001000;  // D8.2+
    10'b1010011001 : decode_table_dout_9b_tmp = 9'b001011001;  // D25.2+
    10'b1010011010 : decode_table_dout_9b_tmp = 9'b001011010;  // D26.2+
    10'b1010011011 : decode_table_dout_9b_tmp = 9'b001011011;  // D27.2-
    10'b1010011100 : decode_table_dout_9b_tmp = 9'b001011100;  // D28.2+
    10'b1010011101 : decode_table_dout_9b_tmp = 9'b001011101;  // D29.2-
    10'b1010011110 : decode_table_dout_9b_tmp = 9'b001011110;  // D30.2-
    // 数据 D30.2+ ~ D1.2-
    10'b1010100001 : decode_table_dout_9b_tmp = 9'b001011110;  // D30.2+
    10'b1010100010 : decode_table_dout_9b_tmp = 9'b001011101;  // D29.2+
    10'b1010100011 : decode_table_dout_9b_tmp = 9'b001000011;  // D3.2+
    10'b1010100100 : decode_table_dout_9b_tmp = 9'b001011011;  // D27.2+
    10'b1010100101 : decode_table_dout_9b_tmp = 9'b001000101;  // D5.2+
    10'b1010100110 : decode_table_dout_9b_tmp = 9'b001000110;  // D6.2+
    10'b1010100111 : decode_table_dout_9b_tmp = 9'b001001000;  // D8.2-
    10'b1010101000 : decode_table_dout_9b_tmp = 9'b001010111;  // D23.2+
    10'b1010101001 : decode_table_dout_9b_tmp = 9'b001001001;  // D9.2+
    10'b1010101010 : decode_table_dout_9b_tmp = 9'b001001010;  // D10.2+
    10'b1010101011 : decode_table_dout_9b_tmp = 9'b001000100;  // D4.2-
    10'b1010101100 : decode_table_dout_9b_tmp = 9'b001001100;  // D12.2+
    10'b1010101101 : decode_table_dout_9b_tmp = 9'b001000010;  // D2.2-
    10'b1010101110 : decode_table_dout_9b_tmp = 9'b001000001;  // D1.2-
    // 数据 D17.2+ ~ K28.2-
    10'b1010110001 : decode_table_dout_9b_tmp = 9'b001010001;  // D17.2+
    10'b1010110010 : decode_table_dout_9b_tmp = 9'b001010010;  // D18.2+
    10'b1010110011 : decode_table_dout_9b_tmp = 9'b001011000;  // D24.2-
    10'b1010110100 : decode_table_dout_9b_tmp = 9'b001010100;  // D20.2+
    10'b1010110101 : decode_table_dout_9b_tmp = 9'b001011111;  // D31.2-
    10'b1010110110 : decode_table_dout_9b_tmp = 9'b001010000;  // D16.2-
    10'b1010111000 : decode_table_dout_9b_tmp = 9'b001000111;  // D7.2-
    10'b1010111001 : decode_table_dout_9b_tmp = 9'b001000000;  // D0.2-
    10'b1010111010 : decode_table_dout_9b_tmp = 9'b001001111;  // D15.2-
    10'b1010111100 : decode_table_dout_9b_tmp = 9'b101011100;  // K28.2-
    // 控制 K28.4-，数据 D15.4- ~ D14.4-
    10'b1011000011 : decode_table_dout_9b_tmp = 9'b110011100;  // K28.4-
    10'b1011000101 : decode_table_dout_9b_tmp = 9'b010001111;  // D15.4-
    10'b1011000110 : decode_table_dout_9b_tmp = 9'b010000000;  // D0.4-
    10'b1011000111 : decode_table_dout_9b_tmp = 9'b010000111;  // D7.4-
    10'b1011001001 : decode_table_dout_9b_tmp = 9'b010010000;  // D16.4-
    10'b1011001010 : decode_table_dout_9b_tmp = 9'b010011111;  // D31.4-
    10'b1011001011 : decode_table_dout_9b_tmp = 9'b010001011;  // D11.4-
    10'b1011001100 : decode_table_dout_9b_tmp = 9'b010011000;  // D24.4-
    10'b1011001101 : decode_table_dout_9b_tmp = 9'b010001101;  // D13.4-
    10'b1011001110 : decode_table_dout_9b_tmp = 9'b010001110;  // D14.4-
    // 数据 D1.4- ~ D28.4-
    10'b1011010001 : decode_table_dout_9b_tmp = 9'b010000001;  // D1.4-
    10'b1011010010 : decode_table_dout_9b_tmp = 9'b010000010;  // D2.4-
    10'b1011010011 : decode_table_dout_9b_tmp = 9'b010010011;  // D19.4-
    10'b1011010100 : decode_table_dout_9b_tmp = 9'b010000100;  // D4.4-
    10'b1011010101 : decode_table_dout_9b_tmp = 9'b010010101;  // D21.4-
    10'b1011010110 : decode_table_dout_9b_tmp = 9'b010010110;  // D22.4-
    10'b1011011000 : decode_table_dout_9b_tmp = 9'b010001000;  // D8.4-
    10'b1011011001 : decode_table_dout_9b_tmp = 9'b010011001;  // D25.4-
    10'b1011011010 : decode_table_dout_9b_tmp = 9'b010011010;  // D26.4-
    10'b1011011100 : decode_table_dout_9b_tmp = 9'b010011100;  // D28.4-
    // 数据 D30.4- ~ D12.4-
    10'b1011100001 : decode_table_dout_9b_tmp = 9'b010011110;  // D30.4-
    10'b1011100010 : decode_table_dout_9b_tmp = 9'b010011101;  // D29.4-
    10'b1011100011 : decode_table_dout_9b_tmp = 9'b010000011;  // D3.4-
    10'b1011100100 : decode_table_dout_9b_tmp = 9'b010011011;  // D27.4-
    10'b1011100101 : decode_table_dout_9b_tmp = 9'b010000101;  // D5.4-
    10'b1011100110 : decode_table_dout_9b_tmp = 9'b010000110;  // D6.4-
    10'b1011101000 : decode_table_dout_9b_tmp = 9'b010010111;  // D23.4-
    10'b1011101001 : decode_table_dout_9b_tmp = 9'b010001001;  // D9.4-
    10'b1011101010 : decode_table_dout_9b_tmp = 9'b010001010;  // D10.4-
    10'b1011101100 : decode_table_dout_9b_tmp = 9'b010001100;  // D12.4-
    // 数据 D17.4- ~ D20.4-
    10'b1011110001 : decode_table_dout_9b_tmp = 9'b010010001;  // D17.4-
    10'b1011110010 : decode_table_dout_9b_tmp = 9'b010010010;  // D18.4-
    10'b1011110100 : decode_table_dout_9b_tmp = 9'b010010100;  // D20.4-
    // 数据 D11.3- ~ D14.3-
    10'b1100001011 : decode_table_dout_9b_tmp = 9'b001101011;  // D11.3-
    10'b1100001101 : decode_table_dout_9b_tmp = 9'b001101101;  // D13.3-
    10'b1100001110 : decode_table_dout_9b_tmp = 9'b001101110;  // D14.3-
    // 数据 D19.3- ~ D30.3-
    10'b1100010011 : decode_table_dout_9b_tmp = 9'b001110011;  // D19.3-
    10'b1100010101 : decode_table_dout_9b_tmp = 9'b001110101;  // D21.3-
    10'b1100010110 : decode_table_dout_9b_tmp = 9'b001110110;  // D22.3-
    10'b1100010111 : decode_table_dout_9b_tmp = 9'b001110111;  // D23.3-
    10'b1100011001 : decode_table_dout_9b_tmp = 9'b001111001;  // D25.3-
    10'b1100011010 : decode_table_dout_9b_tmp = 9'b001111010;  // D26.3-
    10'b1100011011 : decode_table_dout_9b_tmp = 9'b001111011;  // D27.3-
    10'b1100011100 : decode_table_dout_9b_tmp = 9'b001111100;  // D28.3-
    10'b1100011101 : decode_table_dout_9b_tmp = 9'b001111101;  // D29.3-
    10'b1100011110 : decode_table_dout_9b_tmp = 9'b001111110;  // D30.3-
    // 数据 D3.3- ~ D1.3-
    10'b1100100011 : decode_table_dout_9b_tmp = 9'b001100011;  // D3.3-
    10'b1100100101 : decode_table_dout_9b_tmp = 9'b001100101;  // D5.3-
    10'b1100100110 : decode_table_dout_9b_tmp = 9'b001100110;  // D6.3-
    10'b1100100111 : decode_table_dout_9b_tmp = 9'b001101000;  // D8.3-
    10'b1100101001 : decode_table_dout_9b_tmp = 9'b001101001;  // D9.3-
    10'b1100101010 : decode_table_dout_9b_tmp = 9'b001101010;  // D10.3-
    10'b1100101011 : decode_table_dout_9b_tmp = 9'b001100100;  // D4.3-
    10'b1100101100 : decode_table_dout_9b_tmp = 9'b001101100;  // D12.3-
    10'b1100101101 : decode_table_dout_9b_tmp = 9'b001100010;  // D2.3-
    10'b1100101110 : decode_table_dout_9b_tmp = 9'b001100001;  // D1.3-
    // 数据 D17.3- ~ K28.3-
    10'b1100110001 : decode_table_dout_9b_tmp = 9'b001110001;  // D17.3-
    10'b1100110010 : decode_table_dout_9b_tmp = 9'b001110010;  // D18.3-
    10'b1100110011 : decode_table_dout_9b_tmp = 9'b001111000;  // D24.3-
    10'b1100110100 : decode_table_dout_9b_tmp = 9'b001110100;  // D20.3-
    10'b1100110101 : decode_table_dout_9b_tmp = 9'b001111111;  // D31.3-
    10'b1100110110 : decode_table_dout_9b_tmp = 9'b001110000;  // D16.3-
    10'b1100111000 : decode_table_dout_9b_tmp = 9'b001100111;  // D7.3-
    10'b1100111001 : decode_table_dout_9b_tmp = 9'b001100000;  // D0.3-
    10'b1100111010 : decode_table_dout_9b_tmp = 9'b001101111;  // D15.3-
    10'b1100111100 : decode_table_dout_9b_tmp = 9'b101111100;  // K28.3-
    // 控制 K28.0-，数据 D15.0- ~ D14.0-
    10'b1101000011 : decode_table_dout_9b_tmp = 9'b100011100;  // K28.0-
    10'b1101000101 : decode_table_dout_9b_tmp = 9'b000001111;  // D15.0-
    10'b1101000110 : decode_table_dout_9b_tmp = 9'b000000000;  // D0.0-
    10'b1101000111 : decode_table_dout_9b_tmp = 9'b000000111;  // D7.0-
    10'b1101001001 : decode_table_dout_9b_tmp = 9'b000010000;  // D16.0-
    10'b1101001010 : decode_table_dout_9b_tmp = 9'b000011111;  // D31.0-
    10'b1101001011 : decode_table_dout_9b_tmp = 9'b000001011;  // D11.0-
    10'b1101001100 : decode_table_dout_9b_tmp = 9'b000011000;  // D24.0-
    10'b1101001101 : decode_table_dout_9b_tmp = 9'b000001101;  // D13.0-
    10'b1101001110 : decode_table_dout_9b_tmp = 9'b000001110;  // D14.0-
    // 数据 D1.0- ~ D28.0-
    10'b1101010001 : decode_table_dout_9b_tmp = 9'b000000001;  // D1.0-
    10'b1101010010 : decode_table_dout_9b_tmp = 9'b000000010;  // D2.0-
    10'b1101010011 : decode_table_dout_9b_tmp = 9'b000010011;  // D19.0-
    10'b1101010100 : decode_table_dout_9b_tmp = 9'b000000100;  // D4.0-
    10'b1101010101 : decode_table_dout_9b_tmp = 9'b000010101;  // D21.0-
    10'b1101010110 : decode_table_dout_9b_tmp = 9'b000010110;  // D22.0-
    10'b1101011000 : decode_table_dout_9b_tmp = 9'b000001000;  // D8.0-
    10'b1101011001 : decode_table_dout_9b_tmp = 9'b000011001;  // D25.0-
    10'b1101011010 : decode_table_dout_9b_tmp = 9'b000011010;  // D26.0-
    10'b1101011100 : decode_table_dout_9b_tmp = 9'b000011100;  // D28.0-
    // 数据 D30.0- ~ D12.0-
    10'b1101100001 : decode_table_dout_9b_tmp = 9'b000011110;  // D30.0-
    10'b1101100010 : decode_table_dout_9b_tmp = 9'b000011101;  // D29.0-
    10'b1101100011 : decode_table_dout_9b_tmp = 9'b000000011;  // D3.0-
    10'b1101100100 : decode_table_dout_9b_tmp = 9'b000011011;  // D27.0-
    10'b1101100101 : decode_table_dout_9b_tmp = 9'b000000101;  // D5.0-
    10'b1101100110 : decode_table_dout_9b_tmp = 9'b000000110;  // D6.0-
    10'b1101101000 : decode_table_dout_9b_tmp = 9'b000010111;  // D23.0-
    10'b1101101001 : decode_table_dout_9b_tmp = 9'b000001001;  // D9.0-
    10'b1101101010 : decode_table_dout_9b_tmp = 9'b000001010;  // D10.0-
    10'b1101101100 : decode_table_dout_9b_tmp = 9'b000001100;  // D12.0-
    // 数据 D17.0- ~ D20.0-
    10'b1101110001 : decode_table_dout_9b_tmp = 9'b000010001;  // D17.0-
    10'b1101110010 : decode_table_dout_9b_tmp = 9'b000010010;  // D18.0-
    10'b1101110100 : decode_table_dout_9b_tmp = 9'b000010100;  // D20.0-
    // 控制字符 K28.7- ~ K14.7-
    10'b1110000011 : decode_table_dout_9b_tmp = 9'b111111100;  // K28.7-
    10'b1110000101 : decode_table_dout_9b_tmp = 9'b111101111;  // K15.7-
    10'b1110000110 : decode_table_dout_9b_tmp = 9'b111100000;  // K0.7-
    10'b1110000111 : decode_table_dout_9b_tmp = 9'b111100111;  // K7.7-
    10'b1110001001 : decode_table_dout_9b_tmp = 9'b111110000;  // K16.7-
    10'b1110001010 : decode_table_dout_9b_tmp = 9'b111111111;  // K31.7-
    10'b1110001011 : decode_table_dout_9b_tmp = 9'b111101011;  // K11.7-
    10'b1110001100 : decode_table_dout_9b_tmp = 9'b111111000;  // K24.7-
    10'b1110001101 : decode_table_dout_9b_tmp = 9'b111101101;  // K13.7-
    10'b1110001110 : decode_table_dout_9b_tmp = 9'b111101110;  // K14.7-
    // 控制字符 K1.7- ~ K26.7-
    10'b1110010001 : decode_table_dout_9b_tmp = 9'b111100001;  // K1.7-
    10'b1110010010 : decode_table_dout_9b_tmp = 9'b111100010;  // K2.7-
    10'b1110010011 : decode_table_dout_9b_tmp = 9'b111110011;  // K19.7-
    10'b1110010100 : decode_table_dout_9b_tmp = 9'b111100100;  // K4.7-
    10'b1110010101 : decode_table_dout_9b_tmp = 9'b111110101;  // K21.7-
    10'b1110010110 : decode_table_dout_9b_tmp = 9'b111110110;  // K22.7-
    10'b1110011000 : decode_table_dout_9b_tmp = 9'b111101000;  // K8.7-
    10'b1110011001 : decode_table_dout_9b_tmp = 9'b111111001;  // K25.7-
    10'b1110011010 : decode_table_dout_9b_tmp = 9'b111111010;  // K26.7-
    // 控制字符 K30.7- ~ K12.7-
    10'b1110100001 : decode_table_dout_9b_tmp = 9'b111111110;  // K30.7-
    10'b1110100010 : decode_table_dout_9b_tmp = 9'b111111101;  // K29.7-
    10'b1110100011 : decode_table_dout_9b_tmp = 9'b111100011;  // K3.7-
    10'b1110100100 : decode_table_dout_9b_tmp = 9'b111111011;  // K27.7-
    10'b1110100101 : decode_table_dout_9b_tmp = 9'b111100101;  // K5.7-
    10'b1110100110 : decode_table_dout_9b_tmp = 9'b111100110;  // K6.7-
    10'b1110101000 : decode_table_dout_9b_tmp = 9'b111110111;  // K23.7-
    10'b1110101001 : decode_table_dout_9b_tmp = 9'b111101001;  // K9.7-
    10'b1110101010 : decode_table_dout_9b_tmp = 9'b111101010;  // K10.7-
    10'b1110101100 : decode_table_dout_9b_tmp = 9'b111101100;  // K12.7-
    // 数据 D17.7- ~ D20.7-
    10'b1110110001 : decode_table_dout_9b_tmp = 9'b011110001;  // D17.7-
    10'b1110110010 : decode_table_dout_9b_tmp = 9'b011110010;  // D18.7-
    10'b1110110100 : decode_table_dout_9b_tmp = 9'b011110100;  // D20.7-
    // 未定义码字：输出错误标志
    default : decode_table_dout_9b_tmp = 9'b100000000;  // ERR
  endcase
end
//-- 查找表 ------------------------------------------------------------


endmodule
`resetall