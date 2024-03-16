module counter(
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    input  wire stop,
    output wire [4:0] count
);

reg state;
reg [4:0] val;

always @ (posedge clk) begin
    if (!rst_n)
        val <= 5'b0;
    else if (stop)
        val <= val;
    else if (start)
        val <= val + 5'b1;
end
          
assign count = val;

endmodule