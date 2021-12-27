ADDIU $a0, 55555          # a0 = 0x0000D903
ADDIU $a0, $a0, 111     # a0 = a0 + 111 = 0x0000D972
ADDIU $a1, $a1, 300     # a1 = 300
SH $a0, 0($a1)          
LH $v0, 0($a1)          #v0 = 0xd972
JR $zero