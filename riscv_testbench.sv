module testbench();
    logic        clk;
    logic        reset;
    logic [31:0] WriteData;
    logic [31:0] DataAdr;
    logic        MemWrite;

    top dut(
        .clk(clk),
        .reset(reset),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite)
    );

    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    initial begin
        reset = 1;
        #22;
        reset = 0;
    end

    always @(negedge clk) begin
        if (MemWrite) begin
            if (DataAdr === 32'd100 && WriteData === 32'd25) begin
                $display("Simulation succeeded");
                $stop;
            end else if (DataAdr !== 32'd96) begin
                $display("Simulation failed: wrote %0d to address %0d", WriteData, DataAdr);
                $stop;
            end
        end
    end
endmodule
