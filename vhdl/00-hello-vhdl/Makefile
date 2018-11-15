SRCS ?= $(wildcard *.vhdl)
MAIN = hello_logic
SIM_TIME = 100ns

all: compile

compile: $(SRCS)
	ghdl -a $(SRCS)
	ghdl -e $(MAIN)

run: compile
	ghdl -r $(MAIN) --stop-time=$(SIM_TIME) --vcd=$(MAIN).vcd

run-test: compile
	ghdl -r $(MAIN)_test --stop-time=$(SIM_TIME) --vcd=$(MAIN).vcd

clean:
	$(RM) *.cf

.PHONY: all compile run clean
