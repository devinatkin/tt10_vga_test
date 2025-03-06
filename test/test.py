# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    """Testbench for tt_um_devinatkin_pwm"""
    
    dut._log.info("Starting test...")

    # Create and start a 100 MHz clock (10 ns period)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Apply reset
    dut._log.info("Applying reset")
    dut.rst_n.value = 0
    dut.ui_in.value = 0  # Set input to zero initially
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut._log.info("Reset released")

    # Test case: Apply a sequence of input values
    test_values = [0x10, 0x20, 0x40, 0x80, 0xFF]  # Example duty cycle values
    
    for val in test_values:
        dut.ui_in.value = val  # Set the shift register input
        await ClockCycles(dut.clk, 20)  # Wait some cycles to propagate
        # dut._log.info(f"Input: {val:02X} | PWM Outputs: {dut.uo_out.value:02X}")

    # Ensure simulation runs for a sufficient period
    await ClockCycles(dut.clk, 200)

    dut._log.info("Test completed")
