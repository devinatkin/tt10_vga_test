`timescale 1ns / 1ps

module pulse_on_change_tb;

    // Testbench signals
    reg        clk;
    reg        rst_n;
    reg  [7:0] data_in;
    wire       pulse;

    // Instantiate the DUT (Device Under Test)
    pulse_on_change dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .pulse(pulse)
    );

    // Clock generation: 10 ns period (100 MHz)
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        data_in = 8'h00;

        // Apply reset
        #20 rst_n = 1; // Release reset after 20 ns

        // Test case 1: No change in data, pulse should remain low
        #10 data_in = 8'h00;
        #10 data_in = 8'h00;

        // Test case 2: Increase in data, pulse should go high for 1 clock cycle
        #10 data_in = 8'h05;
        
        // Test case 3: Decrease in data, pulse should go high for 1 clock cycle
        #10 data_in = 8'h02;

        // Test case 4: No change, pulse should stay low
        #10 data_in = 8'h02;

        // Test case 5: Increase again
        #10 data_in = 8'h10;

        // Test case 6: Another increase
        #10 data_in = 8'h20;

        // Test case 7: Decrease
        #10 data_in = 8'h15;

        // Test case 8: Rapid toggling
        #10 data_in = 8'h30;
        #10 data_in = 8'h10;
        #10 data_in = 8'h40;

        // End simulation
        #50 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | rst_n=%b | data_in=%h | pulse=%b", 
                 $time, rst_n, data_in, pulse);
    end

endmodule
