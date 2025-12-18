module cripto(
    input wire clk,
    input wire reset,
    input wire [9:0] plaintext,
    input wire [9:0] key,
    output reg [9:0] ciphertext
);  

    wire [9:0] keys [0:3];
    wire [9:0] rkeys [0:4];
    reg [9:0] fkey;
    perm10 perm0(key, keys[0]);
    perm10 perm1((key ^ keys[0]), keys[1]);
    perm10 perm2((~keys[1] & key), keys[2]);
    perm10 perm3((keys[2] ^ keys[0] & ~key), keys[3]);

    rotatel2 r0(keys[0], rkeys[0]);
    rotatel2 r1(keys[1], rkeys[1]);
    rotatel2 r2(keys[2], rkeys[2]);
    rotatel2 r3(keys[3], rkeys[3]);
    rotatel2 r4(key, rkeys[4]);

    always@(*) begin
        if (reset) begin
            fkey <= 10'b0;
        end else begin
            fkey <= keys[0] ^ keys[1] ^ keys[2] ^ keys[3] ^ ~rkeys[0] ^ ~rkeys[1] ^ ~rkeys[2] ^ ~rkeys[3] ^ ~rkeys[4];
        end
    end

    always@(*) begin
        if (reset) begin
            ciphertext <= 10'b0;
        end else begin
            ciphertext <= (plaintext ^ fkey);
        end
    end

endmodule