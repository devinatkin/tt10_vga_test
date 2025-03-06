# Makefile for testing with iverilog and vvp

# Define the compiler and simulator
IVL = iverilog
VVP = vvp

# Output directory for simulation files
OUT_DIR = sim_out

# Create the output directory if it doesn't exist
$(shell mkdir -p $(OUT_DIR))

# Phony targets
.PHONY: all clean

all: tb_shift_register tb_pwm_module tb_top


tb_top: 
	$(IVL) -o $(OUT_DIR)/$@.vvp ../src/hvsync_generator.v ../src/tt_um_devinatkin_vga.v tb_tt_um_devinatkin_vga.v 
	$(VVP) $(OUT_DIR)/$@.vvp


clean:
	@echo Cleaning up...
	rm -rf $(OUT_DIR)