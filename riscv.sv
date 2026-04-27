module riscv(
    input  logic        clk,
    input  logic        reset,
    output logic        MemWrite,
    output logic [31:0] Adr,
    output logic [31:0] WriteData,
    input  logic [31:0] ReadData
);

    logic [6:0] op;
    logic [2:0] funct3;
    logic       funct7b5;
    logic       Zero;
    logic [1:0] ImmSrc;
    logic [1:0] ALUSrcA;
    logic [1:0] ALUSrcB;
    logic [1:0] ResultSrc;
    logic       AdrSrc;
    logic [2:0] ALUControl;
    logic       IRWrite;
    logic       PCWrite;
    logic       RegWrite;

    controller c(
        .clk(clk),
        .reset(reset),
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .zero(Zero),
        .immsrc(ImmSrc),
        .alusrca(ALUSrcA),
        .alusrcb(ALUSrcB),
        .resultsrc(ResultSrc),
        .adrsrc(AdrSrc),
        .alucontrol(ALUControl),
        .irwrite(IRWrite),
        .pcwrite(PCWrite),
        .regwrite(RegWrite),
        .memwrite(MemWrite)
    );

    datapath dp(
        .clk(clk),
        .reset(reset),
        .ResultSrc(ResultSrc),
        .AdrSrc(AdrSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .IRWrite(IRWrite),
        .PCWrite(PCWrite),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .Zero(Zero),
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .Adr(Adr),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

endmodule
