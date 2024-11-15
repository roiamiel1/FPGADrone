# ----------------------------------------------
HARDWARE_TOP_MODULE = MIPS_R2000
HARDWARE_TESTBENCH = MIPS_R2000_tb
HARDWARE_SRCS := $(shell find ./src/hardware -type f -name \*.v -exec basename {} \;)

# ----------------------------------------------

build-cpu:
	docker run --rm -it -w /project -v ./:/project gowin_builder gw_sh ./Makefile.tcl

build-asm-test:
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-as -mips1 -march=r2000 -O0 -o tests/hardware/asm/MIPS_R2000_tb.out tests/hardware/asm/MIPS_R2000_tb.asm
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-objcopy --dump-section .text=tests/hardware/asm/MIPS_R2000_tb.shellcode tests/hardware/asm/MIPS_R2000_tb.out
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-objdump -d -M no-aliases tests/hardware/asm/MIPS_R2000_tb.out > tests/hardware/asm/MIPS_R2000_tb.text
	xxd -c 4 -p tests/hardware/asm/MIPS_R2000_tb.shellcode > tests/hardware/asm/MIPS_R2000_tb.hex

build-mips:
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-gcc -mfp32 -mips1 -static -nostdlib src/software/main.c -o bin/software/main.out
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-gcc -S -mfp32 -mips1 -static -nostdlib src/software/main.c -o bin/software/main.asm
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-objcopy --dump-section .text=bin/software/main.shellcode bin/software/main.out
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-objdump -d -M no-aliases bin/software/main.out > bin/software/main.shellcode.text

build-shellcode:
	docker run --rm -it -w /project -v ./:/project mips_compiler mips-linux-gnu-objcopy --dump-section .text=bin/software/main.shellcode bin/software/main.out
	xxd -c 4 -p bin/software/main.shellcode > bin/software/main.hex

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

clean_simulate:
	rm -f tests/hardware/MIPS_R2000_tb.v
	rm -f tests/hardware/asm/MIPS_R2000_tb.asm
	rm -f tests/hardware/asm/MIPS_R2000_tb.hex
	rm -f tests/hardware/asm/MIPS_R2000_tb.out
	rm -f tests/hardware/asm/MIPS_R2000_tb.shellcode
	rm -f tests/hardware/asm/MIPS_R2000_tb.text
	rm -f bin/hardware/MIPS_R2000_tb_log.txt
	rm -f bin/hardware/MIPS_R2000_tb.vcd
	rm -f bin/hardware/MIPS_R2000_tb.vvp

simulate: clean_simulate
	python3 ./tests/hardware/generate_asm_tb.py
	make build-asm-test
	cd ./src/hardware; iverilog -g2001 -Wall -o ../../bin/hardware/$(HARDWARE_TESTBENCH).vvp $(HARDWARE_SRCS) ../../tests/hardware/$(HARDWARE_TESTBENCH).v
	cd ./bin/hardware; vvp $(HARDWARE_TESTBENCH).vvp | tee $(HARDWARE_TESTBENCH)_log.txt

gtkwave: simulate
	gtkwave ./bin/hardware/$(HARDWARE_TESTBENCH).vcd

lint:
	verilator -g2001 -Wall --lint-only $(SRCS) $(HARDWARE_TESTBENCH).v

clean:
	rm -rf $(TESTBENCH).vvp $(TESTBENCH).vcd $(TESTBENCH)_log.txt
