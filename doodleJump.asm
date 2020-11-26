#####################################################################
#
# CSCB58 Fall 2020 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Michelle Kee, 1005254038
#
# Bitmap Display Configuration:
# - Unit width in pixels: 16					     
# - Unit height in pixels: 16
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). 
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

##########
# Display Notes
# Pixel address offsets range from 0 - 4092
# Platform length is 8

# Platform horizontal position range offset 0-96 [generate value from 0-24] Then multiply by 4

.data
	#Display Address
	displayAddress:	.word	0x10008000
	
	#Platform Positions
	platAh: .word 0
	platAv: .word 4
	platBh: .word 8
	platBv: .word 8
	platCh: .word 16
	platCv: .word 16
	platDh: .word 24
	platDv: .word 24
	#Platform Characteristic
	platLength: .word 8
	
	#Game colors
	skyColor: .word 0x00ffe5 #Cyan
	platColor: .word 0x0000ff #Blue
	
.text	


#Painting the background of the screen (all pixels)
PaintScreen:
	lw $t0, displayAddress	# $t0 stores the base address for display
	lw $t1, skyColor
	PaintPixel:
		beq $t0, 0x10009000, DoneScreen #Pixel out of display
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		j PaintPixel
	DoneScreen:

#Check if the platforms are still in display 
CheckPlatforms:
	

#Draw platforms on screen based on horizontal and vertical position, and their set length
PaintPlatforms:
	#Painting platform A
	lw $t0, platLength
	lw $t1, platColor
	lw $t2, platAh
	lw $t3, platAv
	#Multiply platAv (vertical pos) by 128
	sll $t4, $t3, 7 
	#Mutiply platAh (horizontal pos) by 4
	sll $t5, $t2, 2
	# 128(platAv) + 4(platAh)
	add $t6, $t5, $t4
	#Calculated offset + display start
	lw $t7, displayAddress
	add $t6, $t7, $t6
	#Counter to paint platA
	li $t9, 0
	PaintPlatA:
		beq $t9, $t0, DonePlatA
		sw $t1, 0($t6)
		#Increment loop counter
		addi $t9, $t9, 1
		#Increment pixel for platform
		addi $t6, $t6, 4 
		j PaintPlatA
	DonePlatA:
	
	
	
	
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
