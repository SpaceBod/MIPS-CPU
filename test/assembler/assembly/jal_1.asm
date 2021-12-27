ADDIU $v0, $v0, 10
JAL 0xBFC0000C
ADDIU $v0, $v0, 1000
ADDU $v0, $ra, $v0      #$zero=4194312
JR $zero                #$v0=4194322