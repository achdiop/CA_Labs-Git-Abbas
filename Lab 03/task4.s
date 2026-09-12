# For test values
li x10, 0x200          # Base address of x[]
li x11, 0x100          # Base address of y[]
li x19, 9              # Initial value of x19 = 9
li sp, 0x300          
    
li x5, 2
sb x5, 0(x11)          # Store 2 in y[0]
li x5, 4
sb x5, 1(x11)          # Store 4 in y[1]

strcpy:
    addi sp, sp, -8        # Adjust stack for 1 more item
    sw x19, 0(sp)          # Save x19
    add x19, x0, x0        # Initialize i = 0

strcpy_loop:
    add x5, x19, x11       # Get the address of y[i] (base y + i)
    lb x6, 0(x5)           # Load byte (char) from y[i] into x6 (unsigned)

    add x7, x19, x10       # Get the address of x[i] (base x + i)
    sb x6, 0(x7)           # Store byte (char) from x6 into x[i]

    beq x6, x0, strcpy_end # If the loaded byte is '\0' (0), exit the loop
    addi x19, x19, 1       # Increment i by 1 (i += 1)
    j strcpy_loop          # Jump back to the start of the loop

strcpy_end:
    lw x19, 0(sp)          # Restore register x19 from the stack
    addi sp, sp, 8         # Deallocate 8 bytes from the stack
exit:
    j exit