ADDIU $a0, $a0, 4095   # a0 = 0x00FFF
ADDIU $a0, $a0, 4095   # a0 = 0x01FFE
ADDIU $a0, $a0, 4095   # a0 = 0x02FFD
ADDIU $a2, $a2, 0      # a2 = 0x00000
SUBU  $a2, $a2, $a0    # a2 = 0xffffd003
ADDIU $a1, $a1, 200    # a1 = 200
SW $a2, 0($a1)         # mem(200) = 0x03d0ffff
LB $v0, 1($a1)         # v0 = mem(201) = -1
JR $zero                #