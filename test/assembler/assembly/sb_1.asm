ADDIU $a0, $a0, 128
ADDIU $a1, $a1, 256
SB $a0, 0($a1)
LBU $v0, 0($a1)
JR $zero