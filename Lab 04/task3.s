# Test case for values
li x10, 0x100
li x11, 6
li t1, 5
sw t1, 0(x10)
li t1, 4
sw t1, 4(x10)
li t1, 6
sw t1, 8(x10)
li t1, 3
sw t1, 12(x10)
li t1, 8
sw t1, 16(x10)
li t1, 7
sw t1, 20(x10)
jal x1, bubble
j end
bubble:
    beq x10, x0, done     # if a == NULL
    beq x11, x0, done     # if len == 0
    add x5, x0, x0        # i = 0
outer:
    bge x5, x11, done     # if i >= len, return
    add x6, x5, x0        # j = i
inner:
    bge x6, x11, next_i   # if j >= len, next i
    slli x28, x5, 2       # i offset
    add x28, x10, x28     # &a[i]
    lw x29, 0(x28)        # a[i]
    slli x30, x6, 2       # j offset
    add x30, x10, x30     # &a[j]
    lw x31, 0(x30)        # a[j]
    bge x29, x31, skip    # if a[i] >= a[j], skip swap
    sw x31, 0(x28)        # a[i] = a[j]
    sw x29, 0(x30)        # a[j] = temp
skip:
    addi x6, x6, 1        # j++
    jal x0, inner
next_i:
    addi x5, x5, 1        # i++
    jal x0, outer
done:
    jalr x0, 0(x1)
end:
    j end