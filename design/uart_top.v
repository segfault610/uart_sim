module uart_top(
    input clk,
    input rst,
    input [7:0] data_in,
    input start,
    output tx,
    output [7:0] rx_data,
    output rx_valid,
    output busy
);
wire tx_wire;

uart_tx tx_inst(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .start(start),
    .tx(tx_wire),
    .busy(busy)
);

uart_rx rx_inst(
    .clk(clk),
    .rst(rst),
    .rx(tx_wire),   // loopback
    .data_out(rx_data),
    .valid(rx_valid)
);

assign tx = tx_wire;

endmodule
