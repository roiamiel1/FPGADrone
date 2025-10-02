# ------------------------- Settings ------------------------- #

PROJECT_NAME := drone
HW_BOARD_NAME := tangnano20k

# ------------------------- Paths ------------------------- #
SRC_PATH := ./src
BUILD_PATH := ./build
IMPL_PATH := ./impl
TESTS_PATH := ./tests

SRC_SW_PATH := $(SRC_PATH)/software
SRC_HW_PATH := $(SRC_PATH)/hardware

BUILD_SW_PATH := $(BUILD_PATH)/software
BUILD_HW_PATH := $(BUILD_PATH)/hardware

TESTS_SW_PATH := $(TESTS_PATH)/software
TESTS_HW_PATH := $(TESTS_PATH)/hardware

BUILD_SW_TEST_PATH := $(BUILD_SW_PATH)/tests
BUILD_HW_TEST_PATH := $(BUILD_HW_PATH)/tests

# Src files
SW_SRCS_C := $(shell find $(SRC_SW_PATH) -type f -name *.c)
SW_SRCS_ASM := $(shell find $(SRC_SW_PATH) -type f -name *.asm)
HW_SRCS := $(shell find $(SRC_HW_PATH) -type f -name "*.v" | sed "s|^$(SRC_HW_PATH)/||")

# SW Paths
SW_BINARY_PATH := $(BUILD_SW_PATH)/build.out
SW_IMAGE_PATH := $(BUILD_SW_PATH)/image.out
SW_SHELLCODE_PATH := $(BUILD_SW_PATH)/build.shellcode
SW_HEX_PATH := $(BUILD_SW_PATH)/build.hex
SW_SHELLCODE_TEXT_PATH := $(SW_SHELLCODE_PATH).text
SW_READELF_TEXT_PATH := $(BUILD_SW_PATH)/build.readelf.text

