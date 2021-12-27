ADDIU $a1, $a1, 1   # a1 = 1
ADDIU $a0, $a0, 3   # a0 = 3
SLT $v0, $a1, $a0    # v0 = 1 <= 3 = 1
JR $zero