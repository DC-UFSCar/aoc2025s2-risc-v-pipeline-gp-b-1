module vnc (
    input  wire clk,
    input  wire rstn,
    input  wire in_bit,
    output reg  out_bit,
    output reg  valid
);
    reg last_bit;
    reg have_last;

    always @(posedge clk) begin
        if (rstn) begin
            have_last <= 0;
            valid     <= 0;
        end else begin
            valid <= 0;

            if (!have_last) begin
                last_bit   <= in_bit;
                have_last  <= 1;
            end else begin
                have_last <= 0;

                if (last_bit != in_bit) begin
                    out_bit <= last_bit;  // 10→0, 01→1
                    valid   <= 1;
                end
            end
        end
    end
endmodule
