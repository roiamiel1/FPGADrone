#define P_UART_CHAR ((char*) 1000)
#define P_UART_START ((char*) 1001)
#define P_UART_DONE ((char*) 1002)
#define P_UART_BUSY ((char*) 1003)

#define UART_PUTC(C)            \
    while(*P_UART_BUSY != 0);   \
    *P_UART_CHAR = C;           \
    *P_UART_START = 1; \
    while (*P_UART_DONE == 0);  \
    *P_UART_START = 0;

void main() {
    /*
    *((char*) 1) = 'e';
    *((char*) 2) = 'l';
    *((char*) 3) = 'l';
    *((char*) 4) = 'o';
    *((char*) 5) = '!';
    *((char*) 6) = ' ';
    */

    while (1) {
        *((char*) 0) = 'K';
        UART_PUTC(*((char*) 0));
        UART_PUTC(*((char*) 1));
        UART_PUTC(*((char*) 2));
        UART_PUTC(*((char*) 3));
        UART_PUTC(*((char*) 4));
        UART_PUTC(*((char*) 5));
        UART_PUTC(*((char*) 6));
    }
    return;
}