import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.result import TestFailure

class SimpleRegisterTestModel:
    def __init__(self, i):
        if i%2 == 1 :
            self.reg_o = i - 1
        else:
            self.reg_o = i - 2
        if i == 0:
            self.reg_o = 0

@cocotb.test()
def single_register_test(dut):
    cocotb.fork(Clock(dut.clk_i, 20, units='ns').start())
    yield RisingEdge(dut.clk_i)
    for i in xrange(0,8):
        model = SimpleRegisterTestModel(i)
        dut.reg_i = i
        dut.write_enable_i = 1 - (i % 2)

        yield RisingEdge(dut.clk_i)
        if dut.reg_o != model.reg_o:
            raise TestFailure("{0} == {1}  Failed"
                .format(dut.reg_o, model.reg_o))

