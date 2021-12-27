ADDIU $a0, $a0, 32767         #        
ADDIU $a1, $a1, 32767        #
MULTU $a0, $a1               #
MFLO $a3                    #
MULTU $a3, $a1               #
MFHI $v0                    #
JR $zero                    #v0=8191