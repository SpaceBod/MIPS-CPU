ADDIU $a0, $a0, 555
ADDIU $a1, $a1, 444
MULTU $a0, $a1
MFLO $v0
MFHI $a2
ADDU $v0, $v0, $a2
JR $zero