TITLE  Sorting & Counting Random Integers		(random.asm)

; Author: Tu Lam
; Last Modified: 2/29/2020
; OSU Email Address: lamtu@oregonstate.edu
; Course Number/Section: CS 271 Section #400
; Project Number: Program #5		Due Date: 3/1/2020
; Description: The program will display up to 200 unsorted integers ranging from [10...29]
;			   into an array. Then the number will be sorted and will display the median of
;			   the array and also the integers will be counted to display how many numbers there
;			   is in the whole array. [Ex: If there are 4 of the number 10, then display 4 has been counted.]
;			   This assignment will be done in Register Indirect Address.

INCLUDE Irvine32.inc

;This section include all the CONSTANT variables
	LO = 10
	HI = 29
	ARRAYSIZE = 200
	NEW_LINE = 20
	COUNTER = 1
	COUNTARRAY = 20


;This all the global variables delcaration
.data
	;String Variables
	title_prog		BYTE		"Sorting & Counting Random Integers!          Programmed by Tu Lam",0
	border			BYTE		"-----------------------------------",0
	str_1			BYTE		"This program generates 200 random numbers in the range [10 ... 29], displays the",0
	str_2			BYTE		"original list, sorts the list, displays the median value, displays the list sorted in",0
	str_3			BYTE		"ascending order, then displays the number of instances of each generated value.",0
	unsort			BYTE		"Your unsorted random numbers:",0
	sorted			BYTE		"Your sorted random numbers:",0
	med_str			BYTE		"List Median: ",0
	space2			BYTE		"  ",0
	list_count		BYTE		"Your list of instances of each generated number, starting with the numbers of 10s:",0
	gdbye			BYTE		"Goodbye, and thank you for using my program!  Go CS 271!!",0

	;Integers/Array Variables
	arr				DWORD		ARRAYSIZE		DUP(?)
	list			DWORD		20				DUP(?)
	count			DWORD		COUNTER							;Set counter to 1 for the line space
	arr_num			DWORD		1								;This will be use to increment at each index of the list array
	

;This section is where the program will run
.code
main PROC
	;This will make the number randomize everytime it is run
	call	Randomize

	;Pass string by reference into the introduction
	push	OFFSET title_prog
	push	OFFSET border
	push	OFFSET str_1
	push	OFFSET str_2
	push	OFFSET str_3
	call	introduction

	;Pass CONSTANT as value & array as reference into the fillArray procedure
	push	ARRAYSIZE
	push	HI
	push	LO
	push	OFFSET arr
	call	fillArray

	;This section is to help print out the unsortList
	mov		EDX, OFFSET unsort
	call	WriteString
	call	Crlf
	push	ARRAYSIZE
	push	count
	push	NEW_LINE
	push	COUNTER
	push	OFFSET space2
	push	OFFSET arr
	call	displayList

	;This section will pass in a CONSTANT as a value and arr as a reference for sorting
	push	ARRAYSIZE
	push	OFFSET arr
	call	sortList
	call	Crlf

	;This section will pass ARRAYSIZE as value and arr & median as reference for displaying the median
	push	OFFSET med_str
	push	OFFSET arr
	push	ARRAYSIZE
	call	displayMedian
	call	Crlf

	;This section is for printing out the sorted array
	mov		EDX, OFFSET sorted
	call	WriteString
	call	Crlf
	push	ARRAYSIZE
	push	count
	push	NEW_LINE
	push	COUNTER
	push	OFFSET space2
	push	OFFSET arr
	call	displayList

	;This section is for the countedList
	push	arr_num
	push	ARRAYSIZE
	push    LO
	push	OFFSET arr
	push    OFFSET list
	call	countList
	call	Crlf
	mov		EDX, OFFSET list_count
	call	WriteString
	call	Crlf
	push	COUNTARRAY
	push	count
	push	NEW_LINE
	push	COUNTER
	push	OFFSET space2
	push	OFFSET list
	call	displayList


	;This section is for saying the goodbye message
	call	Crlf
	mov		EDX, OFFSET gdbye
	call	WriteString
	call	Crlf
	
	exit
main ENDP


; /***********************************************************************************
;  * Description: This procedure display the TITLE of the program and the instruction 
;  *			  what the program will do.
;  * Receive(s):  String {title_prog, border, str_1, str_2, str_3}
;  * Return(s):	  None to return
;  * Precondition(s): None preconditions are required
;  * Registers Changed: EDX
;  * Postcondition(s): None
;  **********************************************************************************/
introduction PROC
	push	EBP						;Set up the stack frame
	mov		EBP, ESP

	mov		EDX, [EBP + 24]			;Display the title_prog string
	call	WriteString
	call	Crlf
	mov		EDX, [EBP + 20]			;Display the border
	call	WriteString
	call	Crlf
	mov		EDX, [EBP + 16]			;Display the first part of the instruction
	call	WriteString
	call	Crlf
	mov		EDX, [EBP + 12]			;Display the second part of the intruction
	call	WriteString
	call	Crlf
	mov		EDX, [EBP + 8]			;Display the third part of the intruction
	call	WriteString
	call	Crlf
	call	Crlf

	pop		EBP						;Pop the EBP (Old ret)
	ret		20
