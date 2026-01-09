ENTRY(main)

_stack_top = 0x3ff0;

SECTIONS {
    . = 0x0;
    .text : {
		KEEP(*(.main))
        KEEP(*(.text))
        KEEP(*(.text.*))
    }
	/* zero buffer between code and data section, so that no data will leak as `invalid instruction` in case of debugging 
	.zero_pad : {
		. += 32;
  	}
	*/
    .data : {
        KEEP(*(.data))
        KEEP(*(.data.*))
    }
    .rodata : {
        KEEP(*(.rodata))
        KEEP(*(.rodata.*))
    }
	/DISCARD/ : {
		*(.MIPS.abiflags)
		*(.comment)
		*(.gnu.attributes)
		*(.pdr)
		*(.note*)
	}
}
