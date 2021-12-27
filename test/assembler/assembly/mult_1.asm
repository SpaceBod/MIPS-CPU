ADDIU $a0, $a0, 32767         #        
ADDIU $a1, $a1, 32767        #
MULT $a0, $a1               #
MFLO $a3                    #
MULT $a3, $a1               #
MFLO $v0                    #
JR $zero                    #v0=1073840127