ADDIU $a0, $a0, 64      
ADDIU $a1, $a1, 128     
SW $a0, 24($a1)         
LW $v0, 24($a1)         
JR $zero                