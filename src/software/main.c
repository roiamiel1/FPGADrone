// #include <stdio.h>

// #include <unistd.h>

/* Create actual FILE objects (storage) */
// FILE __stdin_struct;
// FILE __stdout_struct;
// FILE __stderr_struct;

/* Define the constant pointers to these objects */
// FILE* const stdin  = &__stdin_struct;
// FILE* const stdout = &__stdout_struct;
// FILE* const stderr = &__stderr_struct;

typedef unsigned int size_t;

#define P_UART_CHAR  ((unsigned char*) 0xFFFFFFFF)
#define P_UART_START ((unsigned char*) 0xFFFFFFFE)
#define P_UART_DONE  ((unsigned char*) 0xFFFFFFFD)
#define P_UART_BUSY  ((unsigned char*) 0xFFFFFFFC)
#define P_ESC0_SPEED ((unsigned int*)  0xFFFFFFFB)
#define P_ESC1_SPEED ((unsigned int*)  0xFFFFFFFA)
#define P_UPTIME_MS  ((unsigned int*)  0xFFFFFFEF)

void memcpy(void* dest, const void* src, size_t n) __attribute__((optimize("O0")));
void memcpy(void* dest, const void* src, size_t n) {
	unsigned char* d = (unsigned char*) dest;
	const unsigned char* s = (const unsigned char*) src;
	for (size_t i = 0; i < n; i++) {
		d[i] = s[i];
	}
}

void memset(void* dest, int val, size_t n) __attribute__((optimize("O0")));
void memset(void* dest, int val, size_t n) {
	unsigned char* d = (unsigned char*) dest;
	for (size_t i = 0; i < n; i++) {
		d[i] = (unsigned char) val;
	}
}

void esc_set_speed(const unsigned short index, const unsigned int speed) __attribute__((optimize("O0")));
void esc_set_speed(const unsigned short index, const unsigned int speed) {
	switch (index) {
		case 0:
			*P_ESC0_SPEED = speed;
			break;
		case 1:
			*P_ESC1_SPEED = speed;
			break;
		default:
			break;
	}
}

void uart_putc(const unsigned char c) __attribute__((optimize("O0")));
void uart_putc(const unsigned char c) {
	// Wait for UART to be not busy
	do {
		*P_UART_START = 0;
	} while((*P_UART_BUSY) != 0);

	*P_UART_CHAR = c;

	// Start UART transmission and wait for it to be done
	do {
		*P_UART_START = 1;
	} while ((*P_UART_DONE) == 0);

	// Clear UART done flag
	do {
		*P_UART_START = 0; 
	} while((*P_UART_BUSY) != 0);

	while ((*P_UART_DONE) != 0) {}
}

int _write(int fd, const void* buf, size_t len) {
	for (size_t i = 0; i < len; i++) {
		uart_putc(*((const unsigned char*)buf + i));
	}
    
    return (int)len;
}

int _read(int fd, void* buf, size_t len) {
    return 0; /* not needed for bare-metal printf */
}

void _exit(int status) {
    while (1) {};
}

/**
 * TODO: this function sleep 12,000 ms when ms=10,000 is requested. Fix it.
 * 
 * Sleep for at least (*) the given number of milliseconds.
 * This function uses a busy-wait loop to achieve the delay.
 * 
 * @param ms The number of milliseconds to sleep.
 * 
 * (*) This function will sleep at least the given number of milliseconds, 
 * with a small overhead (around ~5 more cpu instructions).
 */
void sleep_ms(unsigned int ms) __attribute__((optimize("O0")));
void sleep_ms(unsigned int ms) {
	unsigned int start_time = *P_UPTIME_MS;
	while ((*P_UPTIME_MS) < start_time + ms) {
		// Do nothing.
	}
	return;
}

void main(void) __attribute__((section(".main"), used));
void main(void) {
	char message[] = "hello my name is roi\n\r";
	
	while (1) {
		_write(0, message, sizeof(message));
		sleep_ms(1000);	
	}

	/*
	sleep_ms(3000); // sleep 3 seconds

	esc_set_speed(0, 1023);
	esc_set_speed(1, 1023);

	sleep_ms(3000); // sleep 3 seconds

	esc_set_speed(0, 0);
	esc_set_speed(1, 0);

	sleep_ms(3000); // sleep 3 seconds

	while (1) {
		for (int speed = 0; speed <= 1023; speed += 10) {
			esc_set_speed(0, speed);
			esc_set_speed(1, speed);
			sleep_ms(100);
		}

		sleep_ms(1000);
	}

	*/

	return;
}