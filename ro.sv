module ro (
    output wire osc_out
);
    (* preserve *) wire n1, n2, n3;

    assign n1 = ~n3;
    assign n2 = ~n1;
    assign n3 = ~n2;

    assign osc_out = n3;
endmodule
