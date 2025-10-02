ENTRY(main)

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
