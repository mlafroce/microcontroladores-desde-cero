SRCS ?= common.vhdl mux.vhdl cpu_register.vhdl register_file.vhdl register_file_muxed.vhdl cpu_register_test.vhdl register_file_test.vhdl
MAIN = register_file
SIM_TIME = 2000ns

all: compile

compile: $(SRCS)
	ghdl -a $(SRCS)
	ghdl -e $(MAIN)

run: compile
	ghdl -r $(MAIN) --stop-time=$(SIM_TIME) --vcd=$(MAIN).vcd

run-tests: compile
	ghdl -r cpu_register_test --stop-time=$(SIM_TIME) --vcd=cpu_register_test.vcd
	ghdl -r register_file_test --stop-time=$(SIM_TIME) --vcd=register_file_test.vcd
	
clean:
	$(RM) *.vcd *.cf

.PHONY: all compile run run-tests clean
