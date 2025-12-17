module aes10(
    input  wire        clk,
    input  wire        start,
    input  wire [9:0]  plaintext,
    input  wire [9:0]  key,
    output reg  [9:0]  ciphertext,
    output reg         ready
);

    reg [9:0] state;
    reg [2:0] round;

    wire [9:0] sub;
    wire [9:0] perm;

    sbox10 S (.in(state), .out(sub));
    perm10 P (.in(sub), .out(perm));

    localparam ROUNDS = 3;

    always @(posedge clk) begin
        if (start) begin
            state <= plaintext;
            round <= 0;
            ready <= 0;
        end
        else if (round < ROUNDS) begin
            state <= perm ^ key;  // SBOX + PERM done in same cycle
            round <= round + 1;
        end
        else if (!ready) begin
            ciphertext <= state;
            ready <= 1;
        end
    end
endmodule
