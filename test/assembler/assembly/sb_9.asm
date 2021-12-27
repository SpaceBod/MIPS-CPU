ADDIU $a0, $a0, 128
ADDIU $a1, $a1, 256
SB $a0, -3($a1)
LBU $a2, 3($a1)
SB $a0, 3($a1)
LBU $v0, 3($a1)
ADDU $v0, $v0, $a2
JR $zero