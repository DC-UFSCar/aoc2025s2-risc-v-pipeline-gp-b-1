module perm10(
    input  wire [9:0] in,
    output wire [9:0] out
);
    assign out = {
        in[3], in[8], in[1], in[0], in[5],
        in[9], in[6], in[4], in[7], in[2]
    };
endmodule
