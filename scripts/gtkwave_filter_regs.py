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

            register_map = {
                "00": "$zero",
                "01": "$at",
                "02": "$v0",
                "03": "$v1",
                "04": "$a0",
                "05": "$a1",
                "06": "$a2",
                "07": "$a3",
                "08": "$t0",
                "09": "$t1",
                "0a": "$t2",
                "0b": "$t3",
                "0c": "$t4",
                "0d": "$t5",
                "0e": "$t6",
                "0f": "$t7",
                "10": "$s0",
                "11": "$s1",
                "12": "$s2",
                "13": "$s3",
                "14": "$s4",
                "15": "$s5",
                "16": "$s6",
                "17": "$s7",
                "18": "$t8",
                "19": "$t9",
                "1a": "$k0",
                "1b": "$k1",
                "1c": "$gp",
                "1d": "$sp",
                "1e": "$fp",
                "1f": "$ra"
            }

            if l in register_map:
                sys.stdout.write(f"{register_map[l]}\n")
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