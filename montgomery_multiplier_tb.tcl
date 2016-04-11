puts {
    ECSE 487 - Final Project
    Montgomery Multiplier Testbench
    Authors : Stephen Carter, Jacob Barnett
    Creation Date : 03/02/2016
    Last Revision : 
}

proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -radix unsigned -position end sim:/montgomery_multiplier_tb/A_in
    add wave -radix unsigned -position end sim:/montgomery_multiplier_tb/B_in
    add wave -radix unsigned -position end sim:/montgomery_multiplier_tb/N_in
    add wave -position end sim:/montgomery_multiplier_tb/latch_in
    add wave -position end sim:/montgomery_multiplier_tb/clk
    add wave -position end sim:/montgomery_multiplier_tb/reset_t
    add wave -radix unsigned -position end sim:/montgomery_multiplier_tb/M_out
    add wave -radix unsigned -position end  sim:/montgomery_multiplier_tb/dut/M_temp
    add wave -radix unsigned -position end  sim:/montgomery_multiplier_tb/dut/state
    add wave -radix unsigned -position end  sim:/montgomery_multiplier_tb/dut/count
    add wave -radix unsigned -position end  sim:/montgomery_multiplier_tb/dut/B_reg
    add wave -radix unsigned -position end  sim:/montgomery_multiplier_tb/dut/temp
    add wave -radix unsigned -position end  sim:/montgomery_multiplier_tb/dut/N_temp
    add wave -radix unsigned -position end  sim:/montgomery_multiplier_tb/dut/q
    add wave -radix unsigned -position end  sim:/montgomery_multiplier_tb/dut/A_reg
}


vlib work


;# Compile components if any
vcom -reportprogress 300 -work work montgomery_multiplier.vhd
vcom -reportprogress 300 -work work montgomery_multiplier_tb.vhd

;# Start simulation
vsim montgomery_multiplier_tb

;# Add the waves

AddWaves

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns


;# Run for 100 ns
run 66ns

