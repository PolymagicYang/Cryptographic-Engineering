module SboxLayer(
    input [63:0] state,
    output [63:0] result
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : sbox_gen
            wire [3:0] in = state[4*i +: 4];
            wire [3:0] out;
            sbox_table st (.in(in), .out(out));
            assign result[4*i +: 4] = out;
        end
    endgenerate
endmodule
