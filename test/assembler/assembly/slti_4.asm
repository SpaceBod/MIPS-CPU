ADDIU $a0, $a0, 10       # a0 = 10
SLTI $v0, $a0, 10    # v0 = 1 <= -1 = 0
XORI $v0, $v0, 15
JR $zero