module encryptor(
    input [63:0] round_key,
    input [63:0] state,
    output [63:0] result
);

wire [63:0] addroundkey;
wire [63:0] sbox;

assign addroundkey = round_key ^ state;

SboxLayer sbox_ins( 
    .state(addroundkey), 
    .result(sbox) 
);

PLayer player_ins( 
    .in_data(sbox), 
    .out_data(result) 
);

endmodule
