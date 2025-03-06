
module shift_register #(
    parameter WIDTH = 8,        // Width of each register
    parameter SIZE = 8          // Number of registers
) (
    input clk,                  // Clock input
    input shift_signal,                // Shift signal input
    input rst_n,                // Active low reset input
    input [WIDTH-1:0] data_in,  // New input data to shift in
    output reg [(WIDTH*SIZE)-1:0] reg_out // Single-dimensional output register
);

reg [(WIDTH*SIZE)-1:0] shift; // Single-dimensional shift register

// Always block triggered by a positive edge of the clock or negative edge of reset
always @(posedge clk) begin
    if (!rst_n) begin
        // Reset the register to all zeros
        shift <= 0;
    end else begin
        // Shift the values
        if (shift_signal) begin
            shift <= {shift[(WIDTH*(SIZE-1))-1:0], data_in};
        end
    end
end

// Assign output value
always @(*) begin
    reg_out = shift;
end

endmodule