introduction ENDP


; /***********************************************************************************
;  * Description: This procedure will fill in the array of size 200 and only display 
;  *			  the number in range of [10...29]
;  * Receive(s):  Value {LO, HI, ARRAYSIZE}		Reference {arr}
;  * Return(s):	  Return the array with n.. random integers
;  * Precondition(s): None preconditions are required
;  * Registers Changed: EAX, ECX, EDI
;  * Postcondition(s): None
;  **********************************************************************************/
; Reference to the Week 7 for the array fill in
fillArray PROC
	push	EBP						;Set up the stack frame
	mov		EBP, ESP

	;Set-Up the Loop
	mov		ECX, [EBP + 20]			;Copied the ARRAYSIZE into the ECX
	mov		EDI, [EBP + 8]			;Set up the first element into array (Using indirect address)

	Counted_Loop_Array:
		mov		EAX, [EBP + 16]		;Move the HI constant onto the EAX
		sub		EAX, [EBP + 12]		;Take 29 - 10
		inc		EAX					;Add 1 to make it 20 [0...19]
		call	RandomRange			;Generate a random number in the range [0...19]
		add		EAX, [EBP + 12]		;Add LO back to be in range [10...29]
		mov		[EDI], EAX			;Copied the value into array
		add		EDI, 4				;Move to the next element
		loop	Counted_Loop_Array	;Loop back to the label and run again until fill up the array
	
	pop		EBP						;Pop the EBP (Old ret)
	ret		16
fillArray ENDP


; /*****************************************************************************************
;  * Description: This procedure display the array 
;  * Receive(s):  Value {NEW_LINE, count, COUNTER, ARRAYSIZE}		Reference {arr, space2}
;  * Return(s):	  Return the array with n.. random integers
;  * Precondition(s): None preconditions are required
;  * Registers Changed: EAX, ECX, ESI, EBX, EDX
;  * Postcondition(s): None
;  ****************************************************************************************/
; Reference to the Week 7 module for displaying of array
displayList PROC
	push	EBP						;Set up the stack frame
	mov		EBP, ESP

	;Set-Up the Loop
	mov		ECX, [EBP + 28]			;Copied the ARRAYSIZE into the ECX
	mov		ESI, [EBP + 8]			;Set up the first element into array (Using indirect address)
	mov		EBX, [EBP + 24]			;Set up the EBX with the count

	CL_Display:
		mov		EAX, [ESI]			;Copy element into EAX
		call	WriteDec
		mov		EDX, [EBP + 12]		;Print out the space
		call	WriteString
		inc		EBX					;Add 1 to the count
		add		ESI, 4				;Move to the next element
		cmp		EBX, [EBP + 20]		;Compare EBX with NEW_LINE
		jg		Create_Line			;If it is equal to 20, jump to reset
		loop	CL_Display			;Loop back to the label and run again until finished print the array
		jmp		Exit_Print			;After array is done, exit

	Create_Line:
		mov		EBX, [EBP + 16]		;Reset count
		call	Crlf
		loop	CL_Display			;Go back to the loop

	Exit_Print:
		pop		EBP					;Pop the EBP (Old ret)
		ret		24
displayList ENDP


; /****************************************************************************************************************
;  * Description: This procedure will sort the array adn swap the index if needed
;  * Receive(s):  Reference {arr}            Value {ARRAYSIZE}
;  * Return(s):	  Sort the array and see if the array is in ascending order
;  * Precondition(s): None preconditions are required
;  * Registers Changed: ECX, EDX, EDI
;  * Postcondition(s): None
;  ***************************************************************************************************************/
sortList PROC
	push	EBP						;Set up the stack frame
	mov		EBP, ESP

	;Set up the counted-loop
	mov		ECX, [EBP + 12]			;Move the ARRAYSIZE into the ECX
	mov		EDX, 0					;Set EDX to equal 0 to make sure it is 0
	dec		ECX						;Subtract 1 to make it 199 instead of 200
	
	;This label is the counted-loop for sorting
	Sorting:
		mov		EDI, [EBP + 8]		;Move the first element at current index into EDI
		mov		EDX, ECX			;Make a copy of the ARRAYSIZE into EDX
		push	EDI					;Push EDI and ECX on the stack
		push	ECX
		call	exchangeElements	;Call exchangeElements to swap numbers
		mov		ECX, EDX
		loop	Sorting				;Loop back to sorting

	pop		EBP						;Pop the EBP (old ret)
	ret		8	
sortList ENDP


