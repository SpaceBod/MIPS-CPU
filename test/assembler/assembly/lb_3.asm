ADDIU $a0, $a0, 4095   #
ADDIU $a0, $a0, 4095   #
ADDIU $a0, $a0, 4095   # a0 = 0x2ffd
ADDIU $a2, $a2, 0      # a2 = 0x00000
SUBU  $a2, $a2, $a0    # a2 = 0xffffd003
ADDIU $a1, $a1, 200    # a1 = 200
SW $a2, 0($a1)         # mem(200) = 0x03d0ffff
LB $v0, 2($a1)         # v0 = mem(202) = -48
JR $zero                   #