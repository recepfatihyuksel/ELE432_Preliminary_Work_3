module instrdec(
    input  logic [6:0] op,
    output logic [1:0] immsrc
);

    always_comb
        case(op)
            7'b0000011: immsrc = 2'b00;
            7'b0100011: immsrc = 2'b01;
            7'b1100011: immsrc = 2'b10;
            7'b0010011: immsrc = 2'b00;
            7'b1101111: immsrc = 2'b11;
            default:    immsrc = 2'b00;
        endcase

endmodule
