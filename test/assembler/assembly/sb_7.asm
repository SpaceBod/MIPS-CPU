ADDIU $a0, $a0, 11112
ADDIU $a1, $a1, 20000
SB $a0, 1($a1)
ADDIU $a0, $a0, 11112
SB $a0, 2($a1)
LBU $v0, 2($a1)
JR $zero
