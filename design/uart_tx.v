module uart_tx #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire start,
    output reg tx,
    output reg busy
);

localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

reg [15:0] clk_count = 0;
reg [3:0] bit_index = 0;
reg [9:0] shift_reg = 10'b1111111111;

reg [1:0] state = 0;

localparam IDLE  = 2'd0;
localparam SEND  = 2'd1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        tx <= 1'b1;
        busy <= 0;
        clk_count <= 0;
        bit_index <= 0;
    end else begin
        case (state)

            IDLE: begin
                tx <= 1'b1;
                busy <= 0;
                if (start) begin
                    shift_reg <= {1'b1, data_in, 1'b0};
                    state <= SEND;
                    busy <= 1;
                    clk_count <= 0;
                    bit_index <= 0;
                end
            end

            SEND: begin
                tx <= shift_reg[bit_index];

                if (clk_count < CLKS_PER_BIT-1)
                    clk_count <= clk_count + 1;
                else begin
                    clk_count <= 0;
                    bit_index <= bit_index + 1;

                    if (bit_index == 9)
                        state <= IDLE;
                end
            end

        endcase
    end
end

endmodule
