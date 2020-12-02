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
# Platform horizontal position range offset 0-88 [generate value from 0-22] Then multiply by 4
# Platform offset positions are based of leftmost point of platform

# Player offset position is bottom left of character

##Other Notes

.data
	
	#Display Address
	displayAddress:	.word	0x10008000
	
	#Platform Positions
	platOffset: .word 128, 896, 1920, 2944, 4008#3968
	#Platform Characteristic
	platLength: .word 10
	
	#Player Position
	playerOffset: .word 3900 #4028
	
	#Game colors
	skyColor: .word 0xDDFFFB #LightBlue-NearWhite
	platColor: .word 0xFFACF6 #Pink
	playerColor: .word 0x5CFFBE #Green
	numberColor: .word 0xECEBDF
	
	#Information to draw the score number
	numberPixel: .word 1,1,1, 1,0,1, 1,0,1, 1,0,1, 1,1,1,   
	1,1,0, 0,1,0, 0,1,0, 0,1,0, 0,1,0,   
	1,1,1, 0,0,1, 1,1,1, 1,0,0, 1,1,1,   
	1,1,1, 0,0,1, 1,1,1, 0,0,1, 1,1,1,   
	1,0,1, 1,0,1, 1,1,1, 0,0,1, 0,0,1,   
	1,1,1, 1,0,0, 1,1,1, 0,0,1, 1,1,1   
	1,1,1, 1,0,0, 1,1,1 1,0,1, 1,1,1,   
	1,1,1, 1,0,1, 0,0,1, 0,0,1, 0,0,1,   
	1,1,1, 1,0,1, 1,1,1, 1,0,1, 1,1,1,   
	1,1,1, 1,0,1, 1,1,1, 0,0,1, 0,0,1
.text	

Launch:
	#Wait for user to hit s to start
	lw $t8, 0xffff0000 
	#Goes out of label if nothing is pressed
	beq $t8, 0, Wait
	#This point on means something is pressed, check what is pressed
	lw $t2, 0xffff0004 
	#Check if s is pressed
	bne $t2, 0x73, Wait
	j Start
	#Sleep
	Wait:
		jal Sleep	
	j Launch
	

Start:
	#Counter for how much a player can jump
	li $a3, 10
	#Register to save what platform the screen needs to scroll past (base platform is at index 5 rn)
	li $a2, 16
	#RandomlyGenerate all platform's positions (At the beginning of game)
	#INITIAL PLATFORM POSITIONS
	#Basic addresses of platform array that will not change
	#Get address of plaform array
	la $t1, platOffset
	li $t0, 384#128
	sw $t0, 0($t1)
	li $t0, 1152#896
	sw $t0, 4($t1)
	li $t0, 2176#1920
	sw $t0, 8($t1)
	li $t0, 3200#2944
	sw $t0, 12($t1)
	li $t0, 4008
	sw $t0, 16($t1)
	#INITIAL PLAYER POSITION
	li $t0, 3900
	sw $t0, playerOffset
	#INITIAL 2 DIGIT SCORE  (s1s0)
	li $s0, 0
	li $s1, 0
	
	#Get address of plaform array
	la $t1, platOffset
	#Index of platform array * 4
	li $t2, 0
	StartRandomPos:
		#Generate random horizontal position
		jal GeneratePlatformPosition
		#Add offset to array address
		add $t3, $t2, $t1
		#Access certain element of platOffset array
		lw $t4, 0($t3)	
		#Add to the element by random horizontal  position
		add $t4, $t4, $a0
		#Save to the address
		sw $t4, 0($t3)	
		
		addi $t2, $t2, 4
		#Maximum index of platform array = #platform*4 - 4
		bne $t2, 16, StartRandomPos
		
		
GameRunning:
#Sleep
jal Sleep	
	beq $a3, 0, PlayerFallDown
	PlayerJumpUp:
		lw $t0, playerOffset
		addi $t0, $t0, -128
		sw $t0, playerOffset
		addi $a3, $a3 -1
		j DoneJump
	PlayerFallDown:
		#Otherwise the player should be falling
		lw $t0, playerOffset
		addi $t0, $t0, 128
		sw $t0, playerOffset
		jal CheckCollision
	DoneJump:
	
#Check if you lost
lw $t0, playerOffset
bgt $t0, 4092, Exit
	
#Move platforms down IF necessary
CheckBasePlatform:
	la $t0, platOffset
	add $t1, $a2, $t0
	#Access offset value at that index
	lw $t2, 0($t1)
	#Check if it is > 3964, if it is, don't need to shift. Otherwise, need to shift.
	bgt $t2, 3964, NoShift
#Get address of plaform array
la $t1, platOffset
#Index of platform array * 4
li $t2, 0
PlatformShiftDownLoop:
	add $t4, $t1, $t2
	#Acess element at that index
	lw $t3, 0($t4)
	#Move it down by a row
	addi $t3, $t3, 128
	sw $t3, 0($t4)
	#Next element
	addi $t2, $t2, 4
	#Maximum index of platform array = #platform*4 - 4
	bne $t2, 20, PlatformShiftDownLoop
