ADDIU $a0, $a0, 4095   # a0 = 0x00FFF
ADDIU $a0, $a0, 4095   # a0 = 0x01FFE
ADDIU $a0, $a0, 4095   # a0 = 0x02FFD
ADDIU $a0, $a0, 4095   # a0 = 0x03FFC
ADDIU $a0, $a0, 4095   # a0 = 0x04FFB
SUBU  $a2, $a2, $a0    # a2 = 0xffffb005
ADDIU $a1, $a1, 200    # a1 = 200
SW $a2, 0($a1)         # mem(200) = 0x05B0FFFF 
LH $v0, 0($a1)         # v0 = mem(200) = 0xFFFF =  -20475
JR $zero                 #