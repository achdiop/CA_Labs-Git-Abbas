# ----------------------------------------------------------- Listing 4 ------------------------------------------------------------ #
# Assuming that variables i and k in x22 and x24, and the base address of save in x25.
# Initialize the registers to required values for testing.
li x22, 0    # i = 0
li x24, 2    # k = 2
li x25, 0x100 # Base address = 0x100
# Store the array save = {2, 2, 4, 2}
li x31, 2 
sw x31, 0(x25)
li x31, 2 
sw x31, 4(x25)
li x31, 4 
sw x31, 8(x25)
li x31, 2
sw x31, 12(x25)

Loop:
    slli x10, x22, 2   # Temp reg x10 = i * 4
    add x10, x10,x25   # x10 = address + save[i]
    lw x9, 0(x10)      # Temp reg x9 = save[i]
    bne x9, x24, Exit  # Go to exit if save[i] != k
    addi x22, x22,1    # i = i + 1
    beq x0, x0, Loop   # Go to loop
Exit:
    j Exit