ENTRY(main)

_stack_top = 0x3ff0;

SECTIONS {
  . = 0x00000000;

  .text : {
    KEEP(*(.text))
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
