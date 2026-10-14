`timescale 1ns / 1ps

module top_rf_alu (
    input  wire        clk,
    input  wire        pbin,
    input  wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);
    wire        rst_clean;
    wire [31:0] switch_data;
    reg  [31:0] led_write_data = 32'd0;    
    
    debouncer rst_db (.clk(clk), .pbin(pbin), .pbout(rst_clean));

    leds switch_reader (
        .clk(clk), .rst(rst_clean), .btns(16'd0), 
        .writeData(32'd0), .writeEnable(1'b0), .readEnable(1'b1), 
        .memAddress(30'd0), .switches(physical_sw), .readData(switch_data) 
    );

    switches led_writer (
        .clk(clk), .rst(rst_clean), .writeData(led_write_data),                     
        .writeEnable(1'b1), .readEnable(1'b0), .memAddress(30'd0),                     
        .readData(), .leds(physical_leds)           
    );

    // Fixed Operands
    localparam [31:0] CONST_A = 32'h10101010;
    localparam [31:0] CONST_B = 32'h01010101;

    // FSM States
    localparam STATE_X1  = 2'b00;
    localparam STATE_X2  = 2'b01;
    localparam STATE_ALU = 2'b10;

    reg [1:0] state = STATE_X1;

    // Register File & ALU Control Signals
    reg         rf_we;
    reg  [4:0]  rf_rs1, rf_rs2, rf_rd;
    reg  [31:0] rf_write_data;
    wire [31:0] rf_read_data1, rf_read_data2;
    
    wire [31:0] alu_result;
    wire        alu_zero;
    reg  [3:0]  alu_ctrl;


    RegisterFile u_rf (
        .clk(slow_clk),
        .rst(rst_clean),
        .WriteEnable(rf_we),
        .rs1(rf_rs1),
        .rs2(rf_rs2),
        .rd(rf_rd),
        .WriteData(rf_write_data),
        .ReadData1(rf_read_data1),
        .readData2(rf_read_data2)
    );

    ALU_32bit u_alu (
        .A(rf_read_data1),
        .B(rf_read_data2),
        .ALUControl(alu_ctrl),
        .ALUResult(alu_result),
        .Zero(alu_zero)
    );

    always @(posedge slow_clk or posedge rst_clean) begin
        if (rst_clean) begin
            state <= STATE_X1;
            rf_we <= 0;
            led_write_data <= 32'd0;
        end else begin
            case (state)
                // Write Constant A to register x1
                STATE_X1: begin
                    rf_rs1 <= 5'd0; rf_rs2 <= 5'd0;
                    rf_rd <= 5'd1; 
                    rf_write_data <= CONST_A;
                    rf_we <= 1'b1;
                    alu_ctrl <= 4'b0000;
                    led_write_data <= {14'd0, STATE_X1};
                    
                    state <= STATE_X2;
                end
                
                // Write Constant B to register x2
                STATE_X2: begin
                    rf_rd <= 5'd2; 
                    rf_write_data <= CONST_B;
                    rf_we <= 1'b1;
                    led_write_data <= {14'd0, STATE_X2};
                    
                    state <= STATE_ALU;
                end
                
                STATE_ALU: begin
                    // Read from x1 and x2
                    rf_rs1 <= 5'd1; 
                    rf_rs2 <= 5'd2;
                    
                    // Map switches to control signals
                    alu_ctrl <= switch_data[3:0];
                    rf_rd    <= switch_data[8:4];
                    rf_we    <= switch_data[15];
                    
                    // Write ALU result back to Register File
                    rf_write_data <= alu_result;
                    
                    // Display Data on LEDs
                    led_write_data <= {16'd0, alu_result[15:0]};
                    
                    state <= STATE_ALU;
                end
                
                default: state <= STATE_X1;
            endcase
        end
    end

endmodule