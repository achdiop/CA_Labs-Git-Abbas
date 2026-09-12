# For test cases
    li x10, 1 
    li x11, 2
    li x12, 3
    li x13, 4
    li sp, 0x200
    li x18, 8
    li x19, 9
    li x20, 10

leaf_example:
    addi sp, sp, -12      # Adjust stack pointer to allocate 24 bytes (for 3 registers)
    sw x20, 8(sp)         # Save register x20 (f) onto the stack
    sw x19, 4(sp)         # Save register x19 onto the stack
    sw x18, 0(sp)         # Save register x18 onto the stack

    add x18, x10, x11     # x18 = g + h
    add x19, x12, x13     # x19 = i + j
    sub x20, x18, x19     # f (x20) = (g + h) - (i + j)

    lw x18, 0(sp)         # Restore register x18 from the stack
    lw x19, 4(sp)         # Restore register x19 from the stack
    lw x20, 8(sp)         # Restore register x20 from the stack
    addi sp, sp, 12       # Deallocate 24 bytes from the stack
    
    # Return with ecall since no main function is shown.
    addi x11, x20, 0
    li x10, 1
    ecall
    
exit:
    j exit