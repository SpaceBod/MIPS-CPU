ADDIU $a0, $a0, 16
SUBU $a1, $a1, $a0
BGEZ $a1, GreaterEqualZero                    
ADDIU $v0, $v0, 100
GreaterEqualZero:
ADDIU $v0, $v0, 6
JR $zero