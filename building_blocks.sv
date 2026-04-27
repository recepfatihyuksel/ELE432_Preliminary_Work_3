module flopr #(parameter WIDTH = 8)(
    input  logic             clk,
    input  logic             reset,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    always_ff @(posedge clk or posedge reset)
        if (reset)
            q <= '0;
        else
            q <= d;

endmodule

module flopenr #(parameter WIDTH = 8)(
    input  logic             clk,
    input  logic             reset,
    input  logic             en,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    always_ff @(posedge clk or posedge reset)
        if (reset)
            q <= '0;
        else if (en)
            q <= d;

endmodule

module mux3 #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] d0,
    input  logic [WIDTH-1:0] d1,
    input  logic [WIDTH-1:0] d2,
    input  logic [1:0]       s,
    output logic [WIDTH-1:0] y
);

    always_comb
        case (s)
            2'b00:   y = d0;
            2'b01:   y = d1;
            2'b10:   y = d2;
            default: y = 'x;
        endcase

endmodule

module regfile(
    input  logic        clk,
    input  logic        we3,
    input  logic [4:0]  a1,
    input  logic [4:0]  a2,
    input  logic [4:0]  a3,
    input  logic [31:0] wd3,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

    logic [31:0] rf[31:0];

    always_ff @(posedge clk)
        if (we3)
            rf[a3] <= wd3;

    assign rd1 = (a1 != 0) ? rf[a1] : 32'b0;
    assign rd2 = (a2 != 0) ? rf[a2] : 32'b0;

endmodule

module extend(
    input  logic [31:7] instr,
    input  logic [1:0]  immsrc,
    output logic [31:0] immext
);

    always_comb
        case (immsrc)
            2'b00:   immext = {{20{instr[31]}}, instr[31:20]};
            2'b01:   immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            2'b10:   immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            2'b11:   immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            default: immext = 32'bx;
        endcase

endmodule

module alu(
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [2:0]  alucontrol,
    output logic [31:0] result,
    output logic        zero
);

    always_comb
        case (alucontrol)
            3'b000:  result = a & b;
            3'b001:  result = a | b;
            3'b010:  result = a + b;
            3'b110:  result = a - b;
            3'b111:  result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            default: result = 32'bx;
        endcase

    assign zero = (result == 32'b0);

endmodule
