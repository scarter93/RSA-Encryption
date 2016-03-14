proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -position end sim:/montgomery_multiplier_tb/A_in
    add wave -position end sim:/montgomery_multiplier_tb/B_in
    add wave -position end sim:/montgomery_multiplier_tb/N_in
    add wave -position end sim:/montgomery_multiplier_tb/latch_in
    add wave -position end sim:/montgomery_multiplier_tb/clk
    add wave -position end sim:/montgomery_multiplier_tb/reset_t
    add wave -position end sim:/montgomery_multiplier_tb/M_out
    add wave -position end  sim:/montgomery_multiplier_tb/dut/M_temp
    add wave -position end  sim:/montgomery_multiplier_tb/dut/state
    add wave -position end  sim:/montgomery_multiplier_tb/dut/count
    add wave -position end  sim:/montgomery_multiplier_tb/dut/B_reg
    add wave -position end  sim:/montgomery_multiplier_tb/dut/temp
}


vlib work


;# Compile components if any
vcom montgomery_multiplier.vhd
vcom montgomery_multiplier_tb.vhd

;# Start simulation
vsim montgomery_multiplier_tb

;# Add the waves

AddWaves

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns


;# Run for 50 ns
run 50ns