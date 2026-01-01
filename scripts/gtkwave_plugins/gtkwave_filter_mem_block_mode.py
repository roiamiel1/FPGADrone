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
            
            if l == "00":
                sys.stdout.write("Word\n")
                sys.stdout.flush()
                continue
            elif l == "01":
                sys.stdout.write("Halfword\n")
                sys.stdout.flush()
                continue
            elif l == "10":
                sys.stdout.write("Byte\n")
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