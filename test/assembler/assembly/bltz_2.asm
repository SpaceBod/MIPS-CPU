ADDIU $a0, $a0, 0
BLTZ $a0, SmallerZero
ADDIU $v0, $v0, 60
ADDIU $v0, $v0, 100
SmallerZero:
ADDIU $v0, $v0, 3
JR $zero