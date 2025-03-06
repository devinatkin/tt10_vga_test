
module tt_um_devinatkin_pwm_tb;

    // Parameters
    parameter WIDTH = 8;
    parameter SIZE  = 8;
    parameter CLK_PERIOD = 10; // 10 ns clock period (100 MHz)

    // Testbench signals
    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    wire [7:0] uo_out;

    // Instantiate the DUT (Device Under Test)
    tt_um_devinatkin_pwm uut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation: 10ns period (100MHz)
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0; // Hold reset
        ui_in = 8'h00;

        // Apply reset
        #50;
        rst_n = 1; // Release reset
        $display("Reset released. Starting test sequence...");

        // Apply test inputs
        repeat (10) begin
            ui_in = $random % 256; // Generate a random 8-bit input
            $display("Time: %0t | Input: 0x%h | PWM Outputs: 0x%h", $time, ui_in, uo_out);
            #2560; // Allow time for the shift register and PWM signals to propagate
        end

        // Finish the simulation
        #100;
        $display("Test completed.");
        $finish;
    end

endmodule
