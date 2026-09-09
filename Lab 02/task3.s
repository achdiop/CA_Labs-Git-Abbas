li x24, 0x200       # Load base address of array a into x24
li x22, 0           # i = 0
li x5, 10           # loop limit = 10

# First loop: a[i] = i
loop1:
    bge x22, t0, end_loop1  # if i >= 10, exit loop
    slli x6, x22, 2         # calculate offset: i * 4 (4 bytes per int)
    add x6, x24, x6         # address of a[i] = base + offset
    sw x22, 0(x6)           # store value i into a[i]
    addi x22, x22, 1        # i++
    j loop1
end_loop1:

# Second loop: sum = sum + a[i]
li x22, 0           # reset i = 0
li x23, 0           # sum = 0

loop2:
    bge x22, t0, end_loop2  # if i >= 10, exit loop
    slli t1, x22, 2         # calculate offset: i * 4
    add t1, x24, t1         # address of a[i] = base + offset
    lw t2, 0(t1)            # load a[i] into t2
    add x23, x23, t2        # sum = sum + a[i]
    addi x22, x22, 1        # i++
    j loop2
end_loop2:
    j end_loop2