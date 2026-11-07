# Placeholders
.equ SW_ADDR,  0x00000200  
.equ LED_ADDR, 0x00000204  
.equ RST_ADDR, 0x00000208


.text
.globl main

main:
    # Initialization
    li sp, 0x0000100
    li a1, SW_ADDR
    li a2, LED_ADDR
    li a3, RST_ADDR

    # Test case
    li t0, 4
    sw t0, 0(a1) 

WAIT_STATE:
    # Input Waiting State
    lw t0, 0(a1)
    beq t0, x0, WAIT_STATE
    
    # Transition to Countdown
    mv a0, t0
    jal ra, COUNTDOWN_SUB

    # Return to Wait State
    j WAIT_STATE

# COUNTDOWN_SUB - a0 (Initial count value)
COUNTDOWN_SUB:
    # Stack Usage
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    
    mv s0, a0

COUNTDOWN_LOOP:
    # LED Update
    sw s0, 0(a2)
    
    # Reset Detection
    lw t1, 0(a3)
    bne t1, zero, RESET_HIT

    # Clock Delay
    # li t2, DELAY_CYCLES
DELAY_LOOP:
    # Decrement Logic
    addi s0, s0, -1
    bgtz s0, COUNTDOWN_LOOP
    
    # Normal Exit
    sw zero, 0(a2)
    j ENDING

RESET_HIT:
    # Reset Behavior
    sw zero, 0(a2)

ENDING:
    # Stack Usage (Restore & Return)
    lw s0, 8(sp)
    lw ra, 12(sp) 
    addi sp, sp, 16 
    ret 