addiu $t0, $zero, 5 
addiu $t1, $t1, 1 
LOOP: 
mult $t1, $t0
mflo $t1 
addiu $t0, $t0, -1 
bgtz $t0, LOOP
addu $v0, $zero, $t1
jr $zero