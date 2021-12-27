ADDIU $a0, $a0, 10
ADDIU $a1, $a1, 5
SUBU $a1, $0, $a1
DIV $zero, $a0, $a1
MFLO $v0
JR $zero        #v0=-2 =4294967294(unsigned)