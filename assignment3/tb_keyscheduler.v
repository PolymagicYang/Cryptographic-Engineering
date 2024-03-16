`timescale 1ns/1ps

module tb_enc();

reg clk, rst_n;
reg start, stop, load, enb, start_enc;
wire ready;
integer i;
wire [5:0] count;
wire [63:0] round_key;
reg [63:0] plain_text;
wire [63:0] cipher_text;
reg [79:0] user_key;

initial begin
    clk = 1'b0;
    user_key = 80'b0;
    plain_text = 64'b0;
    forever #4 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    #8;
    rst_n = 1'b1;
end

initial begin
    i = 0;
end

enc enc1(
    .clk(clk),
    .rst_n(rst_n),
    .start_enc(start_enc),
    .key(user_key),
    .plaintext(plain_text),
    .ready(ready),
    .cipher_text(cipher_text)
);

always @ * begin
    if (i == 4) begin
        start_enc = 1'b1;
    end
    if (i == 72) begin
        $finish();
    end
end

always @ (posedge clk) begin
    if (rst_n) begin
        i <= i + 1;
    end
end

initial begin
    $dumpfile("scheduler.vcd");
    $dumpvars(0, tb_enc);
end

endmodule