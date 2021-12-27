ADDIU $a1, $a1, 3         #
ADDIU $v0, $v0, 5         #
J 0xBFC00010                   #
ADDIU $v0, $v0, 5         #
NOP
JR $zero                 # $v0 should be 5