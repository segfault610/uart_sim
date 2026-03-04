module uart_tx
#(parameter CLKS_PER_BIT = 20)
(
    input  logic clk,
    input  logic rst,
    input  logic [7:0] data_in,
    input  logic start,
    output logic tx,
    output logic busy
);

typedef enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP
} state_t;

state_t state;

logic [15:0] clk_count;
logic [2:0] bit_index;
logic [7:0] tx_data;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state      <= IDLE;
        tx         <= 1'b1;
        busy       <= 0;
        clk_count  <= 0;
        bit_index  <= 0;
    end
    else begin
        case (state)

        IDLE: begin
            tx   <= 1'b1;
            busy <= 0;
            clk_count <= 0;
            bit_index <= 0;

            if (start) begin
                busy    <= 1;
                tx_data <= data_in;
                state   <= START;
            end
        end

        START: begin
            tx <= 0;
            if (clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;
                state <= DATA;
            end
        end

        DATA: begin
            tx <= tx_data[bit_index];

            if (clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;

                if (bit_index < 7)
                    bit_index <= bit_index + 1;
                else begin
                    bit_index <= 0;
                    state <= STOP;
                end
            end
        end

        STOP: begin
            tx <= 1;
            if (clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule
