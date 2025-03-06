/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_devinatkin_pwm (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire       clk,      // Clock
    input  wire       rst_n     // Active-low reset
);

    parameter WIDTH = 4;        // Width of each register
    parameter SIZE = 4;         // Number of registers

    wire pulse_on_change_signal; // Pulse on change signal

    wire [(WIDTH*SIZE)-1:0] shift_reg_out; // Fixed array declaration

    // Pulse on change instance
    pulse_on_change pulse_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(ui_in),
        .pulse(pulse_on_change_signal)
    );

    // Shift register instance (uses PWM output as clock)
    shift_register #(
        .WIDTH(WIDTH),
        .SIZE(SIZE)
    ) shift_reg (
        .clk(clk),   // Slow PWM-generated clock
        .shift_signal(pulse_on_change_signal), // Shift on pulse
        .rst_n(rst_n),
        .data_in(ui_in[3:0]),  // Inputs drive the shift register
        .reg_out(shift_reg_out)
    );

    // 8 PWM Modules, each fed by the shift register
    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : pwm_gen
            pwm_module #(
                .bit_width(WIDTH)
            ) pwm_inst (
                .clk(clk),                      // PWM modules use main clock
                .rst_n(rst_n),                  // Reset
                .duty(shift_reg_out[(i+1)*WIDTH-1 : WIDTH*i]),        // Shift register output as duty cycle
                .max_value(4'hF),              // Max value = 255 (full range)
                .pwm_out(uo_out[i])             // PWM output mapped to `uo_out`
            );
        end
    endgenerate

    // Assign remaining outputs
    assign uo_out[4] = shift_reg_out[1];
    assign uo_out[5] = pulse_on_change_signal;
    assign uo_out[6] = shift_reg_out[3];
    assign uo_out[7] = shift_reg_out[7];

endmodule
