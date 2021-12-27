ADDIU $a0, $a0, 10
SUBU $a1, $a1, $a0
DIV $zero, $a0, $a1
MFLO $v0
JR $zero            #v0= -1 = 4294967295(unsigned)