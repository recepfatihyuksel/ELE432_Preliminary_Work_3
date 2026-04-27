if {![file exists work]} {
    vlib work
}

vlog -sv controller.sv maindec.sv aludec.sv instrdec.sv testbench_controller.sv
vsim -voptargs=+acc testbench +TV=controller.tv
add wave -r sim:/*
run -all
