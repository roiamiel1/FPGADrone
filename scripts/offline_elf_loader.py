import sys
import argparse
from colorama import Fore, Back, Style
from elftools.elf.elffile import ELFFile

STACK_BASE_ADDR = 0x3ff0

SP = 29
FP = 30
ZERO = 0

def load_elf_to_memory_image(elf_path):
    with open(elf_path, 'rb') as f:
        elf = ELFFile(f)

        # Ensure it's an executable ELF
        if elf['e_type'] != 'ET_EXEC':
            raise ValueError("Only statically linked ET_EXEC files are supported.")

        # Collect all PT_LOAD segments
        segments = [seg for seg in elf.iter_segments() if seg['p_type'] == 'PT_LOAD']
        if not segments:
            raise ValueError("No loadable segments found in ELF.")

        # Determine memory layout range
        min_addr = min(seg['p_vaddr'] for seg in segments)
        max_addr = max(seg['p_vaddr'] + seg['p_memsz'] for seg in segments)
        mem_size = max_addr - min_addr

        print(f"Creating memory image from 0x{min_addr:08X} to 0x{max_addr:08X} ({mem_size} bytes)")

        # Allocate flat memory image, zero-initialized
        memory = bytearray(mem_size)

        # Load each segment into memory image
        for seg in segments:
            vaddr = seg['p_vaddr']
            offset = seg['p_offset']
            filesz = seg['p_filesz']
            memsz = seg['p_memsz']

            load_addr = vaddr - min_addr  # where to place in memory image

            f.seek(offset)
            data = f.read(filesz)

            memory[load_addr:load_addr+filesz] = data

            if memsz > filesz:
                # Zero-fill the rest (e.g., .bss)
                memory[load_addr+filesz:load_addr+memsz] = b'\x00' * (memsz - filesz)

        return min_addr, memory, elf['e_entry']

def encode_i_type(opcode, rs, rt, immediate):
    return (opcode << 26) | (rs << 21) | (rt << 16) | (immediate & 0xFFFF)

def encode_r_type(opcode, rs, rt, rd, shamt, funct):
    return (opcode << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (shamt << 6) | funct

def encode_lui(rt, immediate):
    return (encode_i_type(0b001111, 0, rt, immediate), f"lui ${rt}, 0x{immediate:04X}")

def encode_ori(rs, rt, immediate):
    return (encode_i_type(0b001101, rs, rt, immediate), f"ori ${rt}, ${rs}, 0x{immediate:04X}")

def set_register_32bit(register, value):
    upper = (value >> 16) & 0xFFFF
    lower = value & 0xFFFF

    instructions = []
    instructions.append(encode_lui(register, upper))             # lui $reg, upper
    instructions.append(encode_ori(register, register, lower))   # ori $reg, $reg, lower

    return instructions

def encode_jump(target_address):
    """
    Encodes a MIPS 'j' instruction (opcode 0x02) for the given target address.
    
    Args:
        target_address (int): The absolute byte address to jump to (must be 4-byte aligned).
        
    Returns:
        int: 32-bit machine instruction encoding the jump.
    """
    if target_address % 4 != 0:
        raise ValueError("MIPS jump address must be 4-byte aligned.")

    opcode = 0x02
    instr_index = (target_address >> 2) & 0x03FFFFFF  # Keep only 26 bits
    instruction = (opcode << 26) | instr_index
    return [(instruction, f"j 0x{target_address:08X}")]

def encode_nop():
    return [(0x00000000, "sll $0, $0, 0")]  # NOP is encoded as SLL $0, $0, 0

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--elf", type=str, help="[input] path to elf file", required=True)
    parser.add_argument("--image", type=str, help="[output] path to output memory image", required=True)
    args = parser.parse_args()

    base, mem, entry = load_elf_to_memory_image(args.elf)
    print(Fore.WHITE + "Base address: " + Fore.BLUE + f"0x{base:08X}")
    print(Fore.WHITE + "Entry point:  " + Fore.GREEN + f"0x{entry:08X}")
    print(Fore.WHITE + "Image length: " + Fore.RED + f"0x{len(mem):08X}")
    print(Style.RESET_ALL)

    with open(args.image, 'wb') as f:
        f.write(mem)
