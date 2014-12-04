TITLE Project 6			(Project6.asm)

; Author: Minh Nguyen
; email: Nguyminh@onid.orst.edu
; Class: CS271 - 400
; Assignment: 06
; Due Date: 8/30/2014
; Program Description: Design and implementation of low level I/O procedures using getString and displayString macros. 
;						program uses lodsb and stosb operators. Receives 10 valid integers from user and stores in array.
;						Displays the integers, sum, and their average.

INCLUDE Irvine32.inc

getString macro stringADD, stringLen
LOCAL display

.data
		display		BYTE	10,13," Enter in Integer here: ", 0

.code
					mov		edx, OFFSET display
					call		writeString
					mov		edx, stringADD
					mov		ecx, stringLen
					call		readString					
ENDM

STACK_FRAME	macro								;a macro for setting up the stack
					push	ebp
					mov		ebp, esp
ENDM

displayString macro	stringADD
					mov		edx, stringADD
					call	writeString
ENDM

;global constants here
dive = 10
MAX = 10
TRUE = 1
DIVE = 10


.data
intro_1			BYTE	"This program is called the input validation program(#06): by Minh Nguyen", 10, 13, 0
intro_2			BYTE	"User will enter in 10 integers when prompted to", 10, 13, 0
intro_3			BYTE	"The integers will be displayed, along with their sum, and average", 10, 13, 0
prompt_1		BYTE	"Enter enter any positive integer: ", 0
error_1			BYTE	"Invalid input. Please try again!" ,10, 13, 0
list_out		BYTE	"The numbers entered are: ", 10, 13,0
sum_out			BYTE	"The sum of the numbers is: ", 10,13,0
average_out		BYTE	"The average of the numbers are: ",0
extra			BYTE	9,0

array_int		DWORD	MAX		DUP(0)
string_dis		BYTE	MAX		DUP(?)
integers		DWORD	?
sum				DWORD	?
average			DWORD	?

.code
main PROC		;calling introduction
				push	OFFSET intro_1
				push	OFFSET intro_2
				push	OFFSET intro_3
				call	introduction			

				;move size and offset of array into esi and ecx
				mov		esi, OFFSET array_int
				mov		ecx, LENGTHOF array_int
		
		L1:		;loop to get integers	
				
				push	OFFSET error_1
				call	getVal
				pop		[esi]
				add		esi, 4
				loop	L1

				;pushing the array pointer and lenght of array to put into averageFinder algorithm
				push	OFFSET array_int
				push	LENGTHOF array_int
				call	AverageFinder
				pop		sum		;return sum from stack
				pop		average	;return average from stack

				mov		edx, OFFSET list_out
				call	writeString
				push	OFFSET	array_int
				push	LENGTHOF array_int
				push	OFFSET	extra
				call	PrintARR

				mov		edx, OFFSET sum_out
				call	writeString

				push	sum
				call	PrintINT
				call	crlf

				mov		edx, OFFSET average_out
				call	writeString
				push	average
				call	PrintINT
				call	crlf
exit		
main ENDP

introduction PROC	USES edx
;------------------------------------------------------------
;Procedure: Introduction
;Description: Introduces program to user
;Receives: intro_1, intro_2, intro_3
;Returns: Nothing
;Preconditions: None
;------------------------------------------------------------
			STACK_FRAME

				mov		edx, [ebp+20]
				call	writeString
				mov		edx, [ebp+16]
				call	writeString
				mov		edx, [ebp+12]
				call	writeString

				pop		ebp
				ret		20
introduction  ENDP

getVal		PROC	USES edx ecx eax ebx esi
LOCAL		input[MAX]: BYTE, pass: DWORD
;------------------------------------------------------------------------------------------------
;Description:	takes input from user, validates if its an integer, convert input into integer
;Receives:		string address
;returns:		integres in an array
;Preconditions: none
;------------------------------------------------------------------------------------------------
getData:
				lea		eax, input
				getString eax, LENGTHOF input
				mov		ebx,[ebp+8]
				lea		eax, input
				push	eax
				push	LENGTHOF input
				push	ebx
				lea		eax, pass
				push	eax
				call	checking		;call checking to validate entry
				
				mov		eax, pass	;check if valid after calling checking
				cmp		eax, TRUE
				jne		getData
				
				lea		eax, input
				push	eax
				push	LENGTHOF input
				call	change

				pop		eax
				mov		[ebp+8], eax
				ret 
getVal		ENDP

