LUI $a0, 0xF000      # a0 = 0xF0000000
SLTI $v0, $a0, 10    # v0 = 1 <= -1 = 0
XORI $v0, $v0, 31
JR $zero