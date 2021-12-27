ADDIU $a0, $a0, 19
BGEZAL $a0, GreaterEqualZero
ADDIU $v0, $v0, 80      
ADDIU $v0, $v0, 100     
GreaterEqualZero:
ADDIU $v0, $v0, 8
JR $zero