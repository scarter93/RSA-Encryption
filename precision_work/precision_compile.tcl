new_project -name montgomery_multiplier -folder {C:/Users/scarte9/RSA-Encryption/precision_work}
new_impl -name montgomery_multiplier_altera_impl
set_input_dir {C:/Users/scarte9/RSA-Encryption/precision_work}
setup_design -design=montgomery_multiplier
add_input_file -format vhdl -work work {{C:/Users/scarte9/RSA-Encryption/montgomery_multiplier_tb.vhd}}
add_input_file -format vhdl -work work {{C:/Users/scarte9/RSA-Encryption/montgomery_multiplier.vhd}}
setup_design -manufacturer ALTERA -family {CYCLONE II}  -part {EP2C70F672C} -speed {6} 
setup_design -edif=TRUE
setup_design -addio=TRUE
setup_design -basename montgomery_multiplier
setup_design -input_delay=0
if [catch {compile} err] {
	puts "Error: Errors found during compilation with Precision Synthesis tool"
	exit -force
} else {
	puts "report_status 20"
	puts "report_status 22"
	if [catch {synthesize} err] {
		puts "Error: Errors found during synthesis with Precision Synthesis tool"
		exit -force
	}
	puts "report_status 90"
	report_timing -all_clocks
	puts "report_status 92"
}
save_impl
puts "report_status 96"
close_project
