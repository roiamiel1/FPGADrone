#define P_UART_CHAR  ((unsigned char*) 0xFFFFFFFF)
#define P_UART_START ((unsigned char*) 0xFFFFFFFE)
#define P_UART_DONE  ((unsigned char*) 0xFFFFFFFD)
#define P_UART_BUSY  ((unsigned char*) 0xFFFFFFFC)

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

static int make_upper = 1;

char recursive_func(int index) {
    if (index <= 0) {
        return '!';
    } else {
        return recursive_func(index - 1);
    }
}

char func(char* msg, unsigned int len) {
    for (unsigned int i = 0; i < len && make_upper; i++) {
        if (msg[i] == ' ' || msg[i] == '\n') {
            continue;
        }

        msg[i] += ('A' - 'a');
    }

    for (unsigned int i = 0; i < len; i++) {
        UART_PUTC(msg[i]);
    }

    for (unsigned int i = 0; i < len && make_upper; i++) {
        if (msg[i] == ' ' || msg[i] == '\n') {
            continue;
        }

        msg[i] -= ('A' - 'a');
    }

    if (make_upper == 0) {
        make_upper = 1;
    } else {
        make_upper = 0;
    }

    UART_PUTC(recursive_func(5));
    UART_PUTC('\r');

    return '\n';
}

__attribute__((section(".text")))
void main() {
    char msg[] = "hello my name is roi"; 

    while (1) {        
        UART_PUTC(func(msg, sizeof(msg) - 1));
    }

    return;
}