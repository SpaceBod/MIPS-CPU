ADDIU $a1, $a1, 4095   # a1 = 0xFFF
ADDIU $a1, $a1, 4095   # a1 = 0x1FFE
ADDIU $a1, $a1, 4095   # a1 = 0x2FFD
ADDIU $a1, $a1, 4095   # a1 = 0x3FFC
ADDIU $a1, $a1, 4095   # a1 = 0x4FFB
ADDIU $a2, $a2, 200    # a2 = 200
SW $a1, 0($a2)         # mem(200) = 0xFB4F0000
LH $v0, 0($a2)         # v0 = mem(200) = 0
JR $zero                #