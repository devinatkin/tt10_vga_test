`timescale 1ns/1ps

// PWM module testbench
module tb_pwm_module;

  // Parameters
  parameter bit_width = 10;                                // Instantiation parameter for the PWM module
  parameter CLK_PERIOD = 10;                               // Clock period in simulation time units (10ns = 100MHz)
  parameter max_value = (1<<bit_width)-2;  // Maximum PWM counter value
  
  // Inputs
  reg clk;                                                 // Clock input
  reg rst_n;                                               // Reset input (active-low)
  reg [bit_width-1:0] duty = 1;                           // Duty cycle input

  // Outputs
  wire pwm_out;                                            // PWM output

  // Variables
  integer previous_duty_out_rise = 0;
  integer previous_duty_out_fall = 0;
  integer period = 0;
  integer time_high = 0;
  integer time_low = 0;
  integer current_time = 0;
  integer previous_period = 0;

  real calculated_duty = 1.0;
  real calculated_intendedduty = 1.0;
  real error = 1.0;

  // Instantiate the DUT (Device Under Test)
  pwm_module #(
    .bit_width(bit_width)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .duty(duty),
    .max_value(max_value),
    .pwm_out(pwm_out)
  );

  // Clock generator
  always #(CLK_PERIOD/2) clk = ~clk;

  // Initialize inputs
  initial begin
    clk = 0;
    rst_n = 0; // Assert reset (active-low)
    duty = 0;  // Set initial duty cycle
    #82;       // Wait before releasing reset
    rst_n = 1; // Release reset
    #20;       // Small delay

    // Test different duty cycle values (excluding 0% and 100%)
    for (integer i = 1; i < max_value; i = i + 1) begin
      #(max_value * CLK_PERIOD * 2);
      duty = i;
    end

    // Test Duty Cycle = 100%
    duty = max_value + 1;
    #(max_value * CLK_PERIOD * 2);
    
    // Test Duty Cycle = 0%
    duty = 0;
    #(max_value * CLK_PERIOD * 2);

    $finish;
  end

  // Measure duty cycle
  always @(posedge pwm_out) begin
    current_time = $time;
    if (previous_duty_out_rise != 0 && previous_duty_out_fall != 0) begin
      period = current_time - previous_duty_out_rise;
      time_low = current_time - previous_duty_out_fall;
      time_high = period - time_low;
      if (period == previous_period) begin
        calculated_duty = (time_high * 100.0) / period;
        calculated_intendedduty = (duty * 100.0) / (max_value + 1);
        error = ((calculated_duty - calculated_intendedduty) / calculated_intendedduty) * 100.0;
        $display("Period: %0d, High: %0d, Low: %0d, Duty: %0f, Intended Duty: %0f, Error: %0f", 
                 period, time_high, time_low, calculated_duty, calculated_intendedduty, error);
      end
      previous_period = period;
    end
    previous_duty_out_rise = current_time;
  end

  always @(negedge pwm_out) begin
    current_time = $time;
    if (previous_duty_out_rise != 0 && previous_duty_out_fall != 0) begin
      period = current_time - previous_duty_out_fall;
      time_high = current_time - previous_duty_out_rise;
      time_low = period - time_high;
      if (period == previous_period) begin
        calculated_duty = (time_high * 100.0) / period;
        calculated_intendedduty = (duty * 100.0) / (max_value + 1);
        error = ((calculated_duty - calculated_intendedduty) / calculated_intendedduty) * 100.0;
        $display("Period: %0d, High: %0d, Low: %0d, Duty: %0f, Intended Duty: %0f, Error: %0f", 
                 period, time_high, time_low, calculated_duty, calculated_intendedduty, error);
      end
    end
    previous_duty_out_fall = current_time;
  end

endmodule
