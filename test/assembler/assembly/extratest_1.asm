ADDIU $a0, $0, 24       #a0=24
ADDIU $a1, $0, 0x100        #a1=256
BGEZ $a0, greaterthanzero    #a0>0 this will be executed
ADDIU $a3, $0, 3
greaterthanzero:        #skipped
JAL 0xBFC00014          #executed
ADDIU $t0, $0, 24       #skipped
ADDIU $t1, $0, 3        #t1=3
SLLV $v0, $a0, $t1      #v0=24*(2^3)=24*8=192
SLTIU $t2, $v0, 466     #t2=1
MULT $v0, $v0           #192*192=36864
MFLO $v0                #v0=36864=0x00009000
SW $v0, 0($a1)          #mem(256)=0x00900000
LWR $v0, 2($a1)         #v0=0x00000090
JR  $zero               #