NoShift:

	
#Check for UserInput
KeyPress:
	lw $t8, 0xffff0000 
	#Goes out of label if nothing is pressed
	beq $t8, 0, DoneKeyPress
	#This point on means something is pressed, check what is pressed
	lw $t2, 0xffff0004 
	#Check if j is pressed
	beq $t2, 0x6a, PressedJ
	#Check if k is pressed
	beq $t2, 0x6b, PressedK
	#Ignore if other key is pressed
	j DoneKeyPress
#Update players location if user pressed j
PressedJ:
	lw $t0, playerOffset
	addi $t0, $t0, -4
	sw $t0, playerOffset	
	j DoneKeyPress
	
#Update player's location if user pressed k
PressedK:
	lw $t0, playerOffset
	addi $t0, $t0, 4
	sw $t0, playerOffset

	
DoneKeyPress:

#Check if the platforms are still in display 
CheckPlatforms:
	la $t1, platOffset
	#Index of platform array * 4
	li $t2, 0
	Check:
		#Add offset to array address
		add $t3, $t2, $t1
		#Access certain element of platOffset array
		lw $t4, 0($t3)	
		
		#Check that the platform location is valid (The bottom rightmost position of the left point of platform is 4064)
		blt $t4, 4068, NextPlatform		
		
		NewPlatform:
			#Generate random horizontal position
			jal GeneratePlatformPosition
			
			#Increase the score
			jal IncreaseScoreByOne
			
			
			#Save to the address (the platform will be at top of display)
			sw $a0, 0($t3)	
		NextPlatform:
			addi $t2, $t2, 4
			#Maximum index of platform array = #platform*4 - 4
			bne $t2, 20, Check


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
#Draw player
PaintPlayer:
	lw $t0, displayAddress
	lw $t1, playerColor
	lw $t2, playerOffset
	add $t3, $t2, $t0
	sw $t1, 0($t3)
	#Player's base is 3 wide
	addi $t3, $t3, 4
	sw $t1, 0($t3)
	addi $t3, $t3, 4
	sw $t1, 0($t3)
	
	#Make it a cube
	addi $t3, $t3, -128
	sw $t1, 0($t3)
	addi $t3, $t3, -4
	sw $t1, 0($t3)
	addi $t3, $t3, -4
	sw $t1, 0($t3)
	addi $t3, $t3, -128
	sw $t1, 0($t3)
	addi $t3, $t3, 4
	sw $t1, 0($t3)
	addi $t3, $t3, 4
	sw $t1, 0($t3)
	
move $t0, $s1
li $t5, 0
jal DrawNumber #Number to draw must be stored in t0, additional offset must be stored at
move $t0, $s0
li $t5, 12
jal DrawNumber
j GameRunning
	

Exit:
	#Wait for user to hit s to start
	lw $t8, 0xffff0000 
	#Goes out of label if nothing is pressed
	beq $t8, 0, Pause
	#This point on means something is pressed, check what is pressed
	lw $t2, 0xffff0004 
	#Check if s is pressed
	bne $t2, 0x73, Pause
	j Start
	#Sleep
	Pause:
		jal Sleep	
	j Exit
	li $v0, 10 # terminate the program gracefully
	syscall	

#Generate random horizontal position for platform (0-94) offset that is divisible by 4      
GeneratePlatformPosition:
	#Generate number from 0-24 UPDATE 0-22
	li $v0, 42
	li $a0, 0
	li $a1, 22
	syscall
	#Multiply number by 4
	sll $a0, $a0, 2
	jr $ra
	
#Check whether player collides with platform on the next step (check if the player is 1 on the  platform)
CheckCollision:
	#Get player's location
	lw $t0, playerOffset
	add $t9, $t0, 4
	add $t8, $t9, 4
	#Get address of plaform array
	la $t1, platOffset
	#Index of platform array * 4
	li $t2, 0
	#platform length
	lw $t6, platLength
	CollisionLoop:
		#Get the address at the index
		add $t3, $t1, $t2
		#Acess element at that index
		lw $t4, 0($t3)
		#Move it back by a row
		#addi $t4, $t4, -128
		#Counter for platform length
		li $t5, 0
		PlatformCollision:
			beq $t5, $t6, DoneCheckingPlatform
			#Check if the platform (one above) collides
			beq $t4, $t0, Collide
			beq $t4, $t9, Collide
			beq $t4, $t8, Collide
			j NotCollide
			Collide:
			#This means it has collided
			li $a3, 10 #Reset player jump counter
			#Variable to keep trakc of which platform has to be shoved to the bottom and respawned
			move $a2, $t2 #saves index of platform*4 (AS BASE PLATFORM- THE PLATFORM THAT SHOULD BE AT BOTTOM OF SCREEN) 
			j DoneCheckCollision
			NotCollide:
			addi $t5, $t5, 1
			addi $t4, $t4, 4
			j PlatformCollision	
		DoneCheckingPlatform:
			addi $t2, $t2, 4
			bne $t2, 20, CollisionLoop
	DoneCheckCollision:
	jr $ra
	
	
Sleep:
	li $v0, 32
	li $a0, 150
	syscall	
	jr $ra
	

IncreaseScoreByOne:
	#If first digit (s0) is less than 9.
	blt $s0, 9, AddOne
	#Otherwise, add to the 10s
	li $s0, 0
	addi $s1, $s1, 1
	jr $ra
	AddOne:
		addi $s0, $s0, 1
		jr $ra


DrawNumber:
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
	
	#Add additional offset t5
	add $t8, $t8, $t5
	
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
	jr $ra

