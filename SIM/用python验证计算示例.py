from encdec8b10b import EncDec8B10B

def verify_sequence():
    print("8b/10b 编码序列验证（初始 RD = RD-）\n")
    rd = 0  # 0 表示 RD-，1 表示 RD+

    # 输入序列：D.27.6, K.28.3, D.0.7, K.30.7
    # 数据格式：8位整数 = (3位 << 5) | 5位
    inputs = [
        (0b11011011, 0),  # D.27.6 = 0xDB
        (0x7C, 1),        # K.28.3 = 0x7C
        (0xE0, 0),        # D.0.7  = 0xE0
        (0xFE, 1)         # K.30.7 = 0xFE
    ]

    for i, (data, is_k) in enumerate(inputs, 1):
        rd, encoded = EncDec8B10B.enc_8b10b(data, rd, is_k)
        bin_str = f"{encoded:010b}"          # 10位二进制
        hex_str = f"0x{encoded:03X}"         # 3位十六进制
        rd_str = "RD+" if rd == 1 else "RD-"
        print(f"步骤{i}: 输入 0x{data:02X} ({'K' if is_k else 'D'}) → 输出 {bin_str}  {hex_str}  RD={rd_str}")

    print("\n手动计算结果应为：")
    print("1. 0110 011011 → 0x19B")
    print("2. 0011 000011 → 0x0C3")
    print("3. 1000 111001 → 0x239")
    print("4. 0001 011110 → 0x05E")
    print("最终 RD = RD-")

if __name__ == "__main__":
    verify_sequence()