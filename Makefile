
%_tb.vvp: %_tb.v %.v
	iverilog $^ -o $@

%_tb.vcd: %_tb.vvp
	vvp $^
