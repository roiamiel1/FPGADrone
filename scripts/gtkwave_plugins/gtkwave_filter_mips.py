#!/usr/bin/env python3
import sys
import select
import subprocess

container_name = "mips_build"
image_name = "mips_compiler"
docker_command_prefix = ["docker", "exec", container_name]

def is_container_running(container_name):
    """Return True if the container is running."""
    result = subprocess.run(
        ["docker", "ps", "-q", "-f", f"name={container_name}"],
        capture_output=True,
        text=True
    )
    return bool(result.stdout.strip())

def start_container_if_needed(container_name, image, command="/bin/bash"):
    """Start the container if it is not running."""
    if is_container_running(container_name):
        pass
    else:
        subprocess.run(
            ["docker", "run", "-dit", "--name", container_name, image, command],
            check=True
        )

def main():
    cache = {}

    start_container_if_needed(container_name, image_name)

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

            if l == "00000000":
                sys.stdout.write("nop\n")
                sys.stdout.flush()
                continue

            if l in cache:
                sys.stdout.write("%s\n" % cache[l])
                sys.stdout.flush()
                continue

            result = subprocess.run(docker_command_prefix + ["/bin/bash", "-c", f"""
                                                    echo ".word 0x{str(l)}" > /tmp/mips_opcode 2>/dev/null;
                                                    mips-linux-gnu-as -mips1 -march=r2000 -o /tmp/mips_opcode_out /tmp/mips_opcode 2>&1 >/dev/null;
                                                    mips-linux-gnu-objdump -d /tmp/mips_opcode_out 2>/dev/null | grep "{str(l)}";
                                                    """], capture_output=True)
            lastline = result.stdout.splitlines()[0]
            chunks = lastline.decode().split('\t')

            opcodes = " ".join(chunks[2:])
        
            cache[l] = opcodes

            sys.stdout.write("%s\n" % opcodes)
            sys.stdout.flush()
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