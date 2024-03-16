module PLayer(
    input [63:0] in_data,
    output wire [63:0] out_data
);
    wire [63:0]in = in_data;
    assign out_data[0] = in[0];
    assign out_data[16] = in[1];
    assign out_data[32] = in[2];
    assign out_data[48] = in[3];
    assign out_data[1] = in[4];
    assign out_data[17] = in[5];
    assign out_data[33] = in[6];
    assign out_data[49] = in[7];
    assign out_data[2] = in[8];
    assign out_data[18] = in[9];
    assign out_data[34] = in[10];
    assign out_data[50] = in[11];
    assign out_data[3] = in[12];
    assign out_data[19] = in[13];
    assign out_data[35] = in[14];
    assign out_data[51] = in[15];
    assign out_data[4] = in[16];
    assign out_data[20] = in[17];
    assign out_data[36] = in[18];
    assign out_data[52] = in[19];
    assign out_data[5] = in[20];
    assign out_data[21] = in[21];
    assign out_data[37] = in[22];
    assign out_data[53] = in[23];
    assign out_data[6] = in[24];
    assign out_data[22] = in[25];
    assign out_data[38] = in[26];
    assign out_data[54] = in[27];
    assign out_data[7] = in[28];
    assign out_data[23] = in[29];
    assign out_data[39] = in[30];
    assign out_data[55] = in[31];
    assign out_data[8] = in[32];
    assign out_data[24] = in[33];
    assign out_data[40] = in[34];
    assign out_data[56] = in[35];
    assign out_data[9] = in[36];
    assign out_data[25] = in[37];
    assign out_data[41] = in[38];
    assign out_data[57] = in[39];
    assign out_data[10] = in[40];
    assign out_data[26] = in[41];
    assign out_data[42] = in[42];
    assign out_data[58] = in[43];
    assign out_data[11] = in[44];
    assign out_data[27] = in[45];
    assign out_data[43] = in[46];
    assign out_data[59] = in[47];
    assign out_data[12] = in[48];
    assign out_data[28] = in[49];
    assign out_data[44] = in[50];
    assign out_data[60] = in[51];
    assign out_data[13] = in[52];
    assign out_data[29] = in[53];
    assign out_data[45] = in[54];
    assign out_data[61] = in[55];
    assign out_data[14] = in[56];
    assign out_data[30] = in[57];
    assign out_data[46] = in[58];
    assign out_data[62] = in[59];
    assign out_data[15] = in[60];
    assign out_data[31] = in[61];
    assign out_data[47] = in[62];
    assign out_data[63] = in[63];

endmodule