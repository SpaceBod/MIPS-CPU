ADDIU $a0, $a0, 2
BGEZ $a0, GreaterEqualZero
ADDIU $v0, $v0, 50
ADDIU $v0, $v0, 100     #
GreaterEqualZero:
ADDIU $v0, $v0, 6
JR $zero