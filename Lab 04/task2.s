main:        # Test case for the values
li x10, 5           # num = 4
li sp, 0x100        # Initializing sp
jal x1, nrti        # Jump to function
addi x11, x10, 0    # setting up ecall output
li x10, 1
ecall
j end

nrti:
    addi sp, sp -8        # adjust stack for 2 items
    sw x1, 4(sp)          # save return address
    sw x10, 0(sp)         # save argument num
    
    addi x5, x0, 1        # x5 = 1
    bgt x10, x5, L1       # if (num) > 1, go to L1

    li x10, 1             # return 1
    addi sp, sp, 8        # pop stack
    jalr x0, 0(x1)        # return
L1:
    addi x10, x10, -1     # argument = num - 1
    jal x1, nrti          # recursive call

    addi x6, x10, 0       # save result of sum(num-1)
    lw x10, 0(sp)         # restore original num
    lw x1, 4(sp)          # restore return address
    addi sp, sp, 8        # pop stack

    add x10, x10, x6      # num + sum(num - 1)
    jalr x0, 0(x1)        # return
end:
    j end