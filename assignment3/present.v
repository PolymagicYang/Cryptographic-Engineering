module present(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    output wire        ready_in,
    input  wire [63:0] plaintext_in,
    input  wire [79:0] key_in,
    input  wire        ready_out,
    output wire        valid_out,
    output wire [63:0] ciphertext_out
);

    localparam INIT = 0, WAIT = 1, START = 2, ROUNDS = 3, FINISH = 4;
    localparam KeyRounds = 31;

    reg state, next_state;
    wire counter_start, counter_stop, counter_rstn;
    wire enb_keygen, load_key;
    wire [5:0] count;
    reg [63:0] curr_roundkey;
    reg [79:0] regiser_key;


    key_scheduler key_gen (
        .clk(clk),
        .enb(enb_keygen),
        .load(load_key),
        .key_in(key_in),
    );

    counter rounds (
        .clk(clk),
        .rst_n(rst_n),
        .start(counter_start),
        .stop(countrer_end),
        .count(count),
        .key_out(curr_roundkey);
    );

    // next_state transitions logic.
    always @(*) begin
        next_state = state; // deafult.
        case (state)
            INIT : begin
                next_state = (valid_in) ? WAIT : INIT;
                enb_keygen = 1'b0;
                counter_start = 1'b0;
                counter_stop = 1'b0;
                counter_rstn = 1'b0;
            end

            WAIT : if (!valid_in) begin:
                next_state = INIT;
            end else if (ready_in) begin
                next_state = START;
            end

            START : if (!ready_in) begin
                next_state = WAIT;
            end else begin
                next_state = ROUNDS;
                counter_start = 1'b1;
                

            end

            ROUNDS : if (count == KeyRounds) begin
                next_state = FINISH;
            end else begin
                
            end

            FINISH : begin
                counter_stop = 1'b1;
                counter_start = 1'b0;
                counter_rstn = 1'b0; // reset the counter.

                next_state = (valid_in) ? WAIT : INIT;
            end
        endcase
    end

    // Transitions of the current states.
    always @(posedge clk) {
        if (!rst_n) begin 
            state = INIT;
        end
        else begin
            state = next_state;
        end
    }


endmodule