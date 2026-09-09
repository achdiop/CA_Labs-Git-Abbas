# ----------------------------------------------------------- Listing 3 ------------------------------------------------------------ #
# Assuming that variables f to j are in registers x19-x23.
# Initialize the registers to required values for testing.
li x22, 5  # i = 5
li x23, 6  # j = 6

li x20, 4  # g = 4
li x21, 3  # h = 3


bne x22, x23, Else 
add x19, x20, x21
beq x0, x0, Exit
Else: sub x19, x20, x21
Exit:
    j Exit
    