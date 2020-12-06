#####################################################################
#
# CSCB58 Fall 2020 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Michelle Kee, 1005254038
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Fancier Grahpics
# 2. Two Doodles
# 3. Dynamic On Screen Notifications
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
	playerTwoOffset: .word 3916
	
	#Game colors
	skyColor: .word 0xBFF7FF#0xDDFFFB #LightBlue-NearWhite
	platColor: .word 0xFFC0CB#0xFFACF6 #Pink
	playerColor: .word 0x859de4 #Green
	playerTwoColor: .word 0x5CFFBE
	numberColor: .word 0x859de4#0xECEBDF
	
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
	#Information to draw letters
	PixelA: .word 1,1,1, 1,0,1, 1,1,1, 1,0,1, 1,0,1
	PixelD: .word 1,1,0, 1,0,1, 1,0,1, 1,0,1, 1,1,0 
	PixelE: .word 1,1,1, 1,0,0, 1,1,0, 1,0,0, 1,1,1
	PixelF: .word 1,1,1, 1,0,0, 1,1,0, 1,0,0, 1,0,0
	PixelG: .word 1,1,1, 1,0,0, 1,0,1, 1,0,1, 1,1,1
	PixelJ: .word 0,0,1, 0,0,1, 0,0,1, 1,0,1, 1,1,1
	PixelL: .word 1,0,0, 1,0,0, 1,0,0, 1,0,0, 1,1,1
	PixelM: .word 1,0,1, 1,1,1, 1,0,1, 1,0,1, 1,0,1
	PixelO: .word 1,1,1, 1,0,1, 1,0,1, 1,0,1, 1,1,1
	PixelP: .word 1,1,1, 1,0,1, 1,1,1, 1,0,0, 1,0,0
	PixelR: .word 1,1,0, 1,0,1, 1,1,0, 1,0,1, 1,0,1
	PixelS: .word 1,1,1, 1,0,0, 1,1,1, 0,0,1, 1,1,1
	PixelT: .word 1,1,1, 0,1,0, 0,1,0, 0,1,0, 0,1,0
	PixelU: .word 1,0,1, 1,0,1, 1,0,1, 1,0,1, 1,1,1
	PixelW: .word 1,0,1, 1,0,1, 1,0,1, 1,1,1, 1,0,1,
.text	

DrawStartScreen:
	#lw $t0, displayAddress	# $t0 stores the base address for display
	li $t0, 0
	lw $t1, skyColor
	PaintStartPixel:
		#beq $t0, 0x10009000, DoneScreen #Pixel out of display
		beq $t0, 8192, DoneStartcreen
		add $t2, $t0, $gp
		sw $t1, 0($t2)
		addi $t0, $t0, 4 
		j PaintStartPixel
	DoneStartcreen:
	
	#DrawLetters
	#Load information on how to draw number
	la $t1, PixelD	
	li $t0, 0
	#Where to draw
	li $t5, 12
	jal DrawNumber
	la $t1, PixelO
	li $t0, 0
	#Where to draw
	li $t5, 28
	jal DrawNumber
	la $t1, PixelO
	li $t0, 0
	#Where to draw
	li $t5, 44
	jal DrawNumber
	la $t1, PixelD
	li $t0, 0
	#Where to draw
	li $t5, 60
	jal DrawNumber
	la $t1, PixelL
	li $t0, 0
	#Where to draw
	li $t5, 76
	jal DrawNumber
	la $t1, PixelE
	li $t0, 0
	#Where to draw
	li $t5, 92
	jal DrawNumber	
	la $t1, PixelJ
	li $t0, 0
	#Where to draw
	li $t5, 792#664
	jal DrawNumber
	la $t1, PixelU
	li $t0, 0
	#Where to draw
	li $t5, 808
	jal DrawNumber
	la $t1, PixelM
	li $t0, 0
	#Where to draw
	li $t5, 824
	jal DrawNumber
	la $t1, PixelP
	li $t0, 0
	#Where to draw
	li $t5, 840
	jal DrawNumber
	
	la $t1, PixelS
	li $t0, 0
	#Where to draw
	li $t5, 2456#1688
	jal DrawNumber
	
	la $t1, PixelT
	li $t0, 0
	#Where to draw
	li $t5, 2488
	jal DrawNumber
	la $t1, PixelO
	li $t0, 0
	#Where to draw
	li $t5, 2504
	jal DrawNumber
	
	la $t1, PixelS
	li $t0, 0
	#Where to draw
	li $t5, 3224
	jal DrawNumber
	la $t1, PixelT
	li $t0, 0
	#Where to draw
	li $t5, 3240
	jal DrawNumber
	la $t1, PixelA
	li $t0, 0
	#Where to draw
	li $t5, 3256
	jal DrawNumber
	la $t1, PixelR
	li $t0, 0
	#Where to draw
	li $t5, 3272
	jal DrawNumber
	la $t1, PixelT
	li $t0, 0
	#Where to draw
	li $t5, 3288
	jal DrawNumber
	
	li $t9, 4952#4184  +768
	li $t5, 6944
	#Falling down when t8 is at 1
	li $t8, 1
	

