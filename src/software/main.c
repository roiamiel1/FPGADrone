#define P_UART_CHAR ((char*) 1000)
#define P_UART_START ((char*) 1001)
#define P_UART_DONE ((char*) 1002)
#define P_UART_BUSY ((char*) 1003)

#define UART_PUTC(C)            \
    while(*P_UART_BUSY != 0);   \
    *P_UART_CHAR = (const char) (C);    \
    *P_UART_START = 1;          \
    while (*P_UART_DONE == 0);  \
    *P_UART_START = 0;

__attribute__((section(".text")))
void main() {
    const char* msg = "0123012301230123012301230123012301230123012301230123012301230123";

    while (1) {
        UART_PUTC('A');
        UART_PUTC(msg[0]);
        UART_PUTC(msg[1]);
        UART_PUTC(msg[2]);
        UART_PUTC(msg[3]);
        UART_PUTC(msg[4]);
        UART_PUTC(msg[5]);
        UART_PUTC(msg[6]);
        UART_PUTC(msg[7]);
        UART_PUTC(msg[8]);
        UART_PUTC(msg[9]);
        UART_PUTC(msg[10]);
        UART_PUTC(msg[11]);
        UART_PUTC('Z');
    }
    return;
}