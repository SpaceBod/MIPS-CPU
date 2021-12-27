ADDIU $v0, $0, 10   
JAL 0xBFC00010
ADDIU $v0, $v0, 12
ADDIU $v0, $v0, 19              
ADDIU $ra, $ra, 28
JALR $t2, $ra
ADDIU $v0, $v0, 34
ADDIU $v0, $v0, 18
ADDU $v0, $v0, $t2
SUBU $v0, $v0, $ra 
JR $0               #$v0=10 - 0xbfc0008 - 28 + 0xbfc00000 + 28