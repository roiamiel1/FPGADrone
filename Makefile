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