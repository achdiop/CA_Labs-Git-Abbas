.text
.globl main
main:
    li x20, 5                    # int a = 5
    
    addi x21, x0, 0              # int b = 0 + 0
    
    addi x20, x21, 32            # int a = b + 32
    
    # int d = (a + b) - 5
    add x22, x20, x21             # int c = a + b
    addi x22, x22, -5             # int c = c - 5

    # int e = ((a - d) + (b - a)) + d
    sub x6, x20, x22             # int p = a - d
    sub x7, x21, x20             # int q = b - a
    add x8, x6, x7               # int r = p + q
    add x23, x8, x22             # int s = r + d
    
    # int e = a + b + d + e
    add x23, x20, x23       # int e = a + e
    add x23, x21, x23       # int e = b + e
    add x23, x22, x23       # int e = d + e


end:
    j end