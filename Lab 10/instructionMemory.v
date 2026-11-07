module instructionMemory #( 

    parameter OPERAND_LENGTH = 31 

)( 

    input [OPERAND_LENGTH:0] instAddress, 

    output reg [31:0] instruction 

); 

    reg [7:0] memory [0:255]; 
    integer i; 

    initial begin 
        for (i = 0; i < 256; i = i + 1) 
            memory[i] = 8'h00; 
        {memory[3], memory[2], memory[1], memory[0]} = 32'h00002137;  // 0x00: li sp, 0x00002000 
        {memory[7], memory[6], memory[5], memory[4]} = 32'h000015B7;  // 0x04: li a1, SW_ADDR 
        {memory[11], memory[10], memory[9], memory[8]} = 32'h00001637;  // 0x08: li a2, LED_ADDR (lui) 
        {memory[15], memory[14], memory[13], memory[12]} = 32'h00460613;  // 0x0C: li a2, LED_ADDR (addi) 
        {memory[19], memory[18], memory[17], memory[16]} = 32'h000016B7;  // 0x10: li a3, RST_ADDR (lui) 
        {memory[23], memory[22], memory[21], memory[20]} = 32'h00868693;  // 0x14: li a3, RST_ADDR (addi) 
        {memory[27], memory[26], memory[25], memory[24]} = 32'h0005A283;  // 0x18: WAIT_STATE: lw t0, 0(a1) 
        {memory[31], memory[30], memory[29], memory[28]} = 32'hFE028EE3;  // 0x1C: beq t0, x0, WAIT_STATE 
        {memory[35], memory[34], memory[33], memory[32]} = 32'h00028513;  // 0x20: mv a0, t0 
        {memory[39], memory[38], memory[37], memory[36]} = 32'h008000EF;  // 0x24: jal ra, COUNTDOWN_SUB 
        {memory[43], memory[42], memory[41], memory[40]} = 32'hFF1FF06F;  // 0x28: j WAIT_STATE 
        {memory[47], memory[46], memory[45], memory[44]} = 32'hFF010113;  // 0x2C: COUNTDOWN_SUB: addi sp, sp, -16 
        {memory[51], memory[50], memory[49], memory[48]} = 32'h00112623;  // 0x30: sw ra, 12(sp) 
        {memory[55], memory[54], memory[53], memory[52]} = 32'h00812423;  // 0x34: sw s0, 8(sp) 
        {memory[59], memory[58], memory[57], memory[56]} = 32'h00050413;  // 0x38: mv s0, a0 
        {memory[63], memory[62], memory[61], memory[60]} = 32'h00862023;  // 0x3C: COUNTDOWN_LOOP: sw s0, 0(a2) 
        {memory[67], memory[66], memory[65], memory[64]} = 32'h0006A303;  // 0x40: lw t1, 0(a3) 
        {memory[71], memory[70], memory[69], memory[68]} = 32'h02031263;  // 0x44: bne t1, zero, RESET_HIT 
        {memory[75], memory[74], memory[73], memory[72]} = 32'h002623B7;  // 0x48: li t2, DELAY (lui) 
        {memory[79], memory[78], memory[77], memory[76]} = 32'h5A038393;  // 0x4C: li t2, DELAY (addi) 
        {memory[83], memory[82], memory[81], memory[80]} = 32'hFFF38393;  // 0x50: DELAY_LOOP: addi t2, t2, -1 
        {memory[87], memory[86], memory[85], memory[84]} = 32'hFE039EE3;  // 0x54: bne t2, zero, DELAY_LOOP 
        {memory[91], memory[90], memory[89], memory[88]} = 32'hFFF40413;  // 0x58: addi s0, s0, -1 
        {memory[95], memory[94], memory[93], memory[92]} = 32'hFE8040E3;  // 0x5C: bgtz s0, COUNTDOWN_LOOP 
        {memory[99], memory[98], memory[97], memory[96]} = 32'h00062023;  // 0x60: sw zero, 0(a2) 
        {memory[103], memory[102], memory[101], memory[100]} = 32'h0080006F;  // 0x64: j ENDING 
        {memory[107], memory[106], memory[105], memory[104]} = 32'h00062023;  // 0x68: RESET_HIT: sw zero, 0(a2) 
        {memory[111], memory[110], memory[109], memory[108]} = 32'h00812403;  // 0x6C: ENDING: lw s0, 8(sp) 
        {memory[115], memory[114], memory[113], memory[112]} = 32'h00C12083;  // 0x70: lw ra, 12(sp) 
        {memory[119], memory[118], memory[117], memory[116]} = 32'h01010113;  // 0x74: addi sp, sp, 16 
        {memory[123], memory[122], memory[121], memory[120]} = 32'h00008067;  // 0x78: ret 
    end 

    always @(*) begin 
        instruction = {memory[instAddress + 3], 
                       memory[instAddress + 2], 
                       memory[instAddress + 1], 
                       memory[instAddress]}; 
    end 
endmodule 