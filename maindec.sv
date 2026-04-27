module maindec(
    input  logic       clk,
    input  logic       reset,
    input  logic [6:0] op,
    output logic [1:0] alusrca,
    output logic [1:0] alusrcb,
    output logic [1:0] resultsrc,
    output logic       adrsrc,
    output logic [1:0] aluop,
    output logic       irwrite,
    output logic       pcupdate,
    output logic       regwrite,
    output logic       memwrite,
    output logic       branch
);

    localparam logic [3:0] S0_FETCH    = 4'd0;
    localparam logic [3:0] S1_DECODE   = 4'd1;
    localparam logic [3:0] S2_MEMADR   = 4'd2;
    localparam logic [3:0] S3_MEMREAD  = 4'd3;
    localparam logic [3:0] S4_MEMWB    = 4'd4;
    localparam logic [3:0] S5_MEMWRITE = 4'd5;
    localparam logic [3:0] S6_EXECUTER = 4'd6;
    localparam logic [3:0] S7_ALUWB    = 4'd7;
    localparam logic [3:0] S8_EXECUTEI = 4'd8;
    localparam logic [3:0] S9_JAL      = 4'd9;
    localparam logic [3:0] S10_BEQ     = 4'd10;

    logic [3:0] state;
    logic [3:0] nextstate;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0_FETCH;
        end else begin
            state <= nextstate;
        end
    end

    always_comb begin
        case (state)
            S0_FETCH: begin
                nextstate = S1_DECODE;
            end
            S1_DECODE: begin
                case (op)
                    7'b0000011: nextstate = S2_MEMADR;
                    7'b0100011: nextstate = S2_MEMADR;
                    7'b0110011: nextstate = S6_EXECUTER;
                    7'b0010011: nextstate = S8_EXECUTEI;
                    7'b1101111: nextstate = S9_JAL;
                    7'b1100011: nextstate = S10_BEQ;
                    default:    nextstate = S0_FETCH;
                endcase
            end
            S2_MEMADR: begin
                case (op)
                    7'b0000011: nextstate = S3_MEMREAD;
                    7'b0100011: nextstate = S5_MEMWRITE;
                    default:    nextstate = S0_FETCH;
                endcase
            end
            S3_MEMREAD: begin
                nextstate = S4_MEMWB;
            end
            S4_MEMWB: begin
                nextstate = S0_FETCH;
            end
            S5_MEMWRITE: begin
                nextstate = S0_FETCH;
            end
            S6_EXECUTER: begin
                nextstate = S7_ALUWB;
            end
            S7_ALUWB: begin
                nextstate = S0_FETCH;
            end
            S8_EXECUTEI: begin
                nextstate = S7_ALUWB;
            end
            S9_JAL: begin
                nextstate = S7_ALUWB;
            end
            S10_BEQ: begin
                nextstate = S0_FETCH;
            end
            default: begin
                nextstate = S0_FETCH;
            end
        endcase
    end

    always_comb begin
        alusrca  = 2'b00;
        alusrcb  = 2'b00;
        resultsrc = 2'b00;
        adrsrc   = 1'b0;
        aluop    = 2'b00;
        irwrite  = 1'b0;
        pcupdate = 1'b0;
        regwrite = 1'b0;
        memwrite = 1'b0;
        branch   = 1'b0;

        case (state)
            S0_FETCH: begin
                adrsrc   = 1'b0;
                irwrite  = 1'b1;
                alusrca  = 2'b00;
                alusrcb  = 2'b10;
                aluop    = 2'b00;
                resultsrc = 2'b10;
                pcupdate = 1'b1;
            end
            S1_DECODE: begin
                alusrca  = 2'b01;
                alusrcb  = 2'b01;
                aluop    = 2'b00;
            end
            S2_MEMADR: begin
                alusrca  = 2'b10;
                alusrcb  = 2'b01;
                aluop    = 2'b00;
            end
            S3_MEMREAD: begin
                resultsrc = 2'b00;
                adrsrc   = 1'b1;
            end
            S4_MEMWB: begin
                resultsrc = 2'b01;
                regwrite = 1'b1;
            end
            S5_MEMWRITE: begin
                resultsrc = 2'b00;
                adrsrc   = 1'b1;
                memwrite = 1'b1;
            end
            S6_EXECUTER: begin
                alusrca  = 2'b10;
                alusrcb  = 2'b00;
                aluop    = 2'b10;
            end
            S7_ALUWB: begin
                resultsrc = 2'b00;
                regwrite = 1'b1;
            end
            S8_EXECUTEI: begin
                alusrca  = 2'b10;
                alusrcb  = 2'b01;
                aluop    = 2'b10;
            end
            S9_JAL: begin
                alusrca  = 2'b01;
                alusrcb  = 2'b10;
                aluop    = 2'b00;
                resultsrc = 2'b00;
                pcupdate = 1'b1;
            end
            S10_BEQ: begin
                alusrca  = 2'b10;
                alusrcb  = 2'b00;
                aluop    = 2'b01;
                resultsrc = 2'b00;
                branch   = 1'b1;
            end
            default: begin
            end
        endcase
    end

endmodule
