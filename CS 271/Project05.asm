TITLE Project 5			(Project5.asm)

; Author: Minh Nguyen
; email: Nguyminh@onid.orst.edu
; Class: CS271 - 400
; Assignment: 05
; Due Date: 8/17/2014
; Program Description: Introduce program. Get a user request of an integer from 10-200. Generate a requested amount of
;						random integers in the range of 100-999.  store in consecutive array.
;						Display integers before sorting, 10 numbers per line and sort in descending order
;						Calculate and display median value, and display sorted list, 10 numbers per line.

INCLUDE Irvine32.inc


DIVIDE macro first, second						;a macro to use for division mod		
					mov		eax, first
					mov		ebx, second
					mov		edx, 0
					div		ebx
ENDM

STACK_FRAME	macro								;a macro for setting up the stack frame
					push	ebp
					mov		ebp, esp
ENDM

;		Required global constants here
MIN = 10
MAX = 200
LO = 100
HI = 999
NULL = 0


.data
intro_1			BYTE	"This program is called the Random Integer Sorter: by Minh Nguyen", 10, 13, 0
intro_2			BYTE	"It will create a list of integers in the range of 100-999 and sort ", \
						 "them in descending order", 10, 13,0
						 
intro_3			BYTE	"User will in an integer from 10-200 to indicate amount of integers they'd ", \
						"like to see.", 10, 13, 0
prompt_1		BYTE	"Enter in amount of random integers you'd like to see(between 10-200): ", 0
error_1			BYTE	"Input out of range. Try again!" ,10, 13, 0
space			BYTE	"          ", 0
list_1			BYTE	"----------The random numbers before sorting -------- ", 10, 13,0
list_2			BYTE	"----------THe random numbers after sorting ----------", 10,13,0
med				BYTE	"The median: ",0

input			DWORD	?					;user's input for amount of random integer
arr_pointer		DWORD	?					;pointer for the array
Heap			DWORD	?					;used to handle heap
dwFlags			DWORD	HEAP_ZERO_MEMORY	;set all bytes to 0


.code
main PROC

				call	Randomize				;Start the random generator
				push	OFFSET intro_1
				push	OFFSET intro_2
				push	OFFSET intro_3
				call	introduction

				push	OFFSET	prompt_1
				push	OFFSET	error_1
				push	OFFSET	input
				call	getData

				mov		eax, input				;change user input from byte -> DWORD
				mov		ebx, 4
				mul		ebx
				mov		edx, eax

				INVOKE	getprocessHeap			;allocating heap and array memory
				mov		Heap, eax
				INVOKE	HeapAlloc, Heap, dwFlags, edx
				mov		arr_pointer, eax
		
				push	OFFSET	list_1
				push	OFFSET	space
				push	arr_pointer
				push	input
				call	fillARR
				call	showList
				
				push	arr_pointer
				push	input
				call	sortArray

				push	OFFSET	med
				push	arr_pointer
				push	input
				call	showMed

				push	OFFSET	list_2
				push	OFFSET	space
				push	arr_pointer
				push	input
				call	showList

				INVOKE	HeapFree, Heap, dwFlags, arr_pointer			;free heap and array memory
				
				


	exit		; exit to operating system
main ENDP

introduction	PROC
;---------------------------------------------------------------------
;Prints out introduction 
;receives: intro_1, intro_2, intro_3
;returns: nothing
;---------------------------------------------------------------------
			STACK_FRAME
			;ebp+16 = intro_1
			;ebp+12 = intro_2
			;ebp+8 = intro_3

			mov		edx, [ebp+16]
			call	writeString
			mov		edx, [ebp+12]
			call	writeString
			mov		edx,[ebp+8]
			call	writeString
			pop		ebp
			ret		12
introduction	ENDP



getData		PROC
;-----------------------------------------------------------------
;Prompts user for integer input within range and validates.
;Stores input into the input variable
;receives: prompt_1, error_1, input
;returns: nothing
;-----------------------------------------------------------------
			STACK_FRAME

			;ebp+16 = prompt_1
			;ebp+12 = error_1
			;ebp+8 = address of input

receiving:	
			mov		edx, [ebp+16]
			call	writeString
			call	readInt
			call	crlf
			
			;data validation
			cmp		eax, MIN
			jl		err
			cmp		eax, MAX
			jg		err

			;storing data to input
			mov		ebx, [ebp+8]
			mov		[ebx], eax
			jmp		finish

