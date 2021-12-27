ADDIU $a0, $a0, 10
ADDIU $a1, $a1, 24
DIV $zero, $a0, $a1
MFLO $v0
ADDIU $v0, $v0, 1
JR $zero