Launch:
	#Repaint lower background
	li $t0, 4096
	lw $t1, skyColor
	StartBackRepaint:
		#beq $t0, 0x10009000, DoneScreen #Pixel out of display
		beq $t0, 8192, DoneRepaint
		add $t2, $t0, $gp
		sw $t1, 0($t2)
		addi $t0, $t0, 4 
		j StartBackRepaint
	DoneRepaint:
	
	beq $t9, 4952, startFall #4184
	beq $t9, 5592, startUp #4824
	j startAction
	startUp:
	li $t8, 0
	j startAction
	startFall:
	li $t8, 1
	startAction:
		beq $t8, 1, falling
		addi $t9, $t9, -128
		addi $t5, $t5, -128
		j out
		falling:
		addi $t9, $t9, 128
		addi $t5, $t5, 128
	out:
	lw $t7, playerTwoColor
	#Draw pixel
	add $t2, $t9, $gp
	sw $t7, 0($t2)
	addi $t2, $t2, 8
	sw $t7, 0($t2)
	addi $t2, $t2, -128
	sw $t7, 0($t2)
	addi $t2, $t2, -4
	sw $t7, 0($t2)
	addi $t2, $t2, -4
	sw $t7, 0($t2)
	addi $t2, $t2, -128
	sw $t7, 0($t2)
	addi $t2, $t2, 4
	sw $t7, 0($t2)
	addi $t2, $t2, 4
	sw $t7, 0($t2)
	lw $t7, playerColor
	#Another Jumping Player
	add $t2, $t5, $gp
	sw $t7, 0($t2)
	addi $t2, $t2, 8
	sw $t7, 0($t2)
	addi $t2, $t2, -128
	sw $t7, 0($t2)
	addi $t2, $t2, -4
	sw $t7, 0($t2)
	addi $t2, $t2, -4
	sw $t7, 0($t2)
	addi $t2, $t2, -128
	sw $t7, 0($t2)
	addi $t2, $t2, 4
	sw $t7, 0($t2)
	addi $t2, $t2, 4
	sw $t7, 0($t2)
	#Redraw temporary doodle
	
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
	#Counter for how much a player can jump (a3-p1) (s7-p2)
	li $a3, 16
	li $s7, 16
	#Register to save what platform the screen needs to scroll past (base platform is at index 5 rn)
	li $a2, 16
	li $s4, 16
	#RandomlyGenerate all platform's positions (At the beginning of game)
	#INITIAL PLATFORM POSITIONS
	#Basic addresses of platform array that will not change
	#Get address of plaform array
	la $t1, platOffset
	li $t0, 1280#640 
	sw $t0, 0($t1)
	li $t0, 3072#1536
	sw $t0, 4($t1)
	li $t0, 4608#2304
	sw $t0, 8($t1)
	li $t0, 6400#3200
	sw $t0, 12($t1)
	li $t0, 7996#4008
	sw $t0, 16($t1)
	#INITIAL PLAYER POSITION
	li $t0, 7884#3900
	sw $t0, playerOffset
	li $t0, 7868#3888
	sw $t0, playerTwoOffset
	#INITIAL 2 DIGIT SCORE  (s1s0)
	li $s0, 0
	li $s1, 0
	#Initial encouragement phrase
	li $s5, -1
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
#Sleep - speed of game
#When player's below 20 platforms, game is normal (150ms sleep)
#When player's at 20 platforms, game speeds up. (100ms sleep)
#When player's at 40 platform, game speeds up again  (50ms sleep)
bgt $s1, 1, FastGame
bgt $s1, 3, FastestGame
jal Sleep
FastGame:
jal Sleep
FastestGame:
jal Sleep


