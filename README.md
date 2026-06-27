## CPU

The heart of this project is a **32-bit MIPS R2000 processor** that I designed and implemented from scratch in Verilog.

The CPU features:

* 32-bit architecture
* Pipelined implementation
* Support for almost the entire MIPS R2000 instruction set
* Memory-mapped I/O
* Bare-metal execution
* Designed to be easily extensible for custom hardware

One of the long-term goals is to add a **hardware Floating Point Unit (FPU)** to accelerate floating-point computations used in flight control and robotics applications.

## Development Goals

* [x] Implement a custom 32-bit pipelined MIPS R2000 CPU
* [x] Support almost the entire MIPS R2000 ISA
* [x] Run bare-metal C and assembly programs
* [x] Control ESCs using FPGA-generated PWM
* [ ] Implement a hardware Floating Point Unit (FPU)
* [ ] Integrate IMU sensors
* [ ] Implement a stabilization controller
* [ ] Autonomous flight
* [ ] Navigation algorithms

## Inspiration

This project started as an attempt to build a quadcopter using an Arduino.

I quickly ran into the limitations of a traditional microcontroller. The Arduino had to simultaneously:

* Generate PWM signals for four brushless motor ESCs
* Read data from the gyroscope
* Receive commands from the remote controller
* Execute the stabilization algorithm

Trying to do all of this in real time pushed the platform beyond what I was comfortable with, and it sparked my interest in FPGAs.

At the time, I also wanted to learn Verilog and digital design, so I decided to combine both goals into a single project: instead of using an existing processor, I would build my own **32-bit pipelined MIPS R2000 CPU** that I could modify specifically for the needs of a drone.

The project evolved from "build a better drone controller" into a deep dive into computer architecture, processor design, and FPGA development. Along the way I learned an incredible amount about CPU pipelines, hardware design, memory systems, embedded software, and the challenges of making hardware and software work together.

Even if this isn't the most practical way to build a drone, it has been one of the most enjoyable and educational projects I've worked on.
