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

// There is a problem in the simulation, that every time we check `i` value in the for loop, it returns 60 for some reason.
// This is why we wont enter the for loop.
// I think the problem is related to memory read or write, something about the timing with the clk or sample rate is wrong.

__attribute__((section(".text")))
void main() {
    const char* msg = "0123012301230123012301230123012301230123012301230123012301230123";

    while (1) {
        UART_PUTC('Q');
        for (char i = 0; i < 5; i++) {
            UART_PUTC('A' + i);
        }
    }
    return;
}