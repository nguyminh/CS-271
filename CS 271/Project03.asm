TITLE Integer Accumulator			;(Project03.asm)

; Author: Minh Nguyen
; email: Nguyminh@onid.orst.edu
; Class: CS271 - 400
; Assignmentt: Program 3: Integer Accumulator
; Due Date: 7/27/2014
; Program Description: Gets user name and greets user.  Asks user to enter in numbers between 1 and 100. 
;                      Enter in negative number when user is done.  Adds all numbers entered and displays
;					   Computes average and displays. Says good bye with user's name.

INCLUDE Irvine32.inc



.data
myName			BYTE	"My name is Minh Nguyen and I am your program Designer this evening." , 0
myProgram		BYTE	"The Program is called Integer Accumulator." ,0
prompt_1		BYTE	"Please enter in your name here: " , 0

userName		BYTE	33 DUP(0)
greet_1			BYTE	"Hello " , 0
greet_2			BYTE	", and welcome to the Integer Accumulator program!" , 0
good_bye		BYTE	"Thank you for using Minh's Integer Accumulator program. Have a great day, " ,0

instructions	BYTE	"This program will require you to enter in integers less than or equal to 100" ,0
instructions_2	BYTE	"and gives you their sum and average. Enter in a negative number when you are" ,0
instructions_3	BYTE	"satisfied with your choices of integers." ,0
prompt_int		BYTE	"Please enter in a number: ", 0
prompt_high		BYTE	"The number previously entered is greater than 100. Please Try again!" ,0

numbers_print	BYTE	"The amount of numbers you entered was: " ,0
sum_print		BYTE	"The sum of your numbers is: " ,0
average_print	BYTE	"The rounded average is: " ,0

the_sum			DWORD	?
the_average		DWORD	?
the_numbers		DWORD	?
temp_num		DWORD	?


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
					
					mov		edx, offset instructions			;writing out strings from instruction variables
					call	writeString
					call	crlf
					mov		edx, offset instructions_2			;instruction_2
					call	writeString
					call	crlf
					mov		edx, offset instructions_3			;instruction_3
					call	writeString
					call	crlf
					call	crlf
				

getUserData:										;Prompt user data input, retreieve data input from user
					
					mov		edx, offset prompt_int				;prompts user to enter in an integer
					call	writeString
					call	readInt								;takes integer and puts into eax register
					cmp		eax, 0								;Validate if number is a negative number
					jl		Calculations						;If negative number, jump to calculations section
					cmp		eax, 100							;Validate if number is greater than 100
					jg		Too_high							;If greater than 100, jump to Too_high section

					add		the_sum, eax						;Takes integer read and add to sum variable
					mov		ebx, 1								;increments ebx by 1 in this loop
					add		the_numbers, ebx					;Accumulate integer  into variable the_numbers
					loop	getUserData							;Loops data input until negative number

Too_High:														;Section for number entered greater than 100
					mov		edx, offset prompt_high				;Prompts user number is too high and to try again
					call	writeString
					call	crlf
					call	crlf
					jmp		getUserData							;Jumps back into user input of data, does not count last input

					call	crlf
					call	crlf
Calculations:										;Calculates the average of the numbers
													;Sum is calculated inside loop in getUserData

					mov		eax, the_sum			;puts the calculated sum into eax
					cdq								;extends sign into into edx
					mov		ebx, the_numbers		;putting accumulated numbers into ebx
					div		ebx						;Divide the sum by the accumulated number to get average
					mov		the_average, eax		;mov the quotient into variable the_average for output
					call	crlf
					call	crlf





DisplayData:										;Print out sum and average on screen
				
					mov		edx, offset numbers_print				;prompt accumulated amount of integers added
					call	writeString
					mov		eax, the_numbers						;print out accumulated numbers
					call	writeInt
					call	crlf
					mov		edx, offset sum_print					;prompts sum of integers
					call	writeString
					mov		eax, the_sum							;Print out sum of integers
					call	writeInt
					call	crlf
					mov		edx, offset average_print				;prompts average of integers
					call	writeString
					mov		eax, the_average						;prints out average calculated in calculations section
					call	writeInt
					call	crlf
					call	crlf





farewell:												;Display farewell message
				
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