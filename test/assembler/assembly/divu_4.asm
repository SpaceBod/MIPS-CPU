ADDIU $a0, $zero, 0         #
ADDIU $a2, $zero, 5         #
SUBU  $a0, $a0, $a2       #$a0 = -5
ADDIU $a1, $a1, 4         #
DIVU  $a0, $a1            # Hi = -5%4  LO = -5/4
MFLO  $v0                 #
JR    $zero               #v0=1073741822
