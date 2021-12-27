ADDIU $a0, $a0, 4095   # a0 = 0x00FFF
ADDIU $a0, $a0, 4095   # a0 = 0x01FFE
ADDIU $a0, $a0, 4095   # a0 = 0x02FFD
SUBU  $a2, $a2, $a0    # a2 = 0xffffd003
ADDIU $a1, $a1, 200    # a1 = 200
SW $a2, 0($a1)         # mem(200) = 0x03d0ffff
LBU $v0, 2($a1)        # v0 = mem(202) = 208
JR $zero                 #