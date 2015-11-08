.data


.balign 4
outstart1: .asciz "...Something Something Hangman!!\n"

.balign 4
outstart2: .asciz "Only lowercase letters are permitted\nYou are allowed six errors\n\n"

.balign 4
rdnWord: .word 0

.text

	.global main

main:
	PUSH {r4,lr}

	LDR R0, =outstart1
	BL printf

	LDR R0, =outstart2
	BL printf

	/*Set random value*/
	MOV R0, #0
    	BL time
    	BL srand
    	BL rand
    	MOV R1, R0, ASR #1
    	MOV R2, #5
    	BL divMod

	CMP R1, #0	@branch if random number was 0
	BEQ wrd0

	CMP R1, #1	@branch if random number was 1
	BEQ wrd1

	CMP R1, #2	@branch if random number was 2
	BEQ wrd2

	CMP R1, #3	@branch if random number was 3
	BEQ wrd3

	CMP R1, #4	@branch if random number was 4
	BEQ wrd4

wrd0:
	BL word0
	B exit

wrd1:
	BL word1
	B exit

wrd2:
	BL word2
	B exit

wrd3:
	BL word3
	B exit

wrd4:
	BL word4
	B exit

exit:
	POP {r4,lr}	@leave main
    	BX lr

/*external functions*/
.global scanf
.global printf
.global time
.global srand
.global rand
