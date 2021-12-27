ADDIU $a0, $a0, 1   # a0 = 1
ADDIU $a1, $a1, 200 # a1 = 200
SB $a0, 0($a1)      # mem(200) = 1
SB $a0, 1($a1)      # mem(201) = 1
SB $a0, 2($a1)      # mem(202) = 1
SB $a0, 3($a1)      # mem(203) = 1
LW $v0, 0($a1)      # v0 = mem(200)
JR $zero