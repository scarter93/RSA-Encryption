proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -position end sim:/modular_exponentiation_tb/N_in
    add wave -position end sim:/modular_exponentiation_tb/Exp_in
    add wave -position end sim:/modular_exponentiation_tb/M_in
    add wave -position end sim:/modular_exponentiation_tb/clk
    add wave -position end sim:/modular_exponentiation_tb/reset_t
    add wave -position end sim:/modular_exponentiation_tb/C_out
  

}

vlib work

;# Compile components if any
vcom modular_exponentiation.vhd
vcom modular_exponentiation_tb.vhd

;# Start simulation
vsim modular_exponentiation_tb

;# Add the waves

AddWaves

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns


;# Run for 50 ns
run 50ns
