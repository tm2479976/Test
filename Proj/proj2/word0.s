.data

.balign 4
scanPattern: .asciz " %c"

.balign 4
outLetter: .asciz "%c%c%c"

.balign 4
outLetter2: .asciz "%c%c%c "

.balign 4
outLetter3: .asciz "%c%c%c\n"

.balign 4
inLetter: .word 0

.balign 4
outNotFound: .asciz "%c is not in word\n"

.balign 4
outChances: .asciz "%d chances remain\n"

.balign 4
outUsed: .asciz "%c has already been used\n"

.balign 4
outFailure: .asciz "You died...\nThe word you were looking for was %c%c%c"

.balign 4
outSuccess: .asciz "Congratulations you figured it out!\nThe answer was %c%c%c"

.balign
unknown: .skip 24

.text

	.global word0

word0:
	PUSH {lr}
	SUB sp, sp, #24		@make room for 6 integers in the stack

	MOV R4, #6		@remaining chances
	MOV R5, #6		@unsolved letters
	LDR R6, =unknown	@'*' as placeholer for unsolved letters
	MOV R8, sp
	LDR R9, =words

	MOV R0, #4
	MUL R1, R1, R0
	LDR R3, =index
	LDR R10, [R3, +R1]

	/*initialize unknown*/
	MOV R7, #42
	STR R7, [R6]
	STR R7, [R6, +#4]
	STR R7, [R6, +#8]
	STR R7, [R6, +#12]
	STR R7, [R6, +#16]
	STR R7, [R6, +#20]

	/*set local array*/
	LDR R7, [R9, +R10]
	STR R7, [R8]
	ADD R10, R10, #4
	LDR R7, [R9, +R10]
	STR R7, [R8, +#4]
	ADD R10, R10, #4
	LDR R7, [R9, +R10]
	STR R7, [R8, +#8]
	ADD R10, R10, #4
	LDR R7, [R9, +R10]
	STR R7, [R8, +#12]
	ADD R10, R10, #4
	LDR R7, [R9, +R10]
	STR R7, [R8, +#16]
	ADD R10, R10, #4
	LDR R7, [R9, +R10]
	STR R7, [R8, +#20]

loop:
	MOV R9, #0

	/*Display in sets of three*/
	LDR R0, =outLetter
	LDR R1, [R6]		@first letter
	LDR R2, [R6, +#4]	@second letter
	LDR R3, [R6, +#8]	@third letter
	BL printf

	LDR R0, =outLetter2
	LDR R1, [R6, +#12]		@fourth letter
	LDR R2, [R6, +#16]		@fifth letter
	LDR R3, [R6, +#20]		@sixth letter
	BL printf

	LDR R0, =scanPattern
	LDR R1, =inLetter
	BL scanf
	LDR R1, =inLetter
	LDR R1, [R1]

	LDR R7, [R8]
	CMP R1, R7		@check if inLetter = 'p'
	ADDNE R9, R9, #1
	BNE letter2
	LDR R7, [R6]
	CMP R1, R7		@check if used already
	BEQ used
	MOV R7, R1
	STR R7, [R6]
	SUB R5, R5, #1

letter2:
	LDR R7, [R8, +#4]
	CMP R1, R7		@check if inLetter = 'i'
	ADDNE R9, R9, #1
	BNE letter3
	LDR R7, [R6, +#4]
	CMP R1, R7		@check if used already
	BEQ used
	MOV R7, R1
	STR R7, [R6, +#4]
	SUB R5, R5, #1

letter3:
	LDR R7, [R8, +#8]
	CMP R1, R7		@check if inLetter = 'd'
	ADDNE R9, R9, #1
	BNE letter4
	LDR R7, [R6, +#8]
	CMP R1, R7		@check if used already
	BEQ used
	MOV R7, R1
	STR R7, [R6, +#8]
	SUB R5, R5, #1

letter4:
	LDR R7, [R8, +#12]
	CMP R1, R7		@check if inLetter = 'g'
	ADDNE R9, R9, #1
	BNE letter5
	LDR R7, [R6, +#12]
	CMP R1, R7		@check if used already
	BEQ used
	MOV R7, R1
	STR R7, [R6, +#12]
	SUB R5, R5, #1

letter5:
	LDR R7, [R8, +#16]
	CMP R1, R7		@check if inLetter = 'e'
	ADDNE R9, R9, #1
	BNE letter6
	LDR R7, [R6, +#16]
	CMP R1, R7		@check if used already
	BEQ used
	MOV R7, R1
	STR R7, [R6, +#16]
	SUB R5, R5, #1

letter6:
	LDR R7, [R8, +#20]
	CMP R1, R7		@check if inLetter = 'y'
	ADDNE R9, R9, #1
	BNE notFound		@branch if none of the above
	LDR R7, [R6, +#20]
	CMP R1, R7		@check if used already
	BEQ used
	MOV R7, R1
	STR R7, [R6, +#20]
	SUB R5, R5, #1
	B checkUnsolved

notFound:
	CMP R9, #6
	BLT checkUnsolved
	/*Display message for incorrect guesses*/
	LDR R0, =outNotFound
	BL printf

	SUB R4, R4, #1		@R4--
	CMP R4, #0		@check if any chances remain
	BLE failure

	/*Display message for remaining chances*/
	LDR R0, =outChances
	MOV R1, R4
	BL printf

	B loop			@return to loop if any chances remain

checkUnsolved:
	CMP R5, #0		@check if all letters solved
	BLE success
	B loop			@return to loop if not

used:
	/*Display message for repeat guesses*/
	LDR R0, =outUsed
	BL printf
	B loop

failure:
	/*Display message for failed game*/
	LDR R0, =outFailure
	LDR R1, [R8]		@first letter
	LDR R2, [R8, +#4]	@second letter
	LDR R3, [R8, +#8]	@third letter
	BL printf

	LDR R0, =outLetter3
	LDR R1, [R8, +#12]		@fourth letter
	LDR R2, [R8, +#16]		@fifth letter
	LDR R3, [R8, +#20]		@sixth letter
	BL printf

	B finish

success:
	/*Display message for successful game*/
	LDR R0, =outSuccess
	LDR R1, [R6]		@first letter
	LDR R2, [R6, +#4]	@second letter
	LDR R3, [R6, +#8]	@third letter
	BL printf

	LDR R0, =outLetter3
	LDR R1, [R6, +#12]		@fourth letter
	LDR R2, [R6, +#16]		@fifth letter
	LDR R3, [R6, +#20]		@sixth letter
	BL printf

	B finish

finish:
	/*return to main*/
	ADD sp, sp, #24
	POP {lr}
	BX lr

//inLetterAddr: .word inLetter
