module enc(
    input clk,
    input rst_n,
    input start_enc,
    input [79:0] key,
    input [63:0] plaintext,

    output wire ready,
    output [63:0] cipher_text
);
    reg [4:0] count;
    wire [63:0] round_key;
    reg [63:0] state;
    wire [63:0] round_result;
    reg [63:0] final_result;
    reg load, enb;
    reg tick;

    // key_scheduler will run on the negative edge to sync the signals.
    key_scheduler ksc(
        .clk(clk),
        .enb(enb),
        .load(load),
        .key_in(key),
        .count(count),
        .key_out(round_key)
    );

    // The round_key will drives this encryptor module.
    encryptor encrypt(
        .round_key(round_key),
        .state(state),
        .result(round_result)
    );

    localparam INIT = 0, START = 1, EXECUTE = 2, FIN = 3, rounds = 31;

    reg [1:0] curr_state, next_state;

    always @(*) begin
        next_state = curr_state;

        case (curr_state)
            INIT : if (start_enc) begin
                load = 1'b1;    
                state = plaintext;
                next_state = START;
            end
            START : begin
                count = 5'b1;
                enb = 1'b1;
                load = 1'b0;
                next_state = EXECUTE;
            end
            EXECUTE : begin
                if (count == 0) begin
                    final_result = state;
                    next_state = FIN;
                end
            end
            FIN : begin
                final_result = final_result ^ round_key;
                enb = 1'b0;
                load = 1'b1;
                next_state = INIT;
            end
        endcase
    end

    always @(posedge clk) begin
        if (curr_state == EXECUTE) begin
            state = round_result; // This will collect the result from last round.
            count = count + 5'b1;
        end
    end

    always @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            enb = 1'b0;
            load = 1'b0;
            count = 5'b0;
            curr_state = INIT;
        end else begin
            curr_state = next_state;
        end
    end

    assign ready = (curr_state == FIN) ? 1'b1 : 1'b0;
    assign cipher_text = final_result;

endmodule