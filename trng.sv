module trng (
    input  wire clk,
    input  wire rstn,
    output reg [9:0] key,
    output reg ready
);
    wire raw_bit;
    wire valid;

    trng_core core(
        .clk(clk),
        .rstn(rstn),
        .random_bit(raw_bit)
    );

    vnc vn_corrector(
        .clk(clk),
        .rstn(rstn),
        .in_bit(raw_bit),
        .out_bit(random_bit),
        .valid(valid)
    );

    reg [3:0] i;

    always @(posedge clk) begin
        $display("%b | %b", random_bit, valid);
        if (rstn) begin
            key   <= 10'b0;
            i     <= 0;
            ready <= 0;
        end else if (valid) begin
            key[i] <= random_bit;
            i      <= i + 1;
            ready  <= (i == 9);
            $display("key=%b", key);
        end
    end

        
endmodule
