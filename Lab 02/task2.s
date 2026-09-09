# Initialization of b (x22), c (x23), and x (x20) for testing
li x22, 10          # b = 10
li x23, 5           # c = 5
li x20, 2           # x = 2 (Test case)

# Switch cases
li t0, 1
beq x20, t0, case1  # if x == 1, branch to case1
li t0, 2
beq x20, t0, case2  # if x == 2, branch to case2
li t0, 3
beq x20, t0, case3  # if x == 3, branch to case3
li t0, 4
beq x20, t0, case4  # if x == 4, branch to case4
j default           # else branch to default

case1:
    add x21, x22, x23   # a = b + c
    j end
case2:
    sub x21, x22, x23   # a = b - c
    j end
case3:
    slli x21, x22, 1    # a = b * 2 (shift left by 1)
    j end
case4:
    srai x21, x22, 1    # a = b / 2 (arithmetic shift right by 1)
    j end
default:
    li x21, 0           # a = 0
end:
    j end