#Determine which one is the base platform
#Take the biggest base platform by checking value at index $a2(p1) and $s4(p2)
la $t0, platOffset
#P1's base
add $t1, $a2, $t0
lw $t1, 0($t1)
#P2's base
add $t2, $s4, $t0
lw $t2, 0($t2)
#Get the lowest value(highest platform) out of the two base platforms t2<t1 then keep t2
blt $t2, $t1, CheckBasePlatform
#Otherwise $t1>$t2 Move $t1 to $t2
move $t2, $t1
#Move platforms down IF necessary
CheckBasePlatform:
	#la $t0, platOffset
	#add $t1, $a2, $t0
	#Access offset value at that index
	#lw $t2, 0($t1)
	#Check if it is > 3964, if it is, don't need to shift. Otherwise, need to shift. 
	bgt $t2, 8064, NoShift #3964
	#Make sure it waits one tick
	beq $s3, 0, OneMoreTick
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
OneMoreTick:
	li $s3, 1
NoShift:



#Update P1 Y position
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
#Update P2 Y position
beq $s7, 0, Player2FallDown
	Player2JumpUp:
		lw $t0, playerTwoOffset
		addi $t0, $t0, -128
		sw $t0, playerTwoOffset
		addi $s7, $s7 -1
		j DoneJump2
	Player2FallDown:
		#Otherwise the player should be falling
		lw $t0, playerTwoOffset
		addi $t0, $t0, 128
		sw $t0, playerTwoOffset
		jal CheckP2Collision
	DoneJump2:

	
#Check if any player died
lw $t0, playerOffset
bgt $t0, 8188, GameEnd #4092
lw $t0, playerTwoOffset
bgt $t0, 8188, GameEnd

	
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
	#Check if w is pressed
	beq $t2, 0x77, PressedW
	#Check if e is pressed
	beq $t2, 0x65, PressedE
	
	#Check if p is pressed for pause
	beq $t2, 0x70, PressedP
	
	
	#P1 Sheild: m
	#P2 Shield: d
	
	
	#Ignore if other key is pressed
	j DoneKeyPress
PressedP:
	#Print Paused
	la $t1, PixelP
	li $t0, 0
	li $t5, 792
	jal DrawNumber
	la $t1, PixelA
	li $t0, 0
	li $t5, 808
	jal DrawNumber
	la $t1, PixelU
	li $t0, 0
	li $t5, 824
	jal DrawNumber
	la $t1, PixelS
	li $t0, 0
	li $t5, 840
	jal DrawNumber
	la $t1, PixelE
	li $t0, 0
	li $t5, 856
	jal DrawNumber
	
	CheckUnpause:
		lw $t8, 0xffff0000 
		#Goes out of label if nothing is pressed
		beq $t8, 0, KeepChecking
		#This point on means something is pressed, check what is pressed
		lw $t2, 0xffff0004 	
		#Check if p is pressed for pause
		beq $t2, 0x70, PressedPAgain
	KeepChecking:
		jal Sleep
		j CheckUnpause
	PressedPAgain:
	j DoneKeyPress
