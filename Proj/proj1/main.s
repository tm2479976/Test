.data


.balign 4
outstart1: .asciz "...Something Something Hangman!!\n"

.balign 4
outstart2: .asciz "You are allowed five errors\n"

.balign 4
rdnWord: .word 0

.text

	.global main

main:
	PUSH {lr}

	LDR R0, =outstart1
	BL printf

	LDR R0, =outstart2
	BL printf

	MOV R4, #1	@randomize later

	CMP R4, #0	
	BEQ word0

	CMP R4, #1	
	BEQ word1

	CMP R4, #2	
	BEQ word2

	CMP R4, #3	
	BEQ word3

	CMP R4, #4	
	BEQ word4

word0:
	BL word0
	B exit

word1:
	BL word1
	B exit

word2:
	BL word2
	B exit

word3:
	BL word3
	B exit

word4:
	BL word4
	B exit

exit:
	POP {lr}
    	BX lr

.global scanf
.global printf
.global word0
.global word1
.global word2
.global word3
.global word4