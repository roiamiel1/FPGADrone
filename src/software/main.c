#define P_UART_CHAR ((char*) 1000)
#define P_UART_START ((char*) 1001)
#define P_UART_DONE ((char*) 1002)
#define P_UART_BUSY ((char*) 1003)

#define UART_PUTC(C)            \
    while(*P_UART_BUSY != 0);   \
    *P_UART_CHAR = C;           \
    *P_UART_START = 1;          \
    while (*P_UART_DONE == 0);  \
    *P_UART_START = 0;

void main() {
    while (1) {
        UART_PUTC('H');
        UART_PUTC('e');
        UART_PUTC('l');
        UART_PUTC('l');
        UART_PUTC('o');
        UART_PUTC('!');
        UART_PUTC(' ');
    }
    return;
}