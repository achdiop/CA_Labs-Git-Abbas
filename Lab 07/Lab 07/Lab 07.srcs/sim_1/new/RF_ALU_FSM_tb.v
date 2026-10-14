`timescale 1ns / 1ps

module RF_ALU_FSM_tb;

    reg clk;
    reg rst;

    // FSM State Encodings
    localparam IDLE            = 2'b00;
    localparam READ_REGISTERS  = 2'b01;
    localparam ALU_OPERATION   = 2'b10;
    localparam WRITE_REGISTERS = 2'b11;

    reg [1:0] state;

    // FSM Data and Control Signals
    reg  [4:0]  rs1_reg, rs2_reg, rd_reg;
    reg  [3:0]  alu_ctrl_reg;
    reg  [31:0] imm_data_reg;
    reg         use_alu_res_reg;
    reg         we_reg;
    reg         is_beq_test;

    // Interfaces
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_data;
    wire        write_enable;
    wire [31:0] alu_result;
    wire        alu_zero;

    // Instantiate the Register File
    RegisterFile rf (
        .clk(clk),
        .rst(rst),
        .WriteEnable(write_enable),
        .rs1(rs1_reg),
        .rs2(rs2_reg),
        .rd(rd_reg),
        .WriteData(write_data),
        .ReadData1(read_data1),
        .readData2(read_data2)
    );

    // Instantiate the Cascaded 32-bit ALU
    ALU_32bit alu (
        .A(read_data1),
        .B(read_data2),
        .ALUControl(alu_ctrl_reg),
        .ALUResult(alu_result),
        .Zero(alu_zero)
    );

    // Datapath Multiplexer: Choose between immediate constants or ALU result
    assign write_data = use_alu_res_reg ? alu_result : imm_data_reg;

    // Write Logic: Assert only in WRITE_REGISTERS state. Conditionally assert if BEQ test.
    assign write_enable = (state == WRITE_REGISTERS) && we_reg && (!is_beq_test || alu_zero);

    // Test Sequencer
    reg [4:0] test_idx = 0;

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        state = IDLE;
        
        // Generate Waveforms
        $dumpfile("rf_alu_fsm.vcd");
        $dumpvars(0, RF_ALU_FSM_tb);
        
        #15 rst = 0;
    end

    // FSM State Transitions
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            test_idx <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (test_idx < 13) 
                        state <= READ_REGISTERS;
                    else begin
                        $display("\n--- All operations done. Simulation finished. ---");
                        $finish;
                    end
                end
                READ_REGISTERS:  state <= ALU_OPERATION;
                ALU_OPERATION:   state <= WRITE_REGISTERS;
                WRITE_REGISTERS: begin
                    state <= IDLE;
                    test_idx <= test_idx + 1; // Move to the next test vector
                end
            endcase
        end
    end

    // Test Vector Decoder (Applies inputs based on current test index)
    always @(*) begin
        // Default signals to prevent latching
        rs1_reg = 0; rs2_reg = 0; rd_reg = 0;
        alu_ctrl_reg = 4'b0000;
        imm_data_reg = 32'd0;
        use_alu_res_reg = 0;
        we_reg = 0;
        is_beq_test = 0;

        case (test_idx)
            // Task 2c(i): Write known constants into registers x1, x2, x3
            0: begin rd_reg = 1; imm_data_reg = 32'h10101010; we_reg = 1; use_alu_res_reg = 0; end
            1: begin rd_reg = 2; imm_data_reg = 32'h01010101; we_reg = 1; use_alu_res_reg = 0; end
            2: begin rd_reg = 3; imm_data_reg = 32'h00000005; we_reg = 1; use_alu_res_reg = 0; end
            
            // Task 2c(ii): Read registers, feed to ALU, write results
            3: begin rs1_reg = 1; rs2_reg = 2; rd_reg = 4; alu_ctrl_reg = 4'b0010; we_reg = 1; use_alu_res_reg = 1; end // ADD
            4: begin rs1_reg = 1; rs2_reg = 2; rd_reg = 5; alu_ctrl_reg = 4'b0110; we_reg = 1; use_alu_res_reg = 1; end // SUB
            5: begin rs1_reg = 1; rs2_reg = 2; rd_reg = 6; alu_ctrl_reg = 4'b0000; we_reg = 1; use_alu_res_reg = 1; end // AND
            6: begin rs1_reg = 1; rs2_reg = 2; rd_reg = 7; alu_ctrl_reg = 4'b0001; we_reg = 1; use_alu_res_reg = 1; end // OR
            7: begin rs1_reg = 1; rs2_reg = 2; rd_reg = 8; alu_ctrl_reg = 4'b0011; we_reg = 1; use_alu_res_reg = 1; end // XOR
            8: begin rs1_reg = 1; rs2_reg = 3; rd_reg = 9; alu_ctrl_reg = 4'b0100; we_reg = 1; use_alu_res_reg = 1; end // SLL
            9: begin rs1_reg = 1; rs2_reg = 3; rd_reg = 10; alu_ctrl_reg = 4'b0101; we_reg = 1; use_alu_res_reg = 1; end// SRL
            
            // Task 2c(iii): Perform a BEQ-style check using ALU Zero output (Checking if x1 == x1)
            10: begin rs1_reg = 1; rs2_reg = 1; rd_reg = 11; alu_ctrl_reg = 4'b0110; we_reg = 1; use_alu_res_reg = 0; imm_data_reg = 32'd1; is_beq_test = 1; end
            
            // Task 2c(iv): Test register read-after-write timing
            11: begin rd_reg = 12; imm_data_reg = 32'h0000BEEF; we_reg = 1; use_alu_res_reg = 0; end // RAW Write
            12: begin rs1_reg = 12; we_reg = 0; end // RAW Read
        endcase
    end

    // Result Assertions
    always @(posedge clk) begin
        if (state == WRITE_REGISTERS) begin
            case (test_idx)
                0: $display("Init x1: Wrote %h", write_data);
                1: $display("Init x2: Wrote %h", write_data);
                2: $display("Init x3: Wrote %h", write_data);
                3: $display("ADD Test (x1+x2): Wrote %h to x4  (Expected: 11111111)", write_data);
                4: $display("SUB Test (x1-x2): Wrote %h to x5  (Expected: 0F0F0F0F)", write_data);
                5: $display("AND Test (x1&x2): Wrote %h to x6  (Expected: 00000000)", write_data);
                6: $display("OR  Test (x1|x2): Wrote %h to x7  (Expected: 11111111)", write_data);
                7: $display("XOR Test (x1^x2): Wrote %h to x8  (Expected: 11111111)", write_data);
                8: $display("SLL Test (x1<<5): Wrote %h to x9  (Expected: 20202020)", write_data);
                9: $display("SRL Test (x1>>5): Wrote %h to x10 (Expected: 00808080)", write_data);
                10: $display("BEQ Test (x1==x1): Zero Flag = %b, Flag Reg x11 Write Enable = %b", alu_zero, write_enable);
                11: $display("RAW Test: Wrote %h to x12", write_data);
                12: $display("RAW Test: Read  x12 = %h (Expected: 0000BEEF)", read_data1);
            endcase
        end
    end

endmodule