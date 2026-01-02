#define P_UART_CHAR  ((unsigned char*) 0xFFFFFFFF)
#define P_UART_START ((unsigned char*) 0xFFFFFFFE)
#define P_UART_DONE  ((unsigned char*) 0xFFFFFFFD)
#define P_UART_BUSY  ((unsigned char*) 0xFFFFFFFC)
#define P_ESC1_SPEED ((unsigned int*)  0xFFFFFFFB)

#define SET_ESC1_SPEED(S)                   \
    do {                                    \
        *P_ESC1_SPEED = (unsigned int) (S); \
    } while (0)

#define GET_ESC1_SPEED() (*P_ESC1_SPEED)

#define UART_PUTC(C)                        \
    do {                                    \
        *P_UART_START = 0;                  \
        while((*P_UART_BUSY) != 0) {}       \
        *P_UART_CHAR = (unsigned char) (C); \
        *P_UART_START = 1;                  \
        while ((*P_UART_DONE) == 0) {}      \
        *P_UART_START = 0;                  \
        while((*P_UART_BUSY) != 0) {}       \
        while ((*P_UART_DONE) != 0) {}      \
    } while (0)


int printf(const char *restrict fmt, ...) {
	int ret;
	va_list ap;
	va_start(ap, fmt);
	ret = vfprintf(stdout, fmt, ap);
	va_end(ap);
	return ret;
}


__attribute__((section(".text")))
void main() {
    char msg[] = "hello my name is roi"; 

    while (1) {
        SET_ESC1_SPEED(800);
        
        UART_PUTC(func(msg, sizeof(msg) - 1));
    }

    return;
}