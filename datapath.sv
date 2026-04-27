module datapath(
    input  logic        clk,
    input  logic        reset,
    input  logic [1:0]  ResultSrc,
    input  logic        AdrSrc,
    input  logic [1:0]  ALUSrcA,
    input  logic [1:0]  ALUSrcB,
    input  logic        IRWrite,
    input  logic        PCWrite,
    input  logic        RegWrite,
    input  logic [1:0]  ImmSrc,
    input  logic [2:0]  ALUControl,
    output logic        Zero,
    output logic [6:0]  op,
    output logic [2:0]  funct3,
    output logic        funct7b5,
    output logic [31:0] Adr,
    output logic [31:0] WriteData,
    input  logic [31:0] ReadData
);

    logic [31:0] PC;
    logic [31:0] OldPC;
    logic [31:0] Instr;
    logic [31:0] Data;
    logic [31:0] RD1;
    logic [31:0] RD2;
    logic [31:0] A;
    logic [31:0] ImmExt;
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [31:0] ALUResult;
    logic [31:0] ALUOut;
    logic [31:0] Result;

    assign op       = Instr[6:0];
    assign funct3   = Instr[14:12];
    assign funct7b5 = Instr[30];
    assign Adr      = AdrSrc ? Result : PC;

    flopenr #(32) pcreg(clk, reset, PCWrite, Result, PC);
    flopenr #(32) oldpcreg(clk, reset, IRWrite, PC, OldPC);
    flopenr #(32) instrreg(clk, reset, IRWrite, ReadData, Instr);
    flopr   #(32) datareg(clk, reset, ReadData, Data);
    flopr   #(32) areg(clk, reset, RD1, A);
    flopr   #(32) writedatareg(clk, reset, RD2, WriteData);
    flopr   #(32) aluoutreg(clk, reset, ALUResult, ALUOut);

    regfile rf(
        .clk(clk),
        .we3(RegWrite),
        .a1(Instr[19:15]),
        .a2(Instr[24:20]),
        .a3(Instr[11:7]),
        .wd3(Result),
        .rd1(RD1),
        .rd2(RD2)
    );

    extend ext(
        .instr(Instr[31:7]),
        .immsrc(ImmSrc),
        .immext(ImmExt)
    );

    mux3 #(32) srcamux(PC, OldPC, A, ALUSrcA, SrcA);
    mux3 #(32) srcbmux(WriteData, ImmExt, 32'd4, ALUSrcB, SrcB);
    alu aluunit(SrcA, SrcB, ALUControl, ALUResult, Zero);
    mux3 #(32) resultmux(ALUOut, Data, ALUResult, ResultSrc, Result);

endmodule
