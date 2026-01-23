set_device GW2AR-LV18QN88C8/I7
set_option -output_base_name drone
set_option -top_module MIPS_R2000
add_file -type verilog src/hardware/ALU.v
add_file -type verilog src/hardware/Control.v
add_file -type verilog src/hardware/EXMEMReg.v
add_file -type verilog src/hardware/ForwardingUnit.v
add_file -type verilog src/hardware/GPR.v
add_file -type verilog src/hardware/IDEXReg.v
add_file -type verilog src/hardware/IFIDReg.v
add_file -type verilog src/hardware/MEMWBReg.v
add_file -type verilog src/hardware/MIPS_R2000.v
add_file -type verilog src/hardware/PCU.v
add_file -type verilog src/hardware/signal_def.v
add_file -type verilog src/hardware/DataMemory.v
add_file -type verilog src/hardware/DataMemoryInterface.v
add_file -type verilog src/hardware/UART.v
add_file -type verilog src/hardware/SDCard.v
add_file -type verilog src/hardware/gowin_dpb_16384_8/gowin_dpb_16384_8.v
add_file -type verilog src/hardware/ESCDriver.v
add_file -type verilog src/hardware/Timer.v
add_file -type cst src/hardware/drone.cst
add_file -type sdc src/hardware/drone.sdc
run all