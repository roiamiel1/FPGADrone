def binary_to_verilog_case(input_file):
    with open(input_file, 'rb') as f:
        data = f.read()

    # Ensure even number of bytes (16-bit words)
    if len(data) % 2 != 0:
        raise ValueError("Binary file must contain an even number of bytes (16-bit aligned).")

    output_lines = []

    # Process each 2-byte word
    for addr in range(0, len(data), 2):
        word_bytes = data[addr:addr+2]
        word = int.from_bytes(word_bytes, 'big')  # or 'little' if needed
        line = f"40'h{addr//2:010X}: rom_data <= 16'h{word:04X};"
        output_lines.append(line)

    # Add default case
    output_lines.append("default:        rom_data <= 16'h0000;")

    return output_lines


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <binary_file>")
        sys.exit(1)

    lines = binary_to_verilog_case(sys.argv[1])
    text = "`define ROM_SWITCH_CASE\t\\\n" + "\t\\\n".join(lines)
    with open("tests/hardware/startup_test/rom_switch_case.v", "w") as f:
        f.write(text)

    
        
