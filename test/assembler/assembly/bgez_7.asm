ADDIU $a0, $a0, 19
SUBU $t0, $t0, $a0
loop:
BGEZ $t0, exit
ADDIU $t0, $t0, 1
ADDIU $v0, $v0, 8
J loop
exit:
JR $zero