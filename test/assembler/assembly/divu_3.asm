ADDIU $a0, $zero, 0         #a0 = 0
ADDIU $a2, $zero, 5         #a2 = 5
SUBU  $a0, $a0, $a2       #a0 = -5
ADDIU $a1, $zero, 4         #a1 = 4
DIVU  $a0, $a1            # Hi = -5%4  LO = -5/4
MFHI  $v0                 #v0 = 3
JR    $zero               #