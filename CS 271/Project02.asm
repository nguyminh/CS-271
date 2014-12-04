TITLE Fibonacci Number			;(Project02.asm)

; Author: Minh Nguyen
; email: Nguyminh@onid.orst.edu
; Class: CS271 - 400
; Assignmentt: Program 2: Fibonacci Number
; Due Date: 7/13/2014
; Program Description: Get integer input from user between 1-46. Validate by post-testing, and display 
; fibonacci numbers of that integer. Have 5 spaces between numbers outputted, and a line-break after every 5 numbers.

INCLUDE Irvine32.inc



.data
myName			BYTE	"My name is Minh Nguyen and I am your program Designer this evening." , 0
myProgram		BYTE	"The Program is called Fibonacci numbers." ,0
prompt_1		BYTE	"Please enter in your name here (press Enter when finished) : " , 0

userName		BYTE	33 DUP(0)
greet_1			BYTE	"Hello " , 0
greet_2			BYTE	", and welcome to the Fibonacci numbers program!" , 0
good_bye		BYTE	"Thank you for using my program. Have a great day, " ,0

instructions	BYTE	"This program will require you to enter an integer from 1-46 and it will display the fibonacci numbers of that integer." ,0
prompt_int		BYTE	"Please enter in a number now (must be between 1 and 46): ", 0

upper_limit		DWORD	46
lower_limit		DWORD	1
input_int		DWORD	?
fibTerm1		DWORD	?
fibTerm2		DWORD	?
fibTerm3		DWORD	?

prompt_low		BYTE	"Post-testing tells me your input was too low! try again!" ,0
prompt_high		BYTE	"Post-testing tells me your input was too high! try again!" ,0
space_5			BYTE	"     ",0
loop_prompt		BYTE	"Would you like to enter another number? ( 1 for yes, any key for no ): " ,0
loop_answer		dword	?

.code
main PROC

Introduction:										;Prompt for user's name and display programmer's name
					mov		edx,offset myName		;displaying programmer name
					call	writeString
					call	CrLf
					call	CrLf

					mov		edx,offset myProgram    ;display program name
					call	writeString
					call	CrLf
					call	CrLf
					
					mov		edx,offset prompt_1		;prompt for user name
					call	writeString
					mov		edx,offset userName
					mov		ecx, 32
					call	readString				;read user name input
					call	CrLf
					call	CrLf
					
					mov		edx,offset greet_1		;greet user
					call	writeString
					mov		edx,offset userName		;write out user's name
					call	writeString
					mov		edx, offset greet_2
					call	writestring
					call	CrLf
					call	crlf




userInstructions:									;Explain user what this program does
					
					mov		edx, offset instructions
					call	writeString
					call	crlf
					call	crlf
				

getUserData:										;Prompt user data input, retreieve data input from user
					call	CrLf
					mov		edx, offset prompt_int	
					call	writeString
					call	readInt
					mov		input_int, eax			;store integer input in input_int
					jmp		displayFibs				;Go straight to fibonacci loop and run once, post-test is inside loop.
					
					

tooLow:														;jumps to this section if input is less than 1
					mov		edx, offset prompt_low
					call	writeString
					call	crlf
					call	crlf
					jmp		getUserData						;returns to prompt user again
					
tooHigh:													;jumps to this section if input is greater than 46
					mov		edx, offset prompt_high
					call	writeString
					call	crlf
					call	crlf
					jmp		getUserData						;return to prompt user again




	displayFibs:									;Calculate and display fibonnaci number here

					mov		ecx, input_int			;set loopcounter ecx to integer chosen by user
					mov		fibTerm1, 1				;initilize terms
					mov		fibTerm2, 1		
					mov		fibTerm3, 0
					mov		ebx, 0					;0 is initialized for counting amounts of numbers on each line

		clear:										;Section to clear to new line after 5 numbers are on one line
					call	CrLf
					mov		ebx, 0
					
					
					
		L1:											;Loop for Fibonacci numbers 
				
					inc		ebx						;increment ebx 
					cmp		ebx, 6					;If ebx is 6, jump to clear which  resets ebx, and moves line down 1
					je		clear					;makes sure only 5 numbers per line.
					
					mov		eax, fibTerm3			;move latest term into eax
					mov		fibTerm1, eax			;save this term in variable term1
					add		eax, fibTerm2			;add the 2nd previous term to the previous term
					call	writeInt				;display fibonacci number
					
					mov		edx,offset space_5		;allows 5 spaces in between each number
					call	writeString
					mov		fibTerm3,eax			;store this as latest term in fibTerm3
					mov		eax, fibTerm1			;move the old term1 into eax
					mov		fibTerm2, eax			;save this old term1 as term2
					

					;POST-TEST to check if number was valid. After running 1 loop of fibonacci
					mov		eax, input_int			
					cmp		lower_limit, eax		;check if input is less than 1 
					jg		tooLow					;if less than 1, go to tooLow
					
					mov		eax, input_int
					cmp		upper_limit, eax		;check if input is greater than 46
					jl		tooHigh					;if greater than 46, go to tooHigh
					
					Loop	L1						;loop instruction


farewell:												;Display farewell message
				
					call	CrLf
					call	CrLf
					mov		edx,offset loop_prompt	;prompt for entering in a new number	
					call	writeString				
					call	readInt
					mov		loop_answer,eax			;store loop answer 1 for yes, 0 for no
					cmp		eax, 1
					je		getUserData				;if 1 is entered, go back to get user data

					call	CrLf
					call	CrLf
					mov		edx,offset good_bye		;farewell
					call	writeString
					mov		edx,offset userName		;with user name
					call	writeString
					call	CrLf
					call	CrLf


	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main