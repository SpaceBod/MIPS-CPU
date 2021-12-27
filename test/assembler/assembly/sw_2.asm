ADDIU $a0, $a0, 64      #0x24840040
ADDIU $a1, $a1, 128     #0x24A50080
SW $a0, 24($a1)         #0xACA40018
LW $v0, 24($a1)         #0x8CA20018
JR $zero                #0x00000008