set_device GW1NR-LV9QN88PC6/I5
add_file -type verilog new_cpu/ALU.v
add_file -type verilog new_cpu/ConditionCheck.v
add_file -type verilog new_cpu/Control.v
add_file -type verilog new_cpu/EXMEMReg.v
add_file -type verilog new_cpu/Extender.v
add_file -type verilog new_cpu/ForwardingUnit.v
add_file -type verilog new_cpu/GPR.v
add_file -type verilog new_cpu/HazardUnit.v
add_file -type verilog new_cpu/IDEXReg.v
add_file -type verilog new_cpu/IFIDReg.v
add_file -type verilog new_cpu/InstructionMemory.v
add_file -type verilog new_cpu/MEMWBReg.v
add_file -type verilog new_cpu/MIPS_R2000.v
add_file -type verilog new_cpu/PCU.v
add_file -type verilog new_cpu/clk_div.v
add_file -type verilog new_cpu/instruction_def.v
add_file -type verilog new_cpu/seg7x16.v
add_file -type verilog new_cpu/signal_def.v
add_file -type verilog new_cpu/DataMemory.v
add_file -type cst new_cpu/drone.cst
set_option -top_module MIPS_R2000
run all