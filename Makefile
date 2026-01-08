# ------------------------- Settings ------------------------- #

PROJECT_NAME := drone
HW_BOARD_NAME := tangnano20k

# ------------------------- Paths ------------------------- #
SRC_PATH := ./src
BUILD_PATH := ./build
IMPL_PATH := ./impl
LIBS_PATH := ./libs
RESOURCES_PATH := ./resources
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
SW_OBJ_FILES := $(patsubst $(SRC_SW_PATH)/%.c,$(BUILD_SW_PATH)/%.o,$(SW_SRCS_C))

# SW Paths
SW_BINARY_PATH := $(BUILD_SW_PATH)/build.out
SW_IMAGE_PATH := $(BUILD_SW_PATH)/image.out
SW_SHELLCODE_PATH := $(BUILD_SW_PATH)/build.shellcode
SW_HEX_PATH := $(BUILD_SW_PATH)/build.hex
SW_SHELLCODE_TEXT_PATH := $(SW_SHELLCODE_PATH).text
SW_READELF_TEXT_PATH := $(BUILD_SW_PATH)/build.readelf.text
SW_PICOLIBC_PATH := $(LIBS_PATH)/picolibc

# HW Paths
HW_SRCS := $(shell find $(SRC_HW_PATH) -type f -name "*.v" | sed "s|^$(SRC_HW_PATH)/||")
HW_IMPL_PATH := $(BUILD_HW_PATH)/impl
HW_MAKEFILE_PATH := ./scripts/Makefile.tcl
SRC_HW_PATH_BACKWARDS := $(shell ARG=$(SRC_HW_PATH) echo ".$$(printf '/..%.0s' $$(seq 1 $$(echo "$${ARG\#./}" | awk -F'/' '{print NF}')))")

# -------------------------- Utils --------------------------- #

define meson_split_array
['$(shell printf "%s\n" "$(1)" | tr -s ' ' | sed "s/^ *//; s/ *$$//; s/ /', '/g")']
endef

build_docker:
	$(DOCKER) build -t mips_compiler -f $(RESOURCES_PATH)/dockers/Dockerfile.gcc .
	$(DOCKER) build -t gowin_builder -f $(RESOURCES_PATH)/dockers/Dockerfile.gowin .
	$(DOCKER) build -t picolibc_compiler -f $(RESOURCES_PATH)/dockers/Dockerfile.picolibc .

# ------------------------- Programs ------------------------- #

CAT = $(shell which cat)
XXD = $(shell which xxd)
RM = $(shell which rm)
TAR = $(shell which tar)
GIT = $(shell which git)
MKDIR = $(shell which mkdir)
PATCH = $(shell which patch)
DOCKER = $(shell which docker)
VVP = $(shell which vvp)
PYTHON := $(shell which python3 || which python)
OPEN_FPGA_LOADER := $(shell which openFPGALoader) -b $(HW_BOARD_NAME)
IVERILOG = $(shell which iverilog)

RUN_IN_DOCKER = $(DOCKER) run --rm -it -w /source -v ./:/source:delegated
MIPS_COMPILER_RUN = $(RUN_IN_DOCKER) mips_compiler
GOWIN_BUILDER_RUN = $(RUN_IN_DOCKER) -v $(HW_IMPL_PATH):/source/impl:delegated gowin_builder
PICOLIBC_COMPILER_RUN = $(RUN_IN_DOCKER) picolibc_compiler
TOOLCHAIN = mips-linux-gnu-
OBJCOPY = $(MIPS_COMPILER_RUN) $(TOOLCHAIN)objcopy
OBJDUMP = $(MIPS_COMPILER_RUN) $(TOOLCHAIN)objdump
READELF = $(MIPS_COMPILER_RUN) $(TOOLCHAIN)readelf
CC = $(MIPS_COMPILER_RUN) $(TOOLCHAIN)gcc
AS = $(MIPS_COMPILER_RUN) $(TOOLCHAIN)as
AR = $(MIPS_COMPILER_RUN) $(TOOLCHAIN)ar
LD = $(MIPS_COMPILER_RUN) $(TOOLCHAIN)ld
STRIP = $(MIPS_COMPILER_RUN) $(TOOLCHAIN)strip

RM_ALL = $(RM) -rf
GW_SH := $(GOWIN_BUILDER_RUN) gw_sh

# validations
PYTHON_VERSION := $(shell $(PYTHON) -c "import sys; print(sys.version_info.major)")

ifneq ($(PYTHON_VERSION), 3)
	$(error Python 3 is required. Current version: $(PYTHON_VERSION))
endif

# ------------------------- Software ------------------------- #

CFLAGS := -mfp32 -march=r2000 -mno-shared -static -ffunction-sections -static-libgcc -O0
LDFLAGS := -Wl,-Map=$(SW_BINARY_PATH).map -static-libgcc
ASFLAGS := -mips1 -march=r2000 -O0

$(BUILD_SW_PATH):
	-$(MKDIR) -p $(BUILD_SW_PATH)

# Generic file compiler
$(BUILD_SW_PATH)/%.o: $(SRC_SW_PATH)/%.c | $(BUILD_SW_PATH)
	$(CC) $(CFLAGS) -c -o $@ $<

# Linker
sw-build: $(SW_OBJ_FILES)
	$(CC) $(LDFLAGS) -o $@ $^

sw-build-2:
	$(OBJCOPY) --dump-section .text=$(SW_SHELLCODE_PATH) $(SW_BINARY_PATH)
	$(OBJDUMP) -d -M no-aliases $(SW_BINARY_PATH) > $(SW_SHELLCODE_TEXT_PATH)
	$(XXD) -c 4 -p $(SW_SHELLCODE_PATH) > $(SW_HEX_PATH)
	dd if=/dev/zero bs=4 count=30 of=$(BUILD_SW_PATH)/padding.bin
	cat $(BUILD_SW_PATH)/padding.bin $(SW_SHELLCODE_PATH) > $(SW_SHELLCODE_PATH).tmp
	mv $(SW_SHELLCODE_PATH).tmp $(SW_SHELLCODE_PATH)

sw-build-c:
	mkdir -p $(BUILD_SW_PATH)
	$(CC) $(CFLAGS) -g -o $(SW_BINARY_PATH).o -c $(SW_SRCS_C)
	$(CC) $(LDFLAGS) -o $(SW_BINARY_PATH) $(SW_BINARY_PATH).o
	$(READELF) --all $(SW_BINARY_PATH) > $(SW_READELF_TEXT_PATH)

elf : sw-build-c
	$(PYTHON) scripts/offline_elf_loader.py --elf $(SW_BINARY_PATH) --image $(SW_IMAGE_PATH)
	$(OBJDUMP) -S -d $(SW_BINARY_PATH) > $(SW_SHELLCODE_TEXT_PATH)

sw-burn : elf
	dd if=$(SW_IMAGE_PATH) of=/dev/disk2 oflag=sync

sw-build-libc-clean:
	cd $(SW_PICOLIBC_PATH) && $(GIT) add -A && $(GIT) stash && $(GIT) reset --hard && $(RM_ALL) build build-mips

sw-build-libc: sw-build-libc-clean
	printf "%s\n" 										\
	"[binaries]"										\
	"c = '$(TOOLCHAIN)gcc'"								\
	"ar = '$(TOOLCHAIN)ar'"								\
	"as = '$(TOOLCHAIN)as'"								\
	"ld = '$(TOOLCHAIN)ld'"								\
	"strip = '$(TOOLCHAIN)strip'"						\
	"ranlib = '$(TOOLCHAIN)ranlib'"						\
	""													\
	"[host_machine]"									\
	"system = 'none'"									\
	"cpu_family = 'mips'"								\
	"cpu = 'r2000'"										\
	"endian = 'big'"									\
	""													\
	"[built-in options]"								\
	"c_args = $(call meson_split_array, $(CFLAGS))"		\
	> $(SW_PICOLIBC_PATH)/cross-mips.txt

	$(PICOLIBC_COMPILER_RUN) /bin/bash -c "				\
		cd $(SW_PICOLIBC_PATH) && 						\
		meson setup build-mips 							\
			--reconfigure 								\
			-Dmultilib=false 							\
			-Dsingle-thread=true 						\
			-Dprintf-aliases=false 						\
			-Dio-float-exact=false 						\
			-Datomic-ungetc=false 						\
			-Dfast-strcmp=false 						\
			-Dpicocrt=false 							\
			-Dpicocrt-enable-mmu=false 					\
			-Dpicocrt-lib=false 						\
			-Dinitfini-array=false 						\
			--cross-file cross-mips.txt &&				\
		ninja -C build-mips								\
	"

# ------------------------- Hardware ------------------------- #

hw-build:
	$(GW_SH) $(HW_MAKEFILE_PATH)

hw-write-mem:
	$(OPEN_FPGA_LOADER) -m $(HW_IMPL_PATH)/pnr/drone.fs

hw-write-flash:
	$(OPEN_FPGA_LOADER) -f $(HW_IMPL_PATH)/pnr/drone.fs

hw-gen-mips-control:
	$(PYTHON) scripts/generate_control_from_mips32is.py

hw-run-test:
	$(XXD) -p -c 2 $(IMAGE_PATH) > $(IMAGE_PATH).hex

	cd $(SRC_HW_PATH); $(IVERILOG) -DDEBUG=1 -g2012 -Wall -o $(SRC_HW_PATH_BACKWARDS)/$(BUILD_PATH)/test.vvp $(HW_SRCS) $(SRC_HW_PATH_BACKWARDS)/tests/hardware/common/sd_fake.v $(shell cd $(SRC_HW_PATH); find $(SRC_HW_PATH_BACKWARDS)/$(TEST_PATH) -type f -name "*.v")
	$(VVP) $(BUILD_PATH)/test.vvp +SDCARD_MEM_PATH=$(IMAGE_PATH).hex | tee $(BUILD_PATH)/test.log
ifneq ($(GTK),)
	TEST_BUILD_PATH=$(BUILD_PATH) make hw-view-wave
endif

hw-view-wave:
	gtkwave $(TEST_BUILD_PATH)/test.vcd scripts/gtkwave_conf.gtkw --dark -A --rcvar 'fontname_signals Monospace 18' --rcvar 'fontname_waves Monospace 18'

hw-test-instruction-set:
	$(eval BUILD_PATH := $(BUILD_HW_TEST_PATH)/instruction_set_test)
	$(eval TEST_PATH := $(TESTS_HW_PATH)/instruction_set_test)
	mkdir -p $(BUILD_PATH)

	# Build tb.v and test.asm 
	$(PYTHON) $(TESTS_HW_PATH)/instruction_set_test/scripts/generate_instructions_test.py	\
		--insts=$(TESTS_HW_PATH)/instruction_set_test/instruction_set_test.py 				\
		--tb=$(BUILD_PATH)/tb_test_code.v 													\
		--asm=$(BUILD_PATH)/test.asm														\
		--hex=$(BUILD_PATH)/test.hex														\
		--test-out-path=$(BUILD_PATH)

	# Compile output test.asm to test.hex
	$(AS) $(ASFLAGS) -o $(BUILD_PATH)/test.out $(BUILD_PATH)/test.asm
	$(OBJCOPY) --dump-section .text=$(BUILD_PATH)/test.shellcode $(BUILD_PATH)/test.out
	$(OBJDUMP) -d -M no-aliases $(BUILD_PATH)/test.out > $(BUILD_PATH)/test.shellcode.text

	mkdir -p build/hardware/tests/instruction_set_test

	make hw-run-test BUILD_PATH=$(BUILD_PATH) TEST_PATH=$(TEST_PATH) IMAGE_PATH=$(BUILD_PATH)/test.shellcode
		
hw-test-uart:
	$(eval BUILD_PATH := $(BUILD_HW_TEST_PATH)/uart_test)
	$(eval TEST_PATH := $(TESTS_HW_PATH)/uart_test)
	mkdir -p $(BUILD_PATH)

# Compile test.c to test.hex
	$(CC) $(CFLAGS) -o $(BUILD_PATH)/test.out ./tests/hardware/uart_test/test.c
	$(OBJCOPY) --dump-section .text=$(BUILD_PATH)/test.shellcode $(BUILD_PATH)/test.out
	$(OBJDUMP) -d -M no-aliases $(BUILD_PATH)/test.out > $(BUILD_PATH)/test.text

	make hw-run-test BUILD_PATH=$(BUILD_PATH) TEST_PATH=$(TEST_PATH) IMAGE_PATH=$(BUILD_PATH)/test.shellcode

hw-run-startup-test:
	$(eval BUILD_PATH := $(BUILD_HW_TEST_PATH)/startup_test)
	$(eval TEST_PATH := $(TESTS_HW_PATH)/startup_test)

	make elf
	
	mkdir -p $(BUILD_PATH)

	make hw-run-test BUILD_PATH=$(BUILD_PATH) TEST_PATH=$(TEST_PATH) IMAGE_PATH=$(SW_IMAGE_PATH)

lint:
	verilator -g2001 -Wall --lint-only $(SRCS) $(HARDWARE_TESTBENCH).v

clean:
	$(RM_ALL) $(BUILD_PATH) $(IMPL_PATH)

