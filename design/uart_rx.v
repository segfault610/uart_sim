module uart_rx #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] data_out,
    output reg valid
);

localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

reg [15:0] clk_count = 0;
reg [2:0] bit_index = 0;
reg [7:0] rx_shift = 0;
reg receiving = 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        receiving <= 0;
        valid <= 0;
        clk_count <= 0;
        bit_index <= 0;
        data_out <= 0;
        rx_shift <= 0;
    end else begin
        valid <= 0;

        if (!receiving) begin
            if (rx == 0) begin  // start bit detected
                receiving <= 1;
                clk_count <= 0;
                bit_index <= 0;
            end
        end
        else begin
            clk_count <= clk_count + 1;

            // Wait half bit before first sample
            if (bit_index == 0 && clk_count == (CLKS_PER_BIT/2)) begin
                clk_count <= 0;
            end

            // Sample data bits
            else if (clk_count == CLKS_PER_BIT-1) begin
                clk_count <= 0;

                rx_shift <= {rx, rx_shift[7:1]};
                bit_index <= bit_index + 1;

                if (bit_index == 7) begin
                    receiving <= 0;
                    data_out <= {rx, rx_shift[7:1]};
                    valid <= 1;
                end
            end
        end
    end
end

endmodule
