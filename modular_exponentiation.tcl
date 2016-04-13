proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -radix unsigned -position end sim:/modular_exponentiation_tb/*
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/Exp_in
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/M_in
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/clk
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/reset_t
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/C_out
    add wave -radix unsigned -position end sim:/modular_exponentiation_tb/dut/*
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/dut/temp_M1
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/dut/latch_in
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/dut/temp_A1
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/dut/temp_B1
    add wave -radix unsigned -position end sim:/modular_exponentiation_tb/dut/sqr_mult/*
    ;#add wave -radix unsigned -position end sim:/modular_exponentiation_tb/dut/sqr_mult/count	
    ;#add wave -radix binary -position end sim:/modular_exponentiation_tb/dut/sqr_mult/temp_Exp	
    add wave -radix unsigned -position end sim:/modular_exponentiation_tb/dut/sqr_mult/P
    add wave -radix unsigned -position end sim:/modular_exponentiation_tb/dut/sqr_mult/R   

}

vlib work

;# Compile components if any
vcom modular_exponentiation.vhd
vcom montgomery_multiplier.vhd
;#vcom mod_exp_comparison.vhd
;#vcom montgomery_comparison.vhd
vcom modular_exponentiation_tb.vhd

;# Start simulation
vsim modular_exponentiation_tb

;# Add the waves

AddWaves

log -r dut/*
;#set StdArithNoWarnings 1
;#run 0 ns;
;#set StdArithNoWarnings 0
# Continue script

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns


;# Run for 50 ns
run 4204546ns
