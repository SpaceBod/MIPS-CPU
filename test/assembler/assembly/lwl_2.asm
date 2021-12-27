LUI $a0, 1024           #a0 = 0x04000000           
ADDIU $a0, $a0, 128     #a0 = 0x04000080
ADDIU $a1, $a1, 256     #a1 = 0x100
ADDIU $v0, $zero, 257   #v0=0x101
SW $a0, 0($a1)          #mem(256) = 0x80000004
LWL $v0, 2($a1)         #v0 = 0x00800101
JR $zero                #