import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
from cocotb.result import TestFailure


@cocotb.test()
def program_counter_test(dut):
    cocotb.fork(Clock(dut.clk_i, 20, units='ns').start())
    print("dut: {}".format(dut))
    yield Timer(2, units='ns')
    for i in xrange(0,8):
        yield RisingEdge(dut.clk_i)
        if dut.reg_o != i * 4 :
            raise TestFailure("{0} == {1}  Failed"
                .format(dut.reg_o, i * 4))