; /******************************************************************************************************
;  * Description: This procedure will display the unsorted list of the array
;  * Receive(s):  Reference {arr, ARRAYSIZE}
;  * Return(s):	  Swap element in the array
;  * Precondition(s): None preconditions are required
;  * Registers Changed: EDI, EAX, EBX
;  * Postcondition(s): None
;  *****************************************************************************************************/
exchangeElements PROC
	push	EBP						;Set up the stack frame
	mov		EBP, ESP

	Swap:
		mov		EAX, [EDI]			;Move the first element into the EAX
		mov		EBX, [EDI + 4]		;Get the next element and move it into the EBX
		cmp		EAX, EBX			;Compare the EAX and EBX
		jle		Move_Next			;If the comparision is less and equal to the next index, skip to Move_Next
		mov		[EDI], EBX			;Swap the EAX and EBX into the array if EAX is greater
		mov		[EDI + 4], EAX
	
	Move_Next:
		add		EDI, 4				;Increment on the next element
		loop	Swap				;Loop back into the 

	Done:
		pop		EBP					;Pop the EBP (Old ret)
		ret		8
exchangeElements ENDP


; /******************************************************************************************************
;  * Description: This procedure will find the median in the array
;  * Receive(s):  Reference {arr, ed_str}        Value {ARRAYSIZE}
;  * Return(s):	  The median in the array
;  * Precondition(s): Have the array to be sorted
;  * Registers Changed: EDI, EAX, EBX, EDX
;  * Postcondition(s): None
;  *****************************************************************************************************/
displayMedian PROC
	push	EBP						;Set up the stack frame
	mov		EBP, ESP

	mov		EAX, [EBP + 8]			;Move ARRAYSIZE into EAX
	mov		EDI, [EBP + 12]			;Move array to get first element into EDI
	mov		EBX, 2					;Move 2 into the EBX as a divisor
	div		EBX						;Take 200 divide by 2 to get 100
	dec		EAX						;Minus 1 to get 99
	mov		EBX, EAX				;Move 99 into the EBX to make a copy of the value
	imul	EAX, 4					;Multiply 99 with 4 to get the index number in the array at that number
	add		EDI, EAX				;Add the EAX to EDI to get to the index at 99
	mov		EAX, [EDI]				;This to get the first median number
	add		EBX, 1					;EBX 99 add 1 to make it 100
	imul	EBX, 4					;Multiply 4 into EBX to get the second number index
	mov		EDI, [EBP + 12]			;Move the array to the first element again in the EDI
	add		EDI, EBX				;Get to the index at 100 by adding the EBX to EDI
	mov		EBX, [EDI]				;Move the second median number into the EBX
	add		EAX, EBX				;Add the two numbers together
	mov		EBX, 2					;Make EBX a divisor
	div		EBX						;Take EAX divide by EBX to get average median

	mov		EDX, [EBP + 16]			;Move med_str into EDX
	call	WriteString
	call	WriteDec				;Write the median number

	pop		EBP						;Pop the EBP (Old ret)
	ret		12
displayMedian ENDP


; /******************************************************************************************************
;  * Description: This procedure will do a count in the array list and see how many numbers appear
;  * Receive(s):  Reference {arr, list}        Value {ARRAYSIZE, LO, arr_num}
;  * Return(s):	  An array with a list of how much the numbers appear
;  * Precondition(s): Have the array to be sorted
;  * Registers Changed: EDI, EAX, EBX, ECX, EDX
;  * Postcondition(s): None
;  *****************************************************************************************************/
countList PROC
	push	EBP						;Set up the stack frame
	mov		EBP, ESP

	;Set up the loop
	mov		ECX, [EBP + 20]			;Move ARRAYSIZE into ECX
	mov		EDI, [EBP + 12]			;Move the arr into the EDI
	mov		EDX, 0					;Set EDX to 0

	Loop_Count:
		add		EDI, EDX			;Add the EDX which hold the index number into the sorted array
		mov		EAX, [EDI]			;Move the element in the arr into EAX based on index of EDX
		sub		EAX, [EBP + 16]		;Subtract the value of EAX using LO
		mov		EBX, EAX			;Move the value after it subtract in EBX
		imul	EBX, 4				;Multiply the EBX to get to the new array index
		mov		EDI, [EBP + 8]		;Move the new array into EDI
		mov		EAX, [EBP + 24]		;Move the arr_num which hold the value 1 into EAX
		add		EDI, EBX			;Add the index number to the array
		add		[EDI], EAX			;Add the value of the counter at that index
		mov		EDI, [EBP + 12]		;Move the old array (sorted 200 nums) into EDI
		add		EDX, 4				;Add 4 into the EDX
		dec		ECX					;Decrement 1 in the ECX
		jnz		Loop_Count			;Loop back if counter is not 0
		jmp		Done_Count			;Jmp done if all 200 numbers have been loop

	Done_Count:
		pop		EBP					;Pop the EBP (Old ret)
		ret		20
countList ENDP

END main