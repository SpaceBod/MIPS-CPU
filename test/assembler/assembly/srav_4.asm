LUI $a0, 32768 #a0 = 0x80000000
ADDIU $a1, $a1, 18 #a1 = 0x12
SRAV $v0, $a0, $a1 #v0 = 0xffffe000
JR $zero