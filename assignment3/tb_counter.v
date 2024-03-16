`timescale 1ns/1ps

module tb_counter();

reg clk, rst_n;
reg start, stop;
integer i;
wire [5:0] count;

initial begin
    clk = 1'b0;
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

counter dut(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .stop(stop),
    .count(count)
);

always @ * begin
    if (i == 4) begin
        start = 1;
        stop = 0;
    end
    else if (i == 9) begin
        start = 0;
        stop = 1;
    end
    else if (i == 13) begin
        start = 0;
        stop = 1;
    end
    else if (i == 20) begin
        start = 1;
        stop = 0;
    end
    else if (i == 25) begin
        $finish();
    end
end

always @ (posedge clk) begin
    if (rst_n) begin
        i <= i + 1;
    end
end

initial begin
    $dumpfile("counter.vcd");
    $dumpvars(0, tb_counter);
end

endmodule