#Player 2
PressedW:
	lw $t0, playerTwoOffset
	addi $t0, $t0, -4
	sw $t0, playerTwoOffset	
	j DoneKeyPress
PressedE:
	lw $t0, playerTwoOffset
	addi $t0, $t0, 4
	sw $t0, playerTwoOffset	
	j DoneKeyPress
	
#PLAYER 1	
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
		
		#Check that the platform location is valid (The bottom rightmost position of the left point of platform is 4064) #4068
		blt $t4, 8164, NextPlatform		
		
		NewPlatform:
			#Generate random horizontal position
			jal GeneratePlatformPosition
			
			#Increase the score of P1
			jal IncreaseScoreByOne
			
			#Save to the address (the platform will be at top of display)
			sw $a0, 0($t3)
			
			#Check if the score is mutiple of 5, if so create some encouraging words
			jal DynamicText	
		NextPlatform:
			addi $t2, $t2, 4
			#Maximum index of platform array = #platform*4 - 4
			bne $t2, 20, Check


#Painting the background of the screen (all pixels)
PaintScreen:
	#lw $t0, displayAddress	# $t0 stores the base address for display
	li $t0, 0
	lw $t1, skyColor
	PaintPixel:
		#beq $t0, 0x10009000, DoneScreen #Pixel out of display
		beq $t0, 8192, DoneScreen
		add $t2, $t0, $gp
		sw $t1, 0($t2)
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
	lw $t1, playerColor
	lw $t2, playerOffset
	jal PaintPlayer
	
	#Do the same thing for the second player
	lw $t1, playerTwoColor
	lw $t2, playerTwoOffset
	jal PaintPlayer


#Draw random encouragement
PaintEncouragement:
	#Check that there is encouragmenet that needs to be printed
	beq $s5, -1, NoEncouragement
	addi $s6, $s6, 1
	#goes away after 5 ticks
	beq $s6, 5, end
	beq $s5, 0, firstEncourage
	beq $s5, 1, secondEncourage 
	#Print third encouragement- WOW
	#Paint end screen
	la $t1, PixelW
	li $t0, 0
	li $t5, 76
	jal DrawNumber
	la $t1, PixelO
	li $t0, 0
	li $t5, 92
	jal DrawNumber
	la $t1, PixelW
	li $t0, 0
	li $t5, 108
	jal DrawNumber
	j NoEncouragement 
	#GREAT
	firstEncourage:
	la $t1, PixelG
	li $t0, 0
	li $t5, 44
	jal DrawNumber
	la $t1, PixelR
	li $t0, 0
	li $t5, 60
	jal DrawNumber
	la $t1, PixelE
	li $t0, 0
	li $t5, 76
	jal DrawNumber
	la $t1, PixelA
	li $t0, 0
	li $t5, 92
	jal DrawNumber
	la $t1, PixelT
	li $t0, 0
	li $t5, 108
	jal DrawNumber
	j NoEncouragement 
	#POG
	secondEncourage:
	la $t1, PixelP
	li $t0, 0
	li $t5, 76
	jal DrawNumber
	la $t1, PixelO
	li $t0, 0
	li $t5, 92
	jal DrawNumber
	la $t1, PixelG
	li $t0, 0
	li $t5, 108
	jal DrawNumber
	j NoEncouragement
	end:
		li $s5, -1
		li $s6, 0
NoEncouragement:
#Load information on how to draw number
la $t1, numberPixel	
move $t0, $s1
li $t5, 0
jal DrawNumber #Number to draw must be stored in t0, additional offset must be stored at $t5
#Load information on how to draw number
la $t1, numberPixel
move $t0, $s0
li $t5, 16
jal DrawNumber
j GameRunning
	
