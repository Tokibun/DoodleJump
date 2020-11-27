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
	platOffset: .word 0, 896, 1920, 2944, 3968
	#Platform Characteristic
	platLength: .word 8
	
	#Game colors
	skyColor: .word 0x00ffe5 #Cyan
	platColor: .word 0x0000ff #Blue
	
	
	promptA: .asciiz "\n\n INDEX:"
	promptB: .asciiz "\n Iteration:"
	
.text	
	#RandomlyGenerate platform A's position
	#RandomlyGenerate platform B's position
	#RandomlyGenerate platform C's position


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
	lw $t0, platLength
	lw $t1, platColor
	#Display Start
	lw $t2, displayAddress
	#Get address of plaform array
	la $t3, platOffset
	#Index of platform array * 4
	li $t4, 0
	PlatformsLoop:
		#Get address of array at certain index
		add $t5, $t3, $t4
		#Access certain element of platOffset array
		lw $t6, 0($t5)	
		#Add offset to displayAddress
		add $t6, $t6, $t2
		#Counter to paint a platform to full length
		li $t9, 0
		PaintPlatA:
			beq $t9, $t0, DonePlatA
			#Draw platform		
			sw $t1, 0($t6)
			#Increment loop counter
			addi $t9, $t9, 1
			#Increment adress for next pixel of platform
			addi $t6, $t6, 4			
			j PaintPlatA
		DonePlatA:
			addi $t4, $t4, 4
			#Maximum index of platform array = #platform*4 - 4
			bne $t4, 20, PlatformsLoop

Exit:
	li $v0, 10 # terminate the program gracefully
	syscall	

#Generate leftmost h position for a platform (0-24)
GeneratePlatformPosition:
	li $v0, 42
	li $a0, 0
	li $a1, 24
	syscall
	jr $ra



	