# HW Paths
HW_IMPL_PATH := $(BUILD_HW_PATH)/impl
HW_MAKEFILE_PATH := ./scripts/Makefile.tcl
SRC_HW_PATH_BACKWARDS := $(shell ARG=$(SRC_HW_PATH) echo ".$$(printf '/..%.0s' $$(seq 1 $$(echo "$${ARG\#./}" | awk -F'/' '{print NF}')))")

# ------------------------- Programs ------------------------- #

CAT = $(shell which cat)
XXD = $(shell which xxd)
RM = $(shell which rm)
DOCKER = $(shell which docker)
VVP = $(shell which vvp)
PYTHON := $(shell which python3 || which python)
OPEN_FPGA_LOADER := $(shell which openFPGALoader) -b $(HW_BOARD_NAME)
IVERILOG = $(shell which iverilog)

RUN_IN_DOCKER = $(DOCKER) run --rm -it -w /$(PROJECT_NAME) -v ./:/$(PROJECT_NAME):delegated
MIPS_COMPILER_RUN = $(RUN_IN_DOCKER) mips_compiler
GOWIN_BUILDER_RUN = $(RUN_IN_DOCKER) -v $(HW_IMPL_PATH):/$(PROJECT_NAME)/impl:delegated gowin_builder
MIPS_AS = $(MIPS_COMPILER_RUN) mips-linux-gnu-as -mips1 -march=r2000 -O0
MIPS_OBJCOPY = $(MIPS_COMPILER_RUN) mips-linux-gnu-objcopy
MIPS_OBJDUMP = $(MIPS_COMPILER_RUN) mips-linux-gnu-objdump
MIPS_READELF = $(MIPS_COMPILER_RUN) mips-linux-gnu-readelf
MIPS_GCC = $(MIPS_COMPILER_RUN) mips-linux-gnu-gcc -mfp32 -march=r2000 -mno-shared -static -nostdlib -fno-builtin -nostartfiles -nodefaultlibs -ffreestanding -nostdlib -fno-builtin -fno-builtin-memcpy -O0

RM_ALL = $(RM) -rf
GW_SH := $(GOWIN_BUILDER_RUN) gw_sh

# validations
PYTHON_VERSION := $(shell $(PYTHON) -c "import sys; print(sys.version_info.major)")

ifneq ($(PYTHON_VERSION), 3)
	$(error Python 3 is required. Current version: $(PYTHON_VERSION))
endif

# ------------------------- Software ------------------------- #

sw-build:
	$(MIPS_OBJCOPY) --dump-section .text=$(SW_SHELLCODE_PATH) $(SW_BINARY_PATH)
	$(MIPS_OBJDUMP) -d -M no-aliases $(SW_BINARY_PATH) > $(SW_SHELLCODE_TEXT_PATH)
	$(XXD) -c 4 -p $(SW_SHELLCODE_PATH) > $(SW_HEX_PATH)
	dd if=/dev/zero bs=4 count=30 of=$(BUILD_SW_PATH)/padding.bin
	cat $(BUILD_SW_PATH)/padding.bin $(SW_SHELLCODE_PATH) > $(SW_SHELLCODE_PATH).tmp
	mv $(SW_SHELLCODE_PATH).tmp $(SW_SHELLCODE_PATH)

sw-build-asm:
	$(MIPS_AS) -o $(SW_BINARY_PATH) $(SW_SRCS_ASM)
	make sw-build

sw-build-c:
	mkdir -p $(BUILD_SW_PATH)
	$(MIPS_GCC) -g -o $(SW_BINARY_PATH).o -ffreestanding -ffunction-sections -c $(SW_SRCS_C)
	$(MIPS_GCC) -T ./scripts/linker.ld -Wl,--nmagic -o $(SW_BINARY_PATH) -Wl,-Map=$(SW_BINARY_PATH).map $(SW_BINARY_PATH).o
	$(MIPS_READELF) --all $(SW_BINARY_PATH) > $(SW_READELF_TEXT_PATH)

elf : sw-build-c
	$(PYTHON) scripts/offline_elf_loader.py --elf $(SW_BINARY_PATH) --image $(SW_IMAGE_PATH)
	$(MIPS_OBJDUMP) -S -d $(SW_BINARY_PATH) > $(SW_SHELLCODE_TEXT_PATH)


sw-burn : elf
	dd if=$(SW_IMAGE_PATH) of=/dev/disk2 oflag=sync

# ------------------------- Hardware ------------------------- #

hw-build:
	$(GW_SH) $(HW_MAKEFILE_PATH)

hw-write-mem:
	$(OPEN_FPGA_LOADER) -m $(HW_IMPL_PATH)/pnr/drone.fs

hw-write-flash:
	$(OPEN_FPGA_LOADER) -f $(HW_IMPL_PATH)/pnr/drone.fs

hw-gen-mips-control:
	$(PYTHON) scripts/generate_control_from_mips32is.py

hw-gen-rom32:
	$(PYTHON) scripts/shellcode_to_rom32.py

hw-run-test:
# Run the test
	cd $(SRC_HW_PATH); $(IVERILOG) -DDEBUG=1 -g2001 -Wall -o $(SRC_HW_PATH_BACKWARDS)/$(BUILD_PATH)/test.vvp $(HW_SRCS) $(shell cd $(SRC_HW_PATH); find $(SRC_HW_PATH_BACKWARDS)/$(TEST_PATH) -type f -name "*.v") 
	$(VVP) $(BUILD_PATH)/test.vvp | tee $(BUILD_PATH)/test.log

# Run gtkwave
    ifneq ($(GTK),)
		gtkwave $(BUILD_PATH)/test.vcd
    endif

hw-test-instruction-set:
	$(eval BUILD_PATH := $(BUILD_HW_TEST_PATH)/instruction_set_test)
	$(eval TEST_PATH := $(TESTS_HW_PATH)/instruction_set_test)
	mkdir -p $(BUILD_PATH)

	# Build tb.v and test.asm 
	$(PYTHON) ./scripts/generate_test.py										\
		--insts=$(TESTS_HW_PATH)/instruction_set_test/instruction_set_test.py 	\
		--tb=$(BUILD_PATH)/tb.v 												\
		--asm=$(BUILD_PATH)/test.asm											\
		--hex=$(BUILD_PATH)/test.hex											\
		--test-out-path=$(BUILD_PATH)

	# Compile output test.asm to test.hex
	$(MIPS_AS) -o $(BUILD_PATH)/test.out $(BUILD_PATH)/test.asm
	$(MIPS_OBJCOPY) --dump-section .text=$(BUILD_PATH)/test.shellcode $(BUILD_PATH)/test.out
	$(MIPS_OBJDUMP) -d -M no-aliases $(BUILD_PATH)/test.out > $(BUILD_PATH)/test.text
	$(XXD) -c 4 -p $(BUILD_PATH)/test.shellcode > $(BUILD_PATH)/test.hex

	make hw-run-test BUILD_PATH=$(BUILD_PATH) TEST_PATH=$(BUILD_PATH)
		
hw-test-uart:
	$(eval BUILD_PATH := $(BUILD_HW_TEST_PATH)/uart_test)
	$(eval TEST_PATH := $(TESTS_HW_PATH)/uart_test)
	mkdir -p $(BUILD_PATH)

# Compile test.c to test.hex
	$(MIPS_GCC) -o $(BUILD_PATH)/test.out ./tests/hardware/uart_test/test.c
	$(MIPS_OBJCOPY) --dump-section .text=$(BUILD_PATH)/test.shellcode $(BUILD_PATH)/test.out
	$(MIPS_OBJDUMP) -d -M no-aliases $(BUILD_PATH)/test.out > $(BUILD_PATH)/test.text
	$(XXD) -c 4 -p $(BUILD_PATH)/test.shellcode > $(BUILD_PATH)/test.hex

	make hw-run-test BUILD_PATH=$(BUILD_PATH) TEST_PATH=$(TEST_PATH)

hw-software-rom:
	$(PYTHON) scripts/generate_rom_switch_case.py $(SW_IMAGE_PATH)

hw-run-startup-test:
	$(eval BUILD_PATH := $(BUILD_HW_TEST_PATH)/startup_test)
	$(eval TEST_PATH := $(TESTS_HW_PATH)/startup_test)

	mkdir -p $(BUILD_PATH)

	make hw-run-test BUILD_PATH=$(BUILD_PATH) TEST_PATH=$(TEST_PATH)

lint:
	verilator -g2001 -Wall --lint-only $(SRCS) $(HARDWARE_TESTBENCH).v

clean:
	$(RM_ALL) $(BUILD_PATH) $(IMPL_PATH)

