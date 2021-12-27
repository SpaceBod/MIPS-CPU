ADDIU $a0, $a0, 18 #a0 = 0x12 = 0b00010010
ADDIU $a1, $a1, 2 #a1 = 0x2 = 0b10
SRLV $v0, $a0, $a1 #v0 = 0b100 = 4
JR $zero