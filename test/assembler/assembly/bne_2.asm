ADDIU $a0, $a0, 16
ADDIU $a1, $a1, 433
ADDIU $v0, $v0, 1
BNE $a0, $a1, NotEqual
ADDIU $v0, $v0, 60
ADDIU $v0, $v0, 100
NotEqual:
JR $zero