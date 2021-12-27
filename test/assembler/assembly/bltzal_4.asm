ADDIU $a0, $a0, 1
SUBU $a1, $a1, $a0
BLTZAL $a1, SmallerZero
ADDIU $v0, $v0, 60
ADDIU $v0, $v0, 100
SmallerZero:
ADDU $v0, $v0, $ra
JR $zero            #v0=