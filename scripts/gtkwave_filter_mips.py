#!/usr/bin/env python3
import sys
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

    fh_in = sys.stdin
    fh_out = sys.stdout

    while True:
        try:
            start_container_if_needed(container_name, image_name)

            l = fh_in.readline().strip().lower()
            if not l:
                return 0

            if "x" in l:
                fh_out.write(l)
                fh_out.flush()
                continue
            
            sys.stderr.write("Processing opcode: %s\n" % str(l))

            if l in cache:
                fh_out.write("%s\n" % cache[l])
                fh_out.flush()
                continue

            result = subprocess.run(docker_command_prefix + ["/bin/bash", "-c", f"""
                                                    echo ".word 0x{str(l)}" > /tmp/mips_opcode 2>/dev/null;
                                                    mips-linux-gnu-as -mips1 -march=r2000 -o /tmp/mips_opcode_out /tmp/mips_opcode 2>&1 >/dev/null;
                                                    mips-linux-gnu-objdump -d /tmp/mips_opcode_out 2>/dev/null | grep "{str(l)}";
                                                    """], capture_output=True)
            sys.stderr.write("Stdout: %s\n" % str(result.stdout.decode()))
            sys.stderr.write("Stderr: %s\n" % str(result.stderr.decode()))
            lastline = result.stdout.splitlines()[0]
            chunks = lastline.decode().split('\t')

            opcodes = " ".join(chunks[2:])
        
            cache[l] = opcodes

            fh_out.write("%s\n" % opcodes)
            fh_out.flush()
        except Exception as e:
            sys.stderr.write("Error: %s\n" % str(e))
            fh_out.write("Unknown\n")
            fh_out.flush()



if __name__ == '__main__':
	sys.exit(main())