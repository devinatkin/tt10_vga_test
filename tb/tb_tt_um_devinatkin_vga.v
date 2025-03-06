
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

    // Clock generation: 10ns period (100MHz)
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0; // Hold reset
        ui_in = 8'h00;


        $display("Test completed.");
        $finish;
    end

endmodule
