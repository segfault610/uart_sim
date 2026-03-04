module uart_rx
#(parameter CLKS_PER_BIT = 20)
(
    input  logic clk,
    input  logic rst,
    input  logic rx,
    output logic [7:0] data_out,
    output logic valid
);

typedef enum logic [2:0] {
    RX_IDLE,
    RX_START,
    RX_DATA,
    RX_STOP
} state_t;

state_t state;

logic [15:0] clk_count;
logic [2:0] bit_index;
logic [7:0] rx_shift;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= RX_IDLE;
        clk_count <= 0;
        bit_index <= 0;
        valid <= 0;
    end
    else begin
        case (state)

        RX_IDLE: begin
            valid <= 0;
            clk_count <= 0;
            bit_index <= 0;

            if (rx == 0)
                state <= RX_START;
        end

        RX_START: begin
            // wait half bit
            if (clk_count == (CLKS_PER_BIT/2)) begin
                if (rx == 0) begin
                    clk_count <= 0;
                    state <= RX_DATA;
                end
                else
                    state <= RX_IDLE;
            end
            else
                clk_count <= clk_count + 1;
        end

        RX_DATA: begin
            if (clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;
                rx_shift[bit_index] <= rx;

                if (bit_index < 7)
                    bit_index <= bit_index + 1;
                else begin
                    bit_index <= 0;
                    state <= RX_STOP;
                end
            end
        end

        RX_STOP: begin
            if (clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                data_out <= rx_shift;
                valid <= 1;
                state <= RX_IDLE;
            end
        end

        endcase
    end
end

endmodule
