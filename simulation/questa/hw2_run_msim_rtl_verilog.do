transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/controller.sv}
vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/maindec.sv}
vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/aludec.sv}
vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/instrdec.sv}
vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/building_blocks.sv}
vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/datapath.sv}
vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/riscv.sv}
vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/top.sv}
vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/memory.sv}

vlog -sv -work work +incdir+C:/FPGA_Works/ELE432_MulticycleRiscv-main {C:/FPGA_Works/ELE432_MulticycleRiscv-main/riscv_testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