checking	PROC	USES	esi ecx edi eax
LOCAL	something:DWORD
;------------------------------------------------------------------------------------------------
;Description:	Checks if string characters are digits. Then compare digit to limit if less than
;Receives:		string address, length of integer, error_1
;Returns:	none
;Preconditions: none
;------------------------------------------------------------------------------------------------

				mov		esi, [ebp+20]
				mov		ecx, [ebp+16]
				cld
tally:
				lodsb
				cmp		al, 1    ;if 0 char, then go to wrongchar
				jl		greenlight

				cmp		al, "0"  ;if char is greater than 0, proceed
				jb		wrongNUM

				cmp		al, "9"   ;if char is less than 9, then proceed
				ja		wrongNUM	
				loop	tally
	WrongNUM:
				mov		edx, [ebp+12]
				call	WriteString
				jmp		finish
	greenlight:

				push	[ebp+20]
				push	[ebp+16]
				call	change
				pop		eax
				cmp		eax, 429496729
				jg		wrongNUM
				mov		eax, [ebp+8] 
				mov		ebx, TRUE
				mov		[eax],ebx
finish:

				ret		16
checking	ENDP		

change	PROC  USES eax ecx edx esi 
;-----------------------------------------------------------
;Description:	Convert digit string into integer
;Receives:		input, length
;Returns:		integers
;Preconditions:	string is valid
;-----------------------------------------------------------
		STACK_FRAME
				
				mov		esi, [ebp+28]
				mov		ecx, [ebp+24]
				xor		edx, edx
				xor		eax, eax
				cld
algorithm:
				lodsb
				cmp		eax, 0
				je		finish
				imul	edx, edx, 10
				sub		eax, "0"
				add		edx, eax
				loop	algorithm
	finish:	
				mov		[ebp+28], edx
				pop		ebp
				ret		4
change	ENDP

AverageFinder	PROC USES eax ecx esi
LOCAL			the_sum:DWORD, the_average:DWORD, the_localT:DWORD
;---------------------------------------------------------
;Description:	sums up array of integer, finds average
;Receives:		array pointer, length of array
;returns:		average and sum of array
;Preconditions:	none
;--------------------------------------------------------
				mov		eax, 0
				mov		esi, [ebp+12]
				mov		ecx, [ebp+8]
				mov		the_localT, ecx
	L1:
				add		eax, [esi]
				add		esi, 4
				loop	L1
				
				mov		the_sum, eax
				fild	the_sum
				fidiv	the_localT
				fistp	the_average
				
				mov		eax, the_sum
				mov		[ebp+8], eax
				mov		eax, the_average
				mov		[ebp+12], eax
				ret

AverageFinder ENDP


PrintARR		PROC	USES ebx ecx edx esi
;------------------------------------------------------------
;Description:	Displays contained array
;Receives:		array pointer ,length, and string of array
;Returns:		nothing
;Preconditions:	none
;------------------------------------------------------------
			STACK_FRAME
				mov		esi,[ebp+32]
				mov		ecx, [ebp+28]
				mov		ebx, 0
	printloop:
				push	[esi]
				call	PrintINT
				mov		edx, [ebp+24]
				call	writeString
				add		esi, 4
				loop	printloop
				pop		ebp
				ret		12
PrintARR	ENDP

PrintINT	PROC	USES	eax edx
LOCAL		stringPRINT[MAX]: BYTE
;--------------------------------------------------------------
;Description:	prints integer as string
;receives:		integers
;returns:		none
;Preconditions:	none
;-------------------------------------------------------------
				lea		eax, stringPRINT
				push	eax
				push	[ebp+8]
				call	changeCHAR
				lea		eax, stringPRINT
				displayString	eax
				ret 4
PrintINT	ENDP

changeCHAR  PROC	USES eax ebx ecx edi
LOCAL		localT:DWORD
;-------------------------------------------------------------
;description:	convert integer into string
;receives:		pointer of string, integer to be converted
;returns:		nothing
;preconditions:	none
;-------------------------------------------------------------
				mov		eax,[ebp+8]
				mov		ebx, 10
				xor		ecx, ecx
	L1:	
				xor		edx, edx
				div		ebx
				push	edx
				inc		ecx
				test	eax, eax
				jnz		L1
				mov		edi, [ebp+12]
	L2:
				pop		localT
				mov		al, BYTE PTR localT
				add		al, "0"
				stosb
				loop	L2
				mov		al, 0
				stosb
				ret		8
changeCHAR	ENDP


END main