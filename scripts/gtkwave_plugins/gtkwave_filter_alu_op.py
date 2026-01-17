#!/usr/bin/env python3
import sys
import select
import subprocess

def main():
    try:
        while True:
            readable, _, _ = select.select([sys.stdin], [], [], 0.1)
            if not readable:
                continue

            l = sys.stdin.readline()
            if not l:
                raise EOFError()
            
            l = l.strip().lower()

            if "x" in l:
                sys.stdout.write("Undefined\n")
                sys.stdout.flush()
                continue

            alu_opcode_map = {
                "00": "ADD - A + B",
                "01": "SUB - A - B",
                "02": "MUL - A * B",
                "03": "DIV - A / B",
                "04": "SLL - A << 1",
                "05": "SRL - A >> 1",
                "06": "AND - A and B",
                "07": "OR - A or B",
                "08": "XOR - A xor B",
                "09": "NOR - A nor B",
                "0a": "NAND - A nand B",
                "0b": "XNOR - A xnor B",
                "0c": "SLT - 1 if A<B else 0",
                "0d": "LUI - 1 if A<B else 0",
                "0e": "IN1 - A",
                "0f": "SRA - A >> 1 (with sign extension)",
                "10": "MFHI - HI",
                "11": "MFLO - LO",
                "12": "MULTU - A * B (but unsigned)"
            }

            if l in alu_opcode_map:
                sys.stdout.write(f"{alu_opcode_map[l]}\n")
                sys.stdout.flush()
                continue
            else:
                sys.stdout.write("Unknown\n")
                sys.stdout.flush()
                continue    

    except Exception as e:
        try:
            sys.stdout.write("Unknown\n")
            sys.stdout.flush()
        except:
            pass
    except:
        try:
            sys.stdout.write("Unknown\n")
            sys.stdout.flush()
        except:
            pass


if __name__ == '__main__':
    main()
    sys.exit(0)