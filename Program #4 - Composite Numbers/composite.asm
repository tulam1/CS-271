TITLE  Integer Composite		(composite.asm)

; Author: Tu Lam
; Last Modified: 2/16/2020
; OSU Email Address: lamtu@oregonstate.edu
; Course Number/Section: CS 271 Section #400
; Project Number: Program #4		Due Date: 2/16/2020
; Description: The program ask the user to enter a number in the range of [1...400].
;			   Then, if the user enter a number that is not composite, then re-prompt
;			   until the user enter the correct number and print out the composite number.
;			   Each line needs to produce 10 composite numbers.

INCLUDE Irvine32.inc

;This is the constant declaration
	UPPER_LIMIT = 400
	LOWER_LIMIT = 1
	NEW_LINE = 10
	DIVISOR_CONSTANT = 2
	REMAINDER = 0

;This include all the declaration of variable
.data
	;Message String
	title_comp		BYTE		"Composite Numbers          Programmed by Tu Lam",0
	border			BYTE		"-----------------",0
	instruct1		BYTE		"Enter the number of composite numbers you would like to see.",0
	instruct2		BYTE		"I'll accept orders for up to 400 composites.",0
	prompt			BYTE		"Enter the number of composites to display [1...400]: ",0
	error_occur		BYTE		"Out of Range. Try Again. ",0
	space3			BYTE		"   ",0
	farewell_m		BYTE		"Results certified by Tu Lam.  Goodbye!",0

	;Integer Input
	user_num		DWORD		?							;The input is save for the user
	column			DWORD		1							;This a counter that keeps track of keeping only 10 composite numbers on each line
	comp_num		DWORD		4							;Holding the first initial composite number
	divisor			DWORD		?							;Hold the value that use to divide the composite number
	factor_limit	DWORD		?							;This hold the factoring limit of the number (comp_num - 1)

;This section display all the codes for the program procedures
.code
main PROC
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell
	exit
main ENDP

;This procedure print out the program title and instruction
introduction PROC
	mov		EDX, OFFSET title_comp				;Print out the title of the program
	call	WriteString
	call	Crlf
	mov		EDX, OFFSET	border					;Print out the border as a divider
	call	WriteString
	call	Crlf
	call	Crlf								;Create an extra new line
	mov		EDX, OFFSET instruct1				;Print out the 1st set of instruction
	call	WriteString
	call	Crlf
	mov		EDX, OFFSET instruct2				;Print out the 2nd set of instruction
	call	WriteString
	call	Crlf
	call	Crlf
	ret
introduction ENDP

;This procedure let the user enter a number and then do the validation
getUserData PROC
	mov		EDX, OFFSET prompt					;Print out the prompt for user
	call	WriteString
	call	ReadInt								;Let user enter in a number
	mov		user_num, EAX						;Move and copy to the num variable
	call	validate
	ret
getUserData ENDP

;This sub-procedure is to validate if the use enter the number in the correct range
validate PROC
	mov		EAX, user_num						;Move user_num back into EAX register
	cmp		EAX, UPPER_LIMIT					;Compare to the upper limit
	jg		Error_In_The_Number					;Jump to error if the number is greater than 400
	cmp		EAX, LOWER_LIMIT					;Compare the lower limit
	jl		Error_In_The_Number					;Jump if the number is lower than 1
	jmp	    Done_Check							;Move to exit out of validation area

	;This section help to print out error message
	Error_In_The_Number:
		mov		EDX, OFFSET error_occur			;Print out error message
		call	WriteString
		call	Crlf
		call	getUserData						;Re-Prompt the user

	;This is after checking is done
	Done_Check:
		ret
validate ENDP

;This procedure will display the composite numbers
showComposites PROC
	mov		ECX, user_num						;Move the user number into the ECX for printing out how many composite there are

	;This is the counted loop for Composite numbers
	Counted_Loop_Comp:
		call	isComposite						;Call isComposite to calculate out the composite number

	;This section is for printing out the number
	Printing_Comp_Num:
		mov		EAX, comp_num
		call	WriteDec
		inc		comp_num						;Increment to move to the next comp_num
		mov		EDX, OFFSET space3
		call	WriteString
		mov		EAX, column				
		cmp		EAX, NEW_LINE					;Comparing the number of composite displaying on a line
		je		New_Line_Make					;Jump to new line if it is equal to 10
		inc		column							;If not, continue to increment num_of_com
		jmp		Next_Comp_Num					

	;Make a new line if the number has reaches 10
	New_Line_Make:
		call	Crlf
		mov		EAX, 1							;Reset the counter back to 1
		mov		column, EAX
		jmp		Next_Comp_Num

	;This is for looping back the counted loop and dec ECX
	Next_Comp_Num:
		loop	Counted_Loop_Comp				;Loop back to get the next composite number
	
	ret
showComposites ENDP

;This procedure help with determine if the number is a composite or not
isComposite PROC
	;This is the set up for finding factoring
	Factoring_Set_Up:
		mov		EAX, comp_num					;Move comp_num into register
		mov		divisor, DIVISOR_CONSTANT		;Set the division by 2
		sub		EAX, 1							;Subtract 1 from comp_num to find factor limit
		mov		factor_limit, EAX				;Move the new value into the factor_limit

	;This section will help to identify the composite number and finding the factor
	Comp_And_Factor:
		mov		EAX, comp_num
		cdq										;Expand from EAX:EDX
		div		divisor							;Divide the comp_num by the divisor
		cmp		EDX, REMAINDER					;Compare the remainder in the EDX
		je		Found_Comp						;If the remainder = 0, then composite is found and jmp to exit
		add		divisor, 1						;If not, then add 1 to the divisor
		mov		EAX, divisor
		cmp		EAX, factor_limit				;Compare the max factor limit of that current comp_num and the divisor
		jle		Comp_And_Factor					;If there is more than one factor, jump back to the same section
		inc		comp_num						;If fail to find factor, increment the comp_num
		jmp		Factoring_Set_Up				;Go back to reseting the factor set up as a new number is introduce

	;This will exit this procedure if composite is found
	Found_Comp:
		ret
isComposite	ENDP

;This procedure just print out the farewell message
farewell PROC
	call	Crlf
	call	Crlf
	mov		EDX, OFFSET farewell_m				;Display the farewell message
	call	WriteString
	call	Crlf
	ret
farewell ENDP

END main