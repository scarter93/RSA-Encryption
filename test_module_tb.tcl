proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -radix signed -position end sim:/test_module_tb/N_in
    add wave -radix signed -position end sim:/test_module_tb/Exp_in
    add wave -radix unsigned -position end sim:/test_module_tb/M_in
    add wave -radix binary -position end sim:/test_module_tb/clk_in
    add wave -radix binary -position end sim:/test_module_tb/reset_in
    add wave -radix unsigned -position end sim:/test_module_tb/C_out


}

vlib work


;# Compile components if any
vcom -reportprogress 300 -work work mathpack.vhd
vcom -reportprogress 300 -work work test_module.vhd
vcom -reportprogress 300 -work work test_module_tb.vhd

;# Start simulation
vsim  test_module_tb

;# Add the waves

AddWaves

;# Generate a clock with 1ns period
force -deposit clk_in 0 0 ns, 1 0.5 ns -repeat 1 ns


;# Run for 50 ns
run 100ns