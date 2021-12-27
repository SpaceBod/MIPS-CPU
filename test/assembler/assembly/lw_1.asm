ADDIU $a0, $a0, 64      #a0 = 64
ADDIU $a1, $a1, 128     #a1 = 128
SW $a0, 0($a1)          #mem(128) = 64                  
LW $v0, 0($a1)          #v0 = 64                 
JR $zero                                  