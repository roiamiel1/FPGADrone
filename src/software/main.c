#define P_UART_CHAR  ((unsigned char*) 1000)
#define P_UART_START ((unsigned char*) 1001)
#define P_UART_DONE  ((unsigned char*) 1002)
#define P_UART_BUSY  ((unsigned char*) 1003)

#define UART_PUTC(C)                        \
    do {                                    \   
        while((*P_UART_BUSY) != 0) {}       \
        *P_UART_CHAR = (unsigned char) (C); \
        *P_UART_START = 1;                  \
        while ((*P_UART_DONE) != 1) {}      \
        *P_UART_START = 0;                  \   
        while((*P_UART_BUSY) != 0) {}       \  
    } while (0)

__attribute__((section(".text")))
void main() {
    char* msg = "abcdefghijklmnopqrstuvwxyz"; 
    for (unsigned int i = 0; i < 26; i++) {
        UART_PUTC(msg[i]);
        msg[i + 1] = 'A' + i;
    }
    /*
    // while (1) {
    UART_PUTC('0');
    for (unsigned int i = 'A'; i < 'Z'; i++) {
        UART_PUTC(i);
    }
    UART_PUTC('1');
    // }
    */
    return;
}