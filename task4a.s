.text
.globl main
main:
    li x10, 0x78786464      # Initialize x10 with the value 0x78786464
    li x11, 0xA8A81919      # Initialize x11 with the value 0xA8A81919
    
    sw x10, 0x100(x0)       # Store the value in x10 at memory address 0x100
    sw x11, 0x1F0(x0)       # Store the value in x11 at memory address 0x1F0
    lhu x12, 0x100(x0)      # Load halfword from address 0x100 into x12
    lh x13, 0x1F0(x0)       # Load halfword from address 0x1F0 into x13
    lb x14, 0x1F0(x0)       # Load byte from address 0x1F0 into x14
end:
    j end