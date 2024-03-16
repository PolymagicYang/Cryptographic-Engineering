module key_scheduler(
    input clk,
    input enb,
    input load,
    input [79:0] key_in,
    input[4:0] count,
    output reg [63:0] key_out
);

    reg [79:0] round_key;
    reg [79:0] key_modified;
    reg [3:0] sbox_in;
    reg [3:0] sbox_out;

    always @(negedge clk or posedge load) begin
        if (load) begin
            round_key = key_in;  
        end else if (enb) begin
            key_out = round_key[79:16];

            round_key = { round_key[18:0], round_key[79:19] };
            sbox_in = round_key[79:76];

            key_modified[79:20] = round_key[79:20];
            key_modified[19:15] = round_key[19:15] ^ count;
            key_modified[14:0] = round_key[14:0];

            case (sbox_in)
                4'h0 : sbox_out = 4'hC;
                4'h1 : sbox_out = 4'h5; 
                4'h2 : sbox_out = 4'h6;
                4'h3 : sbox_out = 4'hB;
                4'h4 : sbox_out = 4'h9;
                4'h5 : sbox_out = 4'h0;
                4'h6 : sbox_out = 4'hA;
                4'h7 : sbox_out = 4'hD;
                4'h8 : sbox_out = 4'h3;
                4'h9 : sbox_out = 4'hE;
                4'hA : sbox_out = 4'hF;
                4'hB : sbox_out = 4'h8;
                4'hC : sbox_out = 4'h4;
                4'hD : sbox_out = 4'h7;
                4'hE : sbox_out = 4'h1;
                4'hF : sbox_out = 4'h2;
            endcase

            round_key = {sbox_out, key_modified[75:0]};
        end
    end

endmodule
    