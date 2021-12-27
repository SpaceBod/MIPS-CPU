ADDIU $a0, $a0, 55555
ADDIU $a0, $a0, 111 # a0 = 0xd972
ADDIU $a1, $a1, 3999
SH $a0, 1($a1) # mem(4000) = 0x0000d972
ADDIU $a1, $a1, -2
LH $v0, 3($a1) #v0 = 0000
JR $zero