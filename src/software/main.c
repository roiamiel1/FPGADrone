#include <stdio.h>

#include <unistd.h>

/* Create actual FILE objects (storage) */
FILE __stdin_struct;
FILE __stdout_struct;
FILE __stderr_struct;

/* Define the constant pointers to these objects */
FILE* const stdin  = &__stdin_struct;
FILE* const stdout = &__stdout_struct;
FILE* const stderr = &__stderr_struct;

#define CPU_FREQ_HZ   27000000 // 27 MHz
#define CYCLES_PER_MS (CPU_FREQ_HZ / 1000)

#define P_UART_CHAR  ((unsigned char*) 0xFFFFFFFF)
#define P_UART_START ((unsigned char*) 0xFFFFFFFE)
#define P_UART_DONE  ((unsigned char*) 0xFFFFFFFD)
#define P_UART_BUSY  ((unsigned char*) 0xFFFFFFFC)
#define P_ESC0_SPEED ((unsigned int*)  0xFFFFFFFB)
#define P_ESC1_SPEED ((unsigned int*)  0xFFFFFFFA)
#define P_ESC_READY  ((unsigned char*) 0xFFFFFFF0)

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

int is_esc_ready() __attribute__((optimize("O0")));
int is_esc_ready() {
	return (*P_ESC_READY) == 0;
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
 * with a small overhead (around ~10 more cpu instructions).
 */
void sleep_ms(unsigned int ms) __attribute__((optimize("O0")));
void sleep_ms(unsigned int ms) {
	// each loop iteration is 4 cycles
	// addi   $t0, $t0, -1			- decrement counter
	// sll    $t0, $t0, 0		    - placeholder round instruction count to power of 2, so divition is just a shift
	// bnez   $t0, sleep_ms_loop	- branch instruction
	// nop 							- delay slot
    unsigned int cycles = (CYCLES_PER_MS >> 2) * ms;

    __asm__ volatile (
		"addi  $t0, %0, 0     \n"
		"sleep_loop:          \n"
		"addi $t0, $t0, -1    \n"   // decrement counter
		"bgtz $t0, sleep_loop \n"   // branch if greater than zero
		"nop                  \n"   // delay slot
		:							// no output
        : "r" (cycles)              // input
        : "$t0"                     // clobbered registers
    );
}

void calibrate_esc(int index) {
	esc_set_speed(index, 1023);
	sleep_ms(8000);
	esc_set_speed(index, 0);
	sleep_ms(8000);
}

void main(void) __attribute__((section(".main"), used));
void main(void) {
	char msg1[] = "Wait for ESC to shutdown\n\r";
	char msg2[] = "Wait for ESC to start\n\r";
	char msg3[] = "Calibrate ESC\n\r";
	char msg4[] = "Start\n\r";
	char msg5[] = "Set ESC max throttle\n\r";
	char msg6[] = "Set ESC min throttle\n\r";
	char msg7[] = "While loop\n\r";
	char msg8[] = "Switch to 0 -> 1023\n\r";
	char msg9[] = "Switch to 1023 -> 0\n\r";
	
	esc_set_speed(0, 0);
	esc_set_speed(1, 0);

	if (is_esc_ready()) {
		_write(1, msg1, sizeof(msg1) - 1);
		while (is_esc_ready()); // wait until ESC is not ready
	}

	// esc_set_speed(0, 1023);
	// esc_set_speed(1, 1023);

	_write(1, msg2, sizeof(msg2) - 1);

	while (!is_esc_ready()); // wait until ESC is ready

	// calibrate_esc(0);
	// calibrate_esc(1);

	_write(1, msg4, sizeof(msg4) - 1);

	sleep_ms(8000);

	int direction = 50;
	int speed = 0;

	int startup = 1;
	int top_speed = 0;

	while (1) {
		_write(1, msg7, sizeof(msg7) - 1);
		speed += direction;
		if (speed >= 1023) {
			direction *= -1;
			speed = 1023;
			top_speed = 1;
			_write(1, msg9, sizeof(msg9) - 1);
		} else if (speed <= 0) {
			direction *= -1;
			speed = 0;
			startup = 1;
			_write(1, msg8, sizeof(msg8) - 1);
			esc_set_speed(0, speed);
			esc_set_speed(1, speed);
			sleep_ms(400);
			speed += direction;
		}

		esc_set_speed(0, speed);
		esc_set_speed(1, speed);
		sleep_ms(400);

		if (top_speed) {
			sleep_ms(3000);
			top_speed = 0;
		}

		if (startup) {
			sleep_ms(3000);
			startup = 0;
		}
	}

	return;
}