ENTRY(main)

_stack_top = 0x3fff;

SECTIONS {
  . = 0x00000000;

  .text : {
    KEEP(*(.text))
  }

  .data : {
    *(.data)
  }

  .bss : {
    *(.bss COMMON)
  }
}
