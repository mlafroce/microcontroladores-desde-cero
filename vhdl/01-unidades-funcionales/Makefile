SRC_FILES ?= $(wildcard *.vhdl)
VHDL_SOURCES = $(addprefix $(shell pwd)/,$(SRC_FILES)) 
SIM = ghdl

TOPLEVEL   := single_register
MODULE   := single_register_test

include $(COCOTB)/makefiles/Makefile.inc
include $(COCOTB)/makefiles/Makefile.sim
