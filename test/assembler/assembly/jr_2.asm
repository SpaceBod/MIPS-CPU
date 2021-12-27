ADDIU $v0, $0, 10   #
JAL Equal           #
ADDIU $v0, $v0, 1   #
ADDIU $v0, $v0, 10  #
Equal:                
ADDIU $ra, $ra, 24  #
JR $ra             #
ADDIU $v0, $v0, 3   #
ADDIU $v0, $v0, 1   #
JR $zero            #v0=4194346