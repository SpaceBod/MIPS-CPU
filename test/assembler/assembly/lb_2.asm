ADDIU $a0, $a0, 4095   # a0 = 0xFFF
ADDIU $a0, $a0, 4095   # a0 = 0x1FFE
ADDIU $a0, $a0, 4095   # a0 = 0x2FFD
ADDIU $a1, $a1, 200    # a1 = 200
SW $a0, 0($a1)         # mem(200) = 0xfd2f0000
LB $v0, 3($a1)         # v0 = mem(203) = 0xfd
JR $zero                  #