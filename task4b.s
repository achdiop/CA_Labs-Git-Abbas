.text
.globl main
main:
    li x10, 0x100   # Initialize x10 with the value 0x100
    li x20, 0x200   # Initialize x20 with the value 0x200
    li x30, 0x300   # Initialize x30 with the value 0x300

    # Uncomment the following lines to initialize the memory locations with some values
    li x1, 1
    li x2, 11
    sb x1, 0(x10)
    sb x2, 0(x20)

    li x1, 2
    li x2, 12
    sb x1, 1(x10)
    sb x2, 2(x20)

    li x1, 3
    li x2, 13
    sb x1, 2(x10)
    sb x2, 4(x20)

    li x1, 4
    li x2, 14
    sb x1, 3(x10)
    sb x2, 6(x20)
    
    # For i = 0
    lb x5, 0(x10)   # Load byte from address 0x100 into x5
    lh x6, 0(x20)   # Load halfword from address 0x200 into x6
    add x7, x5 ,x6  # Add the values in x5 and x6
    sw x7, 0(x30)   # Store the value in x7 at memory address 0x300

    # For i=1
    lb x5,1(x10)    # Load byte from address 0x101 into x5
    lh x6,2(x20)    # Load halfword from address 0x202 into x6
    add x7,x5,x6    # Add the values in x5 and x6
    sw x7, 4(x30)   # Store the value in x7 at memory address 0x304

    # For i=2
    lb x5,2(x10)    # Load byte from address 0x102 into x5
    lh x6,4(x20)    # Load halfword from address 0x204 into x6
    add x7,x5,x6    # Add the values in x5 and x6
    sw x7, 8(x30)   # Store the value in x7 at memory address 0x308

    # For i=3
    lb x5,3(x10)    # Load byte from address 0x103 into x5
    lh x6,6(x20)    # Load halfword from address 0x206 into x6
    add x7,x5,x6    # Add the values in x5 and x6
    sw x7, 12(x30)  # Store the value in x7 at memory address 0x30C
end:
    j end