module rotatel2(
    input wire [9:0] in,
    output wire [9:0] out
);

    assign out = {in[7:0], in[9:8]};
endmodule