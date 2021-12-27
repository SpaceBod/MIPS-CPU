ADDIU $a0, $a0, 16
BLTZAL $a0, SmallerZero
ADDIU $v0, $v0, 60
ADDIU $v0, $v0, 100     # Skipped
SmallerZero:
ADDIU $v0, $v0, 3
JR $zero