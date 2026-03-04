module uart_top(
    input  logic clk,
    input  logic rst,
    input  logic [7:0] data_in,
    input  logic start,
    output logic tx,
    output logic [7:0] rx_data,
    output logic rx_valid,
    output logic busy
);

parameter CLKS_PER_BIT = 20;

logic tx_internal;

// ---------------- TX ----------------
uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) tx_inst (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .start(start),
    .tx(tx_internal),
    .busy(busy)
);

// ---------------- RX ----------------
uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) rx_inst (
    .clk(clk),
    .rst(rst),
    .rx(tx_internal),       // LOOPBACK
    .data_out(rx_data),
    .valid(rx_valid)
);

// expose TX
assign tx = tx_internal;

endmodule
