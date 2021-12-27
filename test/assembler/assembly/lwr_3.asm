LUI $a0, 0x1020           #a0 = 0x10200000
ADDIU $a0, $a0, 0x3040     #a0 = 0x10203040
ADDIU $a1, $a1, 256     #a1 = 0x256
SW $a0, 0($a1)          #mem(256) = 0x40302010
LUI $v0, 0x0102         #v0 = 0x01020000
LWR $v0, 1($a1)        #v0 = 0x01021020
JR $zero               