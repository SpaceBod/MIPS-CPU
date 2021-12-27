ADDIU $a0, $a0, 0
BGEZ $a0, GreaterEqualZero
ADDIU $v0, $v0, 80
ADDIU $v0, $v0, 100
GreaterEqualZero:
ADDIU $v0, $v0, 6
JR $zero