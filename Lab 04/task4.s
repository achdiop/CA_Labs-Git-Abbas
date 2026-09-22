main:
    addi x10, x0, 18      # Argument 1: a = 48
    addi x11, x0, 48      # Argument 2: b = 18
    addi sp, x0, 0x100    # Set stack pointer to 0x100 (my preference)           

    jal x1, gcd           # Call recursive gcd(48, 18)

    # Ecall to print
    addi x11, x10, 0
    li x10, 1             
    ecall

    j end                 # jump to end
gcd:
    addi sp, sp, -4       # Adjust stack pointer (sp) down by 4 bytes
    sw x1, 0(sp)          # Save the return address (ra) on the stack

    bne x11, x0, L1

    addi sp, sp, 4        # Pop the stack by 4 bytes  
    jalr x0, 0(x1)        # Return to caller
L1:
    # Calculate a % b (rem x5, x10, x11)
    div x5, x10, x11
    mul x5, x5, x11
    sub x5, x10, x5

    add x10, x0, x11      # New argument 'a' = old 'b'
    add x11, x0, x5       # New argument 'b' = old 'a % b'
    jal x1, gcd           # Call gcd(b, a % b)

    lw x1, 0(sp)          # Restore the original return address
    addi sp, sp, 4        # Pop the stack by 4 bytes
    jalr x0, 0(x1)        # Return to caller
end:
    j end