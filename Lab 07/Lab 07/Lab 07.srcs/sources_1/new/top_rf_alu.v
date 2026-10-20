`timescale 1ns / 1ps

module top_rf_alu (
    input  wire        clk,
    input  wire        pbin,
    input  wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);
    wire        rst_clean;
    reg  [31:0] led_write_data = 32'd0;

    debouncer rst_db (.clk(clk), .pbin(pbin), .pbout(rst_clean));

    // LED output module (your existing one)
    switches led_writer (
        .clk(clk), .rst(rst_clean), .writeData(led_write_data),
        .writeEnable(1'b1), .readEnable(1'b0), .memAddress(30'd0),
        .readData(), .leds(physical_leds)
    );

    // ---- Switch mapping ----
    wire [3:0] A_in     = physical_sw[3:0];
    wire [3:0] B_in     = physical_sw[7:4];
    wire [3:0] alu_ctrl = physical_sw[15:12];

    // ---- Register file / ALU ----
    reg         rf_we;
    reg  [4:0]  rf_rd;
    reg  [31:0] rf_write_data;
    wire [31:0] rf_read_data1, rf_read_data2;
    wire [31:0] alu_result;
    wire        alu_zero;

    reg state;   // 0: load x1 with A, 1: load x2 with B

    RegisterFile u_rf (
        .clk(clk),
        .rst(rst_clean),
        .WriteEnable(rf_we),
        .rs1(5'd1),              // always read x1
        .rs2(5'd2),              // always read x2
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

    // Keep refreshing x1 and x2 from the switches
    always @(posedge clk or posedge rst_clean) begin
        if (rst_clean) begin
            state          <= 1'b0;
            rf_we          <= 1'b0;
            rf_rd          <= 5'd0;
            rf_write_data  <= 32'd0;
            led_write_data <= 32'd0;
        end else begin
            rf_we <= 1'b1;
            case (state)
                1'b0: begin
                    rf_rd         <= 5'd1;
                    rf_write_data <= {28'd0, A_in};
                    state         <= 1'b1;
                end
                1'b1: begin
                    rf_rd         <= 5'd2;
                    rf_write_data <= {28'd0, B_in};
                    state         <= 1'b0;
                end
            endcase
            led_write_data <= {16'd0, alu_result[15:0]};
        end
    end
endmodule