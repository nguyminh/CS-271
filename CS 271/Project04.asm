TITLE Prime Numbers			;(Project04.asm)

; Author: Minh Nguyen
; email: Nguyminh@onid.orst.edu
; Class: CS271 - 400
; Assignmentt: Program 3: Prime Numbers
; Due Date: 8/03/2014
; Program Description:  Asks user to enter in a number between 1-200. Displays that many prime numbers from 1 to input.  

INCLUDE Irvine32.inc



.data
myName			BYTE	"My name is Minh Nguyen and I am your program Designer this evening." , 0
myProgram		BYTE	"The Program is called Prime numbers." ,0
good_bye		BYTE	"Thank you for using Minh's Prime Numbers program. Have a great day, " ,0

instructions	BYTE	"Enter the number of prime numbers you'd like to see." ,0
instructions_2	BYTE	"Numbers must be between 1 and 200 primed and I will display them to you" ,0
prompt_int		BYTE	"Please enter in a number between 1 and 200: ", 0
ErrorLog		BYTE	"Out of range. Please try again" , 0

lowerLimit		DWORD	1
upperLimit		DWORD	200
full_lines		DWORD	10
spaces			BYTE	"   ", 0
newLine			BYTE	"   ", 0
rangeCheck		DWORD	?
primeCheck		DWORD	?
ThePrime		DWORD	?
current			DWORD	2
PrimeOut		DWORD	?

.code
main PROC
			
				call introduction			
				call getUserData
				call showPrimes
				call farewell


	exit		; exit to operating system
main ENDP

;-------------------------------------------------
introduction	PROC	uses edx,
;Displays program name, designer, and instructions
;receives: nothing
;returns: nothing
;--------------------------------------------------
				mov		edx, OFFSET	myName
				call	writeString
				call	Crlf
				mov		edx, OFFSET	myProgram
				call	writeString
				call	Crlf
				call	Crlf
				mov		edx, OFFSET	instructions
				call	writeString
				call	Crlf
				mov		edx, OFFSET instructions_2
				call	writeString
				call	Crlf
				call	Crlf
				ret
introduction ENDP

;-------------------------------------------------------------------------------
getUserData		PROC	USES eax edx,
;Prompt user to enter in integer. Shows error message if out of range of 1-200
;Repeat til correct entry
;Receives: nothing
;Returns: Nothing
;--------------------------------------------------------------------------------
	
	getData:
				mov		edx, OFFSET prompt_int
				call	writeString
				call	readInt
				mov		thePrime, eax
				call	validate				;validate to make sure number is in range
				
				cmp		rangeCheck, 1		      ;if rangeCheck is 1, error is out of range
				je		getData
	
	
	finish:		
				call	Crlf
				ret
	
	getUserData ENDP
	
	
;------------------------------------------------------
validate	PROC  USES	eax edx,		
;Validates that input is in range of 1-200. 
;Recieves: nothing
;Returns:  nothing
;------------------------------------------------------
				mov		eax, thePrime
				cmp		eax, lowerLimit
				jl		badEntry			;jump to error section if number is lower than 1
				cmp		eax, upperLimit
				jg		badEntry
				jmp		finish				;jump to error section if number is greater than 200

	badEntry:
				mov		edx, OFFSET	ErrorLog
				call	writeString				;displays error message
				call	Crlf
				mov		rangeCheck, 1		;moves range check to 1 for use in getUserData procedure
				ret

	finish:
				mov		rangeCheck, 0		;if no error, then rangeCheck is 0
				ret

validate ENDP

;------------------------------------------------------------------
showPrimes PROC	USES eax,
;Calculates and prints out prime numbers up to user input integer
;Recieves: nothing
;Returns: nothing
;-------------------------------------------------------------------
				mov		eax, thePrime
				cmp		eax, 1
				je		specialCase		;if number was 1, then move to special case section

	PrimeCalc:	
				mov		primeCheck, 0
				call	isPrime			
				cmp		primeCheck, 1
				je		PrimeDisplay	;print number if prime check is 1

				inc		current			;move to next number
				mov		eax, PrimeOut	
				cmp		eax, thePrime
				jl		PrimeCalc		;loop again if amount of prime shown is still less than integer inputted
				jmp		finish			;leave if finished

	PrimeDisplay:
				mov		eax, 00000000h			;reset eax register
				mov		eax, current			;
				call	writeDec
				mov		edx, OFFSET spaces		;makes use of 3 spaces
				call	writeString
				inc		PrimeOut				;increment primed numbers outputted
				inc		current					;increment current to the next number

				mov	    edx, 00000000h			;reset edx to check if line is full
				mov		eax, PrimeOut
				div		full_lines
				cmp		edx, 0					;if 10 numbers are displayed, go to clearline
				je		clearLine
				jmp		PrimeCalc				;if not, go back to the primeCalc section

	clearLine:
				call	Crlf
				jmp		PrimeCalc

	specialCase:								;special case for entering 1 as input
				mov		eax, 00000000h
				mov		eax, 2					;prints out 2, as the very first prime number
				call	writeDec

	finish:										
				call	Crlf
				call	Crlf
				ret

showPrimes ENDP

;--------------------------------------------------
isPrime	  PROC USES eax ecx edx,
;validates if input was a prime number
;Recieves: Nothing
;Returns: Nothing
;--------------------------------------------------
				mov		ecx, 00000000h			;reset ecx register
				mov		ecx, current			
				dec		ecx						;must start -1 of the integer input
	check:
				cmp		ecx, 1
				je		setCheck				;leave loop if ecx is 1
				mov		edx, 00000000h			;reset edx for remainder
				mov		eax, current
				div		ecx						
				cmp		edx, 0
				je		finish					;if remainder is 0, ecx is not prime
				loop	check

	setCheck:									;set primeCheck to 1, indicate it's not a prime number
				mov		primeCheck, 1

	finish:										
				ret
isPrime	ENDP

;-------------------------------------------
farewell	PROC USES edx,
;Displays good bye message to user
;Receives: nothing
;returns: nothing
;------------------------------------------
				mov		edx, OFFSET	good_bye
				call	writeString
				call	Crlf
				call	Crlf
				ret
farewell ENDP


END main


