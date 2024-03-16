`timescale 1ns/1ps

module tb_player();
    wire [63:0] out;
    wire [63:0] in = 64'hcccccccccccccccc;
    PLayer p (in, out);
    integer i;

    reg clk;
    initial begin
        forever #4 clk = ~clk;
    end

    initial begin
        i = 0;
        clk = 0;
    end

    always @ * begin
        if (i == 72) begin
            $finish();
        end
    end

    always @ (posedge clk) begin
        i <= i + 1;
    end

    initial begin
        $dumpfile("player.vcd");
        $dumpvars(0, tb_player);
    end
endmodule