# ----------------------------------------------
HARDWARE_TOP_MODULE = MIPS_R2000
HARDWARE_TESTBENCH = MIPS_R2000_tb
HARDWARE_SRCS := $(shell find ./src/hardware -type f -name \*.v -exec basename {} \;)

# ----------------------------------------------


build-cpu:
	docker run --rm -it -w /project -v ./:/project gowin_builder gw_sh ./Makefile.tcl

build-mips:
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-gcc -mfp32 -march=R2000 -static -nostdlib src/main.c -o bin/main.out
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-gcc -S -mfp32 -march=R2000 -static -nostdlib src/main.c -o bin/main.asm

build-shellcode:
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-objcopy --dump-section .text=bin/main.shellcode bin/main.out

load:
	openFPGALoader -b tangnano9k -m impl/pnr/project.fs

docker-cpu:
	docker build -t gowin_builder ./cpu

docker-mips:
	docker build -t mips_compiler ./src

docker:
	make docker-cpu
	make docker-mips

rom32:
	python3 scripts/shellcode_to_rom32.py

run:
	make build
	make load

simulate:
	cd ./src/hardware; iverilog -g2001 -Wall -o ../../bin/hardware/$(HARDWARE_TESTBENCH).vvp $(HARDWARE_SRCS) ../../tests/hardware/$(HARDWARE_TESTBENCH).v
	cd ./bin/hardware; vvp $(HARDWARE_TESTBENCH).vvp | tee $(HARDWARE_TESTBENCH)_log.txt 1>/dev/null

gtkwave: simulate
	gtkwave ./bin/hardware/$(HARDWARE_TESTBENCH).vcd





lint:
	verilator -g2001 -Wall --lint-only $(SRCS) $(HARDWARE_TESTBENCH).v

clean:
	rm -rf $(TESTBENCH).vvp $(TESTBENCH).vcd $(TESTBENCH)_log.txt
