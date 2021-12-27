ADDIU $a1, $a1, 4095   # a1 = 0xFFF
ADDIU $a1, $a1, 4095   # a1 = 0x1FFE
ADDIU $a1, $a1, 4095   # a1 = 0x2FFD
ADDIU $a2, $a2, 200    # a2 = 200
SW $a1, 0($a2)         # mem(200) = 0xfd2f0000
LB $v0, 2($a2)         # 
JR $zero               #v0 = mem(202) = 47