# Test values
li x10, 4
jal x1, fact
addi x11, x10, 0
li x10, 1
ecall
j end

fact:
    li x5, 1
    loop:
        bge x0, x10, end_loop
        mul x5, x5, x10
        addi x10, x10, -1
        j loop
    end_loop:
        addi x10, x5, 0
        jalr x0, 0(x1)
end:
    j end

