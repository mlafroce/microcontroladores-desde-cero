SRCS ?= $(wildcard *.vhdl)
MAIN = hello_flip_flops
SIM_TIME = 1000ns

all: compile

compile: $(SRCS)
	ghdl -a $(SRCS)
	ghdl -e $(MAIN)

run: compile
	ghdl -r $(MAIN) --stop-time=$(SIM_TIME) --vcd=$(MAIN).vcd

run-tests: compile
	ghdl -r hello_logic_test --stop-time=$(SIM_TIME) --vcd=hello_logic_test.vcd
	ghdl -r hello_flip_flops_test --stop-time=$(SIM_TIME) --vcd=hello_flip_flops_test.vcd

clean:
	$(RM) *.vcd *.cf

.PHONY: all compile run run-tests clean
