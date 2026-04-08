#ifdef _PICOLIBC
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
#else  // _PICOLIBC
typedef signed short int16_t;
typedef unsigned int size_t;
#endif // _PICOLIBC

#define MPU6050_ADDR         0x68  // Default I2C address

#define MMIOEnumToAddr(A) (0xFFFFFFFF - A)

enum MMIOAddr {
    UART_CHAR = 0,
    UART_START,
    UART_DONE,
    UART_BUSY,
    ESC0_SPEED,
    ESC1_SPEED,
    ESC_READY,
    UPTIME_MS,
    I2C_DEV_ADDR,
    I2C_REG_ADDR,
    I2C_RW,
    I2C_START,
    I2C_DATA_IN,
    I2C_DATA_OUT,
    I2C_DONE
};

typedef struct {
    int16_t accel_x;
    int16_t accel_y;
    int16_t accel_z;
    int16_t temp; // Temperature
    int16_t gyro_x;
    int16_t gyro_y;
    int16_t gyro_z;
} sMPU6050Output_t;

inline void mmio_write(enum MMIOAddr addr, unsigned int value) __attribute__((optimize("O0")));
void mmio_write(enum MMIOAddr addr, unsigned int value) {
    (*((unsigned int*) (MMIOEnumToAddr(addr)))) = value;
}

inline unsigned int mmio_read(enum MMIOAddr addr) __attribute__((optimize("O0")));
unsigned int mmio_read(enum MMIOAddr addr) {
    return (*((unsigned int*) MMIOEnumToAddr(addr)));
}

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

void esc_set_speed(const unsigned short index, const unsigned int speed) {
    switch (index) {
        case 0:
            mmio_write(ESC0_SPEED, speed);
            break;
        case 1:
            mmio_write(ESC1_SPEED, speed);
            break;
        default:
            break;
    }
}

void uart_putc(const unsigned char c) {
    // Wait for UART to be not busy
    do {
        mmio_write(UART_START, 0);
    } while(mmio_read(UART_BUSY) != 0);

    mmio_write(UART_CHAR, c);

    // Start UART transmission and wait for it to be done
    do {
        mmio_write(UART_START, 1);
    } while (mmio_read(UART_DONE) == 0);

    // Clear UART done flag
    do {
        mmio_write(UART_START, 0);
    } while(mmio_read(UART_BUSY) != 0);

    while (mmio_read(UART_DONE) != 0) {}
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
void sleep_ms(unsigned int ms) {
    unsigned int start_time = mmio_read(UPTIME_MS);
    while (mmio_read(UPTIME_MS) < start_time + ms) {
        // Do nothing.
    }
    return;
}

unsigned char i2c_read(unsigned char device_address, unsigned char register_address) {
    unsigned char output = 0;

    mmio_write(I2C_START, 0);
    while (mmio_read(I2C_DONE) != 0) {}

    mmio_write(I2C_DEV_ADDR, device_address);
    mmio_write(I2C_REG_ADDR, register_address);
    mmio_write(I2C_RW, 1);    // 1 for read
    mmio_write(I2C_START, 1); // 1 for start

    while (mmio_read(I2C_DONE) == 0) {}

    output = mmio_read(I2C_DATA_OUT);

    mmio_write(I2C_START, 0);

    return output;
}

void i2c_write(unsigned char device_address, unsigned char register_address, unsigned char value) {
    mmio_write(I2C_START, 0);
    while (mmio_read(I2C_DONE) != 0) {}

    mmio_write(I2C_DEV_ADDR, device_address);
    mmio_write(I2C_REG_ADDR, register_address);
    mmio_write(I2C_RW, 0);    // 0 for write
    mmio_write(I2C_DATA_IN, value);
    mmio_write(I2C_START, 1); // 1 for start

    while (mmio_read(I2C_DONE) == 0) {}

    mmio_write(I2C_START, 0);
}

int16_t i2c_read_16(unsigned char device_address, unsigned char register_address) {
    unsigned char h = 0;
    unsigned char l = 0;

    h = i2c_read(device_address, register_address);
    l = i2c_read(device_address, register_address + 1);

    return (int16_t) ((h << 8) | l);
}

void read_mpu6050(sMPU6050Output_t* output) {
    if (output == 0) {
        return;
    }

    // Read Accelerometer data (Registers 0x3B - 0x40)
    output->accel_x = i2c_read_16(MPU6050_ADDR, 0x3B);
    output->accel_y = i2c_read_16(MPU6050_ADDR, 0x3D);
    output->accel_z = i2c_read_16(MPU6050_ADDR, 0x3F);

    // Read Temperature data (Registers 0x41 - 0x42)
    output->temp    = i2c_read_16(MPU6050_ADDR, 0x41);

    // Read Gyroscope data (Registers 0x43 - 0x48)
    output->gyro_x  = i2c_read_16(MPU6050_ADDR, 0x43);
    output->gyro_y  = i2c_read_16(MPU6050_ADDR, 0x45);
    output->gyro_z  = i2c_read_16(MPU6050_ADDR, 0x47);
}

void main(void) __attribute__((section(".main"), used));
void main(void) {
    // https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf

    char message[] = "hello my name is roi\n\r";
    sMPU6050Output_t mpu = { 0 };
    
    while (1) {
        _write(0, message, sizeof(message) - 1);
        sleep_ms(1000);    
        read_mpu6050(&mpu);
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