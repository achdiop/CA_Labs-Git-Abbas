# For test values
    li x10, 0x100         # Base address of v[]
    li x11, 3             # k = 3
    li x5, 5              
    sw x5, 12(x10)        # Store 5 on v[k]
    li x5, 6
    sw x5, 16(x10)        # Store 6 on v[k+1]

swap:
    slli x5, x11, 2       # Multiply index k by 8 (shift left 3 bits) for memory offset
    add x5, x10, x5       # Add offset to base address of v[] to get address of v[k]
    lw x6, 0(x5)          # Load v[k] into temporary register x6 (temp = v[k])
    lw x7, 4(x5)          # Load v[k+1] into temporary register x7 (8 bytes ahead)

    sw x7, 0(x5)          # Store v[k+1] into v[k]
    sw x6, 4(x5)          # Store temp (original v[k]) into v[k+1]

exit:
    j exit