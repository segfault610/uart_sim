`timescale 1ns/1ps
module tb_uart;

logic clk = 0;
logic rst;
logic [7:0] data_in;
logic start;
logic tx;
logic [7:0] rx_data;
logic rx_valid;
logic busy;

always #10 clk = ~clk;

uart_top dut(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .start(start),
    .tx(tx),
    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .busy(busy)
);

initial begin
    rst = 1;
    #100 rst = 0;

    data_in = 8'hA5;
    start = 1;
    #20 start = 0;

    #200000;
    $finish;
end

initial begin
    $monitor("Time=%0t TX=%b RX_VALID=%b RX_DATA=%h BUSY=%b",
              $time, tx, rx_valid, rx_data, busy);
end

// Simple assertion using immediate style
always @(posedge clk) begin
    if (!rst && !start) begin
        if (tx !== 1'b1 && !busy)
            $display("ASSERTION FAIL: TX not idle high");
    end
end

always @(posedge clk) begin
    if (rx_valid)
        $display("RX RECEIVED: %h at time %t", rx_data, $time);
end
endmodule

