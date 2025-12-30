ENTRY(main)

_stack_top = 0x3ff0;

SECTIONS {
  . = 0x00000000;

  .text : {
    KEEP(*(.text))
  }

  /* zero buffer between code and data section, so that no data will leak as `invalid instruction` in case of debugging */
  .zero_pad (NOLOAD) : {
      . = ALIGN(4);
      . += 32;
  }

  .data : {
    *(.data)
  }

  .rodata : {
    *(.rodata)
  }

  .bss : {
    *(.bss COMMON)
  }
}
