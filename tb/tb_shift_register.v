module shift_register_tb;

    // Testbench parameters
    parameter WIDTH = 8;  // Must match module parameters
    parameter SIZE  = 8;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg [WIDTH-1:0] data_in;
    wire [(WIDTH*SIZE)-1:0] reg_out;

    // Expected register state for self-checking
    reg [(WIDTH*SIZE)-1:0] expected_shift;

    // Instantiate the shift register module
    shift_register #(
        .WIDTH(WIDTH),
        .SIZE(SIZE)
    ) uut (
        .clk(clk),
        .shift_signal(1'b1),  // Always shift in new data
        .rst_n(rst_n),
        .data_in(data_in),
        .reg_out(reg_out)
    );

    // Clock generation: 10ns period (100MHz)
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;      // Apply reset
        data_in = 8'h00;
        expected_shift = 0;

        // Hold reset for a few cycles
        #20;
        rst_n = 1;      // Release reset
        $display("Reset released. Starting test sequence...");

        // Apply test values and check results
        repeat (10) begin
            data_in = $random % 256;  // Generate a random 8-bit value
            expected_shift = {expected_shift[(WIDTH*(SIZE-1))-1:0], data_in};
            #10;  // Wait for a clock cycle
            
            // Check the result
            if (reg_out !== expected_shift) begin
                $display("ERROR at time %0t: Expected 0x%h, Got 0x%h", $time, expected_shift, reg_out);
            end else begin
                $display("PASS at time %0t: Input 0x%h, Output 0x%h", $time, data_in, reg_out);
            end
        end

        // Finish the simulation
        #50;
        $display("Test completed.");
        $finish;
    end

endmodule
