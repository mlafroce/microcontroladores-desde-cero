import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.result import TestFailure


@cocotb.test()
def program_counter_test(dut):
    cocotb.fork(Clock(dut.clk_i, 20, units='ns').start())
    for i in xrange(0,8):
        dut.write_enable_i = 1
        print("reg_o: {}".format(dut.reg_o))
        yield RisingEdge(dut.clk_i)
        """if dut.reg_o != i:
            raise TestFailure("{0} == {1}  Failed"
                .format(dut.reg_o, i))"""