GameEnd:
	#Paint end screen
	la $t1, PixelS
	li $t0, 0
	li $t5, 2456
	jal DrawNumber
	la $t1, PixelT
	li $t0, 0
	li $t5, 2488
	jal DrawNumber
	la $t1, PixelO
	li $t0, 0
	li $t5, 2504
	jal DrawNumber
	la $t1, PixelS
	li $t0, 0
	li $t5, 3224
	jal DrawNumber
	la $t1, PixelT
	li $t0, 0
	li $t5, 3240
	jal DrawNumber
	la $t1, PixelA
	li $t0, 0
	li $t5, 3256
	jal DrawNumber
	la $t1, PixelR
	li $t0, 0
	li $t5, 3272
	jal DrawNumber
	la $t1, PixelT
	li $t0, 0
	li $t5, 3288
	jal DrawNumber
	
	la $t1, PixelO
	li $t0, 0
	li $t5, 5800
	jal DrawNumber
	la $t1, PixelO
	li $t0, 0
	li $t5, 5816
	jal DrawNumber
	la $t1, PixelF
	li $t0, 0
	li $t5, 5832
	jal DrawNumber
	
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
	
#Check whether player collides with platform on the next step 
CheckCollision:
	#Get player's location
	lw $t0, playerOffset
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
		addi $t4, $t4, -128
		#Counter for platform length
		li $t5, 0
		PlatformCollision:
			beq $t5, $t6, DoneCheckingPlatform
			#Check if the platform (one above) collides
			beq $t4, $t0, Collide
			addi $t0, $t0, 4
			beq $t4, $t0, Collide
			addi $t0, $t0, 4
			beq $t4, $t0, Collide
			addi $t0, $t0, -8
			j NotCollide
			Collide:
			#This means it has collided
			li $a3, 16 #Reset player 1 jump counter
			#Variable to keep trakc of which platform has to be shoved to the bottom and respawned
			move $a2, $t2 #saves index of platform*4 (AS BASE PLATFORM- THE PLATFORM THAT SHOULD BE AT BOTTOM OF SCREEN) 
			li $s3, 0
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
	
	
CheckP2Collision:
	#Get player's location
	lw $t0, playerTwoOffset
	#Get address of plaform array
	la $t1, platOffset
	#Index of platform array * 4
	li $t2, 0
	#platform length
	lw $t6, platLength
	CollisionLoop2:
		#Get the address at the index
		add $t3, $t1, $t2
		#Acess element at that index
		lw $t4, 0($t3)
		#Move it back by a row
		addi $t4, $t4, -128
		#Counter for platform length
		li $t5, 0
		PlatformCollision2:
			beq $t5, $t6, DoneCheckingPlatform2
			#Check if the platform (one above) collides
			beq $t4, $t0, Collide2
			addi $t0, $t0, 4
			beq $t4, $t0, Collide2
			addi $t0, $t0, 4
			beq $t4, $t0, Collide2
			addi $t0, $t0, -8
			j NotCollide2
			Collide2:
			#This means it has collided
			li $s7, 16 #Reset player 1 jump counter
			#Variable to keep trakc of which platform has to be shoved to the bottom and respawned
			move $s4, $t2 #saves index of platform*4 (AS BASE PLATFORM- THE PLATFORM THAT SHOULD BE AT BOTTOM OF SCREEN) 
			li $s3, 0
			j DoneCheckCollision2
			NotCollide2:
			addi $t5, $t5, 1
			addi $t4, $t4, 4
			j PlatformCollision2	
			
		DoneCheckingPlatform2:
			addi $t2, $t2, 4
			bne $t2, 20, CollisionLoop2
	DoneCheckCollision2:
	jr $ra


	
Sleep:
	li $v0, 32
	li $a0, 50
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
	#la $t1, numberPixel
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
	

PaintPlayer:
	add $t3, $t2, $gp
	sw $t1, 0($t3)
	#Player's base is 3 wide
	addi $t3, $t3, 4
	#sw $t1, 0($t3)
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
	jr $ra

DynamicText:
	#Check if score is multiple of 5
	beq $s0, 5, cont
	jr $ra
	cont:
		#Save into $s5, randomly generated encouragement
		#Generate number from 0-2
		li $v0, 42
		li $a0, 0
		li $a1, 2
		syscall
		move $s5, $a0
		jr $ra
		
