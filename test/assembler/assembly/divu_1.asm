ADDIU $a0, $zero, 12 #a0 = 12
ADDIU $a1, $zero, 2  #a1 = 2
DIVU $a0, $a1 #lo = 12/2 = 6
MFLO $v0 #v0 = 6
JR $zero