ADDIU $a0, $a0, 4         #
ADDIU $a1, $a1, 0         #
ADDIU $a2, $a2, 5         #
SUBU  $a1, $a1, $a2       # $a1 = -5
DIVU  $a0, $a1            # Hi = 4  LO = 0
MFHI  $v0                 #v0 = 4
JR    $zero               #