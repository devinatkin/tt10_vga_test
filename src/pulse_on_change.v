module pulse_on_change ( 
    input  wire        clk,
    input  wire        rst_n,        // Active-low reset
    input  wire  [7:0] data_in,
    output reg         pulse        // Pulse output on change
);
    
    reg [7:0] prev_data;

    always @(posedge clk) begin
        if (!rst_n) begin
            pulse <= 1'b0;
            prev_data <= 8'b0;

        end else begin

            pulse <= (data_in != prev_data);
            prev_data <= data_in; // Update previous data
        end
    end


endmodule
