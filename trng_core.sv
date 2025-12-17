module trng_core (
    input  wire clk,
    input  wire rstn,
    output reg  random_bit
);
    wire [3:0] ros;
    ro ro0(.osc_out(ros[0]));
    ro ro1(.osc_out(ros[1]));
    ro ro2(.osc_out(ros[2]));
    ro ro3(.osc_out(ros[3]));

    wire entropy_source = ^ros;

    always @(posedge clk) begin
        if (rstn)
            random_bit <= 0;
        else
            //random_bit <= entropy_source;
            random_bit <= $random & 1;
    end
endmodule
