li x7, 0                # i = 0
li x5, 2                # a = 2
li x6, 3                # b = 3
li x10, 0x100           # Base address of D

outer_loop:
    bge x7, x5, end_outer   # if i >= a, exit outer loop
    li x29, 0               # j = 0

inner_loop:
    bge x29, x6, end_inner  # if j >= b, exit inner loop
    
    # Calculate address of D[4*j]
    # Index is 4*j. Byte offset = (4*j) * 4 bytes/word = 16 * j
    slli x31, x29, 4         # x31 = j * 16 (shift left by 4)
    add x31, x10, x31        # x30 = Base address of D + offset
    
    # Compute i + j and store
    add x30, x7, x29         # t2 = i + j
    sw x30, 0(x31)            # D[4*j] = i + j
    
    addi x29, x29, 1        # j++
    j inner_loop

end_inner:
    addi x7, x7, 1          # i++
    j outer_loop

end_outer:
    j end_outer