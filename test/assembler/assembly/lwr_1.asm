LUI $a0, 1024           #
ADDIU $a0, $a0, 128     # a0 = 0x04000080
ADDIU $a1, $a1, 256     #a1 = 0x100
SW $a0, 0($a1)          #mem(256) = 0x80000004
LWR $v0, 0($a1)         #v0 = 0x00000004
JR $zero                #