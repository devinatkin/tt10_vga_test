
module pwm_module
#(parameter bit_width = 8)
(
    input clk,                         // 1-bit input: clock
    input rst_n,                       // 1-bit input: reset
    input [bit_width-1:0] duty,        // bitwidth-bit input: duty cycle
    input [bit_width-1:0] max_value,   // bitwidth-bit input: maximum value
    output reg pwm_out                 // 1-bit output: pwm output
);

reg [bit_width-1:0] counter;

// PWM output is high when counter is less than duty
// otherwise, PWM output is low
always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 0;
        pwm_out <= 1'b0;
    end else begin 
        if (counter == max_value) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        pwm_out <= (counter <= duty);
    end
end

endmodule
