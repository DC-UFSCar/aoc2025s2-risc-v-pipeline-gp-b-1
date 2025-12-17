module sbox10(
    input  wire [9:0] in,
    output wire [9:0] out
);
    reg [9:0] tb [0:1023];
    initial begin
        $readmemh("sbox10.hex", tb);
    end
    assign out = tb[in];
endmodule
