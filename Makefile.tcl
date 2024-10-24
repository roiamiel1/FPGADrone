set_device GW1NR-LV9QN88PC6/I5
add_file -type verilog src/hardware/ALU.v
add_file -type verilog src/hardware/ConditionCheck.v
add_file -type verilog src/hardware/Control.v
add_file -type verilog src/hardware/EXMEMReg.v
add_file -type verilog src/hardware/Extender.v
add_file -type verilog src/hardware/ForwardingUnit.v
add_file -type verilog src/hardware/GPR.v
add_file -type verilog src/hardware/HazardUnit.v
add_file -type verilog src/hardware/IDEXReg.v
add_file -type verilog src/hardware/IFIDReg.v
add_file -type verilog src/hardware/InstructionMemory.v
add_file -type verilog src/hardware/MEMWBReg.v
add_file -type verilog src/hardware/MIPS_R2000.v
add_file -type verilog src/hardware/PCU.v
add_file -type verilog src/hardware/clk_div.v
add_file -type verilog src/hardware/instruction_def.v
add_file -type verilog src/hardware/seg7x16.v
add_file -type verilog src/hardware/signal_def.v
add_file -type verilog src/hardware/DataMemory.v
add_file -type cst src/hardware/drone.cst
set_option -top_module MIPS_R2000
run all