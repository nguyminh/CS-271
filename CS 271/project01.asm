; Author: Minh Nguyen
; Email: nguyminh@onid.orst.edu
; Class: CS271-400
; Assignment: #01
; due date: 7/6/2014

INCLUDE Irvine32.inc



.data
myName		BYTE	"Name: Minh Nguyen" , 0
myProgram	BYTE	"Program:  Project 01" , 0

intro_1		BYTE	"This program will require the user to enter two integers." ,0
intro_2		BYTE	"The sum, difference, product, quotient and remainder will be outputted." , 0

prompt_1	BYTE	"Enter in first integer: " , 0
prompt_2	BYTE	"Enter second integer (Must be less than first integer to continue):  " , 0
prompt_loop	BYTE	"Would you like to try again? 1 for yes, 0 for no: " , 0


result_sum	BYTE	"The sum is: " , 0
result_diff BYTE	"The difference is: ", 0
result_prod	BYTE	"The product is: ", 0
result_quot	BYTE	"The quotient is: " , 0
result_rem	BYTE	"And the remainder is: " , 0

Bye		BYTE	"Hope you enjoyed the program. Good bye!" , 0

loopanswer	DWORD	?		; integer to store to run program again
integer_1	DWORD	?		; First integer to be entered by user
integer_2	DWORD	?		; Second integer to be entered by user
TheSum		DWORD	?		; The sum of the integers
TheDiff		DWORD	?		; The difference of the integers
TheProd		DWORD	?		; The Product of the the integers
TheQuot		DWORD	?		; The quotient 
TheRem		DWORD	?		; The remainder 


.code
main PROC

DisplayAuthor:									; Displaying name and project title on the output screen
			
			mov		edx, offset myName			; EDX: has myName string
			call	writeString
			call	CrLf
			mov		edx, offset myProgram		; EDX: Has myProgram string
			call	writeString
			
			call	CrLf
			call	CrLf
			
			
Introduction:									; Displaying instructions/introduction to the user
		
			mov		edx, offset intro_1			; EDX: intro_1
			call	writeString
			call	CrLf
			mov		edx, offset intro_2			; EDX: intro_2
			call	writeString
			
			call	CrLf
			call	CrLf

			
GetIntegers:									; Getting the two integers here. Section called top for looping purposes
		
			call	CrLf
			call	CrLf
			mov		edx, offset prompt_1		; Prompting for first integer
			call	writeString
			call	ReadInt
			mov		integer_1, eax				; Get first integer and store in integer_1
			mov		edx, offset prompt_2		; Prompting for second integer
			call	writeString
			call	ReadInt
			mov		integer_2, eax				; Get second integer and store in integer_2
			
			mov		eax, integer_1
			cmp		eax, integer_2
			jle		GetIntegers					; Making sure integer 2 is less than integer 1		**EXTRA-CREDIT +1

			call	CrLf
			call	CrLf

			
Calculations:									; All calulations done here
			
			mov		eax, integer_1				; Getting the Sum
			mov		ebx, integer_2				
			add		eax, ebx					; Adding EBX to EAX
			mov		TheSum, eax

			mov		eax, integer_1				; Getting the Difference
			mov		ebx, integer_2
			sub		eax, ebx					; Subtracting EBX from EAX
			mov		TheDiff, eax				

			mov		eax, integer_1				; Getting the Product
			mov		ebx, integer_2
			mul		ebx							; Implied operand is in eax. 
			mov		TheProd, eax

			mov		eax, integer_1				; Getting quotient
			cdq									; extending sign into edx
			mov		ebx, integer_2				
			div		ebx							; Implied operand is in edx:eax
			mov		TheQuot, eax				; quotient is in eax
			mov		TheRem, edx					; remainder is in edx

			
PrintResults:									; Displaying Results here
			
			mov		edx, offset result_sum		; Display prompt for the sum
			call	writeString					; calling string to write out sum
			mov		eax, TheSum					; EAX: has the sum
			call	writeInt
			call	CrLf
			
			mov		edx, offset result_diff
			call	writeString
			mov		eax, TheDiff				; EAX: The difference
			call	writeInt
			call	CrLf
			
			mov		edx, offset result_prod
			call	writeString
			mov		eax, TheProd				; EAX: The product
			call	writeInt
			call	CrLf
			
			mov		edx, offset result_quot
			call	writeString
			mov		eax, TheQuot				;EAX: The quotient
			call	writeInt
			call	CrLf
			
			mov		edx, offset result_rem
			call	writeString
			mov		eax, TheRem					; EAX; The remainder
			call	WriteInt
			call	CrLf
			call	CrLf

LoopAgain:										; prompt to loop program again				**EXTRA CREDIT +1
			mov		edx, offset prompt_loop
			call	writeString
			call	readInt
			mov		loopanswer, eax
			mov		ebx, 1
			cmp		ebx, loopanswer
			je		GetIntegers
			call	CrLf
			call	CrLf

GoodBye:										; Saying good bye
			
			mov		edx, offset bye				; EDX : bye
			call	writeString
			call	CrLf
			call	CrLf

	exit		; exit to operating system
main ENDP
END main