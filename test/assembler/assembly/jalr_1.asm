ADDIU $v0, $v0, 12        # jump to mem[4]
JALR  $zero                 #
ADDIU $v0, $v0, 5         #
ADDIU $v0, $v0, 5         #
JR $zero                  # $v0 should be 12
# And link current pc + 4 to $zero 