err:	
			mov		edx, [ebp+12]
			call	writeString
			jmp		receiving

finish:
			pop		ebp
			ret		12

getData		ENDP


fillARR		PROC
;---------------------------------------------------------------
;Pass in array and fill it with random integers generated
;receives: arr_pointer, input
;returns: nothing
;--------------------------------------------------------------
			STACK_FRAME
	;ebp+12 = arr_pointer
	;ebp+8 = input

			mov		eax, ((HI-LO)+1)
			mov		ecx, [ebp+8]
			mov		edx, 0
			mov		esi, [ebp+12]

filling:
			call	RandomRange
			add		eax, LO
			mov		[esi], eax
			add		esi, 4
			loop	filling
			pop		ebp
			ret		

fillARR			ENDP					

SortArray		PROC
LOCAL			local_input: DWORD
;----------------------------------------------------------
;Sorts the array in descending value
;receives: arr_pointer, input
;returns: nothing
;----------------------------------------------------------
	;ebp+8 = input
	;ebp+12 = arr_pointer
				
				mov		eax, [ebp+8]
				mov		local_input, eax			;local variable for number of elements
				dec		local_input					;set offset to 0
				mov		esi, [ebp+12]
				mov		ecx, local_input

L1:													;L1 is outer Loop to loop through array
				push	ecx							;keep track of outter loop count
				mov		ecx, local_input			;start inner loop over
				mov		esi, [ebp+12]				;set esi to element 0 in array
L2:
				mov		eax, [esi]	
				cmp		[esi+4], eax
				jl		less
				push	[esi+4]						;swap i and j
				push	[esi]
				call	swapThem
				pop		[esi]
				pop		[esi+4]
less:
				add		esi, 4						;move to next element in array
				loop	L2
				pop		ecx
				loop	L1
Finish:
				ret 8

SortArray		ENDP

swapThem		PROC
;----------------------------------------------------
;Swaps array[i] and array[j]
;receives: array[i], array[j]
;returns: array[j], array[i]
;----------------------------------------------------
			STACK_FRAME
		;ebp+12 = array[i]
		;ebp+8 = array[j]
			
				mov		eax, [ebp+12]
				mov		ebx, [ebp+8]
				mov		[ebp+12], ebx
				mov		[ebp+8], eax
				pop		ebp
				ret
swapThem		ENDP


showMed			PROC
LOCAL			divisor: DWORD, array_size: DWORD, median: DWORD, lower: DWORD, higher: DWORD
;---------------------------------------------------------------------------------------------
;Find the median values of the array of integers.  
;Receives: med, arr_pointer, input
;returns: nothing
;----------------------------------------------------------------------------------------------
		;ebp+8 = input
		;ebp+12 = arr_pointer
		;ebp+16 = med
					
				mov		divisor, 2
				mov		eax, [ebp+8]
				mov		esi, [ebp+12]
				mov		array_size, eax

				DIVIDE	array_size, 2
				mov		median, eax
				mov		eax, median
				mov		ebx, 4
				mul		ebx
				mov		ecx, eax
				mov		eax, [esi+ecx]
				mov		higher, eax
				mov		eax, [esi+ecx-4]
				mov		lower, eax

				DIVIDE	array_size, 2
				cmp		edx, 0
				jg		printOut

				fild	higher
				fiadd	lower
				fidiv	divisor
				fistp	higher
	
	printOut:
				mov		edx, [ebp+16]
				call	writeString
				mov		eax, higher
				call	writeDec
				call	crlf
				call	crlf
	finish:
				ret 12

showMed			ENDP

showList		PROC
;-----------------------------------------------------------
;Print out the contents of the array. 10 elements per row
;receives: list_1 or list_2, space, arr_pointer, input
;returns: array[j], array[i]
;-----------------------------------------------------------		
				STACK_FRAME
		;ebp+20 = list_1 or list_2
		;ebp+16 = space
		;ebp+12 = arr_pointer
		;ebp+8 = input
		
				mov		edx, [ebp+20]
				call	writeString
				mov		edx, [ebp+16]
				mov		esi, [ebp+12]
				mov		ecx, [ebp+8]
				mov		ebx, 0

showListloop:
				mov		eax, [esi]
				call	writeDec
				call	writeString
				add		esi, 4
				cmp		ebx, 10
				jne		continue
				mov		ebx, 0
				inc		ebx
				call	crlf
continue:
				loop	showListloop
				call	crlf
				call	crlf
				pop		ebp
				ret		16
showList		ENDP

END main




END main