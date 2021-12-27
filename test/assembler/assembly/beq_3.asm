ADDIU $v0, $v0, 1
BEQ $zero, $zero, Equal
ADDIU $v0, $v0, 60
ADDIU $v0, $v0, 100
Equal:
JR $zero