.data
	numberPixel: .word 1,1,1, 1,0,1, 1,0,1, 1,0,1, 1,1,1,   1,1,0, 0,1,0, 0,1,0, 0,1,0, 0,1,0,   1,1,1, 0,0,1, 1,1,1, 1,0,0, 1,1,1,   1,1,1, 0,0,1, 1,1,1, 0,0,1, 1,1,1,   1,0,1, 1,0,1, 1,1,1, 0,0,1, 0,0,1,   1,1,1, 1,0,0, 1,1,1, 0,0,1, 1,1,1   1,1,1, 1,0,0, 1,1,1 1,0,1, 1,1,1,   1,1,1, 1,0,1, 0,0,1, 0,0,1, 0,0,1,   1,1,1, 1,0,1, 1,1,1, 1,0,1, 1,1,1,   1,1,1, 1,0,1, 1,1,1, 0,0,1, 0,0,1
	numberColor: .word 0xECEBDF
.text

main: 
	#Number to draw
	li $s0, 9
	move $t0, $s0
	#Load information on how to draw number
	la $t1, numberPixel
	#Set to the correct index*4 of the array
	mul $t0, $t0, 15	
	mul $t0, $t0, 4
	#Add it as offset to the array
	add $t2, $t1, $t0
	#Counter since it should go through 15 elements only
	li $t9, 0
	#Display Address to draw at
	move $t8, $gp
	#color
	lw $t7, numberColor
	#Count Row 
	li $t6, 0
	StartDrawingNumber:
		#Stop once this loop has ran 15 times
		beq $t9, 15, DoneDrawingNumber
		#Get element at index
		lw $t3, 0($t2)
		beq $t3, 0, Hole
		#Otherewise, draw something
		sw $t7, ($t8)
		Hole:
		addi $t6, $t6, 1
		#Add to display address accordingly. If it goes past 3 elements (new row), add 120, otherwise add 4 only
		beq $t6, 3, newNumberRow
		add $t8, $t8, 4
		j Added
		newNumberRow:
			add $t8, $t8, 120
			li $t6, 0
		Added:
		#At the end, add 4 to the offset.
		addi $t2, $t2, 4
		addi $t9, $t9, 1
		
		j StartDrawingNumber
	DoneDrawingNumber:
