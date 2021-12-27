ADDIU $a0, $a0, 11
BGEZAL $a1, GreaterEqualZero
ADDIU $v0, $v0, 100
GreaterEqualZero:
ADDU $v0, $v0, $ra
JR $zero        #v0=BFC00008=3217031176