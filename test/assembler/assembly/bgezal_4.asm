ADDIU $a0, $a0, 126
SUBU $a1, $a1, $a0
BGEZAL $a1, GreaterEqualZero
ADDIU $v0, $v0, 80      
ADDIU $v0, $v0, 100
GreaterEqualZero:
ADDIU $v0, $v0, 3
JR $zero