proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/N_in
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/A_in
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/B_in
    add wave -radix binary -position end sim:/montgomery_comparison_tb/clk_in
    add wave -radix binary -position end sim:/montgomery_comparison_tb/reset_t
    add wave -radix binary -position end sim:/montgomery_comparison_tb/latch_in
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/M_out

    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/dut/data_ready
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/dut/A_temp
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/dut/B_temp
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/dut/N_temp
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/dut/M_temp
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/dut/mult_result
    add wave -radix unsigned -position end sim:/montgomery_comparison_tb/dut/state

}

vlib work


;# Compile components if any

;#vcom -reportprogress 300 -work work mathpack.vhd
;#vcom -reportprogress 300 -work work test_module.vhd
;#vcom -reportprogress 300 -work work test_module_tb.vhd
vcom -reportprogress 300 -work work montgomery_comparison.vhd
vcom -reportprogress 300 -work work montgomery_comparison_tb.vhd

;# Start simulation

;#vsim  test_module_tb
vsim  montgomery_comparison_tb

;# Add the waves

AddWaves

;# Generate a clock with 1ns period
force -deposit clk_in 0 0 ns, 1 0.5 ns -repeat 1 ns


;# Run for 50 ns
run 5050ns