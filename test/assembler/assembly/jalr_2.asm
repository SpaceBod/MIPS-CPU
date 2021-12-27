ADDIU $v0, $0, 10   #
JAL 0xBFC00010           # 
ADDIU $v0, $v0, 1   # 
ADDIU $v0, $v0, 10  #                
ADDIU $zero, $zero, 20  #
JALR $t2, $zero       #
ADDIU $v0, $v0, 3   #
ADDIU $v0, $v0, 1   # 
ADDU $v0, $v0, $zero  #
JR $0               #v0=10