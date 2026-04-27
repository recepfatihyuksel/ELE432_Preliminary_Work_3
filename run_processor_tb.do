if {![file exists work]} {
    vlib work
}

vlog -sv building_blocks.sv controller.sv maindec.sv aludec.sv instrdec.sv datapath.sv riscv.sv memory.sv top.sv riscv_testbench.sv
vsim -voptargs=+acc testbench
add wave -radix hexadecimal sim:/testbench/clk
add wave -radix hexadecimal sim:/testbench/reset
add wave -radix hexadecimal sim:/testbench/dut/rvs/dp/PC
add wave -radix hexadecimal sim:/testbench/dut/rvs/dp/Instr
add wave -radix unsigned     sim:/testbench/dut/rvs/c/md/state
add wave -radix hexadecimal sim:/testbench/dut/rvs/dp/SrcA
add wave -radix hexadecimal sim:/testbench/dut/rvs/dp/SrcB
add wave -radix hexadecimal sim:/testbench/dut/rvs/dp/ALUResult
add wave -radix hexadecimal sim:/testbench/dut/DataAdr
add wave -radix hexadecimal sim:/testbench/dut/WriteData
add wave -radix hexadecimal sim:/testbench/dut/MemWrite
run -all
