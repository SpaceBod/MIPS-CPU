ADDIU $a0, $a0, 32767          #
SUBU $a1, $a1, $a0          #
MULTU $a0, $a1               #
MFHI $v0                    #
JR $zero                    #v0=32766