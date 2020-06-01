SRC_FILES ?= $(wildcard *.vhdl)
VHDL_SOURCES = $(addprefix $(shell pwd)/,$(SRC_FILES)) 
SIM = ghdl

TOPLEVEL   := proto_cpu
MODULE   := proto_cpu_test

include $(COCOTB)/makefiles/Makefile.inc
include $(COCOTB)/makefiles/Makefile.sim
