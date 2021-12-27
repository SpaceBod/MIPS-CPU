ADDIU $a0, $a0, 64      #0x24840040
ADDIU $a1, $a1, 128     #0x24A50080
SW $a0, 0($a1)          #0xACA40000                    saves a word from a register into RAM. a = RAM.Memory[$a1+0]=$a0
LW $v0, 0($a1)          #0x8CA20000                    loads a word from memory into a register.$v0=Memory[$a1+0]
JR $zero                #0x00000008                    always jump to this so CPU knows to stop