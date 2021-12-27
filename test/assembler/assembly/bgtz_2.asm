ADDIU $a0, $a0, 0
BGTZ $a0, GreaterZero
ADDIU $v0, $v0, 60
ADDIU $v0, $v0, 100
GreaterZero:
ADDIU $v0, $v0, 6
JR $zero            #v0=166