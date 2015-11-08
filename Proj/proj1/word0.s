.data

.balign 4
scanPattern: .asciz " %c"

.balign 4
outLetter: .asciz "%c%c%c"

.balign 4
outLetter2: .asciz "%c%c%c "

.balign 4
inLetter: .word 0

.balign 4
outNotFound: .asciz "%c is not in word\n"

.balign 4
outUsed: .asciz "%c has already been used\n"

.balign 4
outFailure: .asciz "You die, So sad. :(\nWho's that Pokemon?\n\nIt was Pidgey...\n"

.balign 4
outSuccess: .asciz "You're Winner!\nWho's that Pokemon?\n\nIts Pidgey!!\n"

.balign 4
return2: .word 0

.text

	.global word0

word0:
	LDR R2, return2Addr
	STR lr, [R2]

	MOV R4, #6	@remaining chances
	MOV R5, #6	@unsolved letters
	MOV R6, #42	@'*' as placeholer for unsolved letters
	MOV R7, #42
	MOV R8, #42
	MOV R9, #42
	MOV R10, #42
	MOV R11, #42

loop:
	LDR R0, =outLetter
	MOV R1, R6
	MOV R2, R7
	MOV R3, R8
	BL printf

	LDR R0, =outLetter2
	MOV R1, R9
	MOV R2, R10
	MOV R3, R12
	BL printf

	LDR R0, =scanPattern
	LDR R1, =inLetter
	BL scanf
	LDR R1, inLetterAddr
	LDR R1, [R1]

	CMP R1, #112
	BEQ letterp

	CMP R1, #105
	BEQ letteri

	CMP R1, #100
	BEQ letterd

	CMP R1, #103
	BEQ letterg

	CMP R1, #101
	BEQ lettere

	CMP R1, #121
	BEQ lettery

	B notFound

letterp:
	CMP R6, R1
	BEQ used
	MOV R6, R1
	SUB R5, R5, #1
	B checkUnsolved

letteri:
	CMP R7, R1
	BEQ used
	MOV R7, R1
	SUB R5, R5, #1
	B checkUnsolved

letterd:
	CMP R8, R1
	BEQ used
	MOV R8, R1
	SUB R5, R5, #1
	B checkUnsolved

letterg:
	CMP R9, R1
	BEQ used
	MOV R9, R1
	SUB R5, R5, #1
	B checkUnsolved

lettere:
	CMP R10, R1
	BEQ used
	MOV R10, R1
	SUB R5, R5, #1
	B checkUnsolved

lettery:
	CMP R11, R1
	BEQ used
	MOV R11, R1
	SUB R5, R5, #1
	B checkUnsolved

notFound:
	LDR R0, =outNotFound
	BL printf

	SUB R4, R4, #1
	CMP R4, #0
	BLE failure

	B loop

checkUnsolved:
	CMP R5, #0
	BLE success
	B loop

used:
	LDR R0, =outUsed
	BL printf
	B loop

failure:
	LDR R0, =outFailure
	BL printf

	B finish

success:
	LDR R0, =outSuccess
	BL printf

	B finish

finish:
	LDR lr, return2Addr
	LDR lr, [lr]
	BX lr

return2Addr: .word return2
inLetterAddr: .word inLetter
