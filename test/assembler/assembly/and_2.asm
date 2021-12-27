LUI $a0, 1024                     #
ADDIU $a0, $a0, 1024              #
LUI $a1, 1024                     #
ADDIU $a1, $a1, 4095              #
AND $v0, $a0, $a1                 #
JR $zero                          #