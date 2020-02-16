TITLE Fibonacci Numbers		(fibonacci.asm)

; Author: Tu Lam
; Last Modified: 1/25/2020
; OSU Email Address: lamtu@oregonstate.edu
; Course Number/Section: CS 271 Section #400
; Project Number: Program #2		Due Date: 1/26/2020
; Description: The program ask the user for their name and ranging from 1-46,
;              the user need to input in how many Fibonacci Numbers to be display.
;              Also check for out-of-range error and display the number correctly.

INCLUDE Irvine32.inc

;This is the constant for comaparision later on
	UPPER_LIMIT	= 46
	LOWER_LIMIT = 1
	COLUMN_LIMIT = 5

;This include all the declaration of variable
.data
	program_title	BYTE	"Fibonacci Numbers",0
	border			BYTE	"-----------------",0
	programmer		BYTE	"Programmed by Tu Lam",0
	ask_name		BYTE	"What's Your Name? ",0
	greet_user		BYTE	"Hello, ",0
	user_name		BYTE	40 DUP(0)		;Save user's name in here
	fi_num			DWORD	?				;Number of Fibonacci Number to print save
	instruct1		BYTE	"Enter the number of Fibonacci terms to be displayed",0
	instruct2		BYTE	"Give the number as an integer in the range [1...46]",0
	prompt_num		BYTE	"How many Finbonacci terms do you want? ",0
	error_bound		BYTE	"Out of range. Please enter a number ranging from [1...46]",0
	num				DWORD	0				;Fibonacci keep track
	tmp_num			DWORD	1				;Help adding the Fibonacci Number
	fi_space		BYTE	"     ",0		;5 spaces
	columns			DWORD	1				;Count the column
	verify			BYTE	"Results certified by Tu Lam.",0
	gdbye			BYTE	"Goodbye! ",0
	peri			BYTE	".",0


;This section display all the codes for the program procedures
.code
main PROC

	;Dipslaying the program title and who created it
	Program_Intro:
		mov		EDX, OFFSET program_title
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET border
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET programmer
		call	WriteString
		call	Crlf
		call	Crlf

	;This ask the user to enter their name & display the instruction
	Ask_For_Name:
		mov		EDX, OFFSET ask_name		;Ask the user for their name
		call	WriteString
		mov		EDX, OFFSET user_name
		mov		ECX, SIZEOF user_name
		call	Readstring					;Let the user enter their name
		mov		EDX, OFFSET greet_user		;Display "Hello, "
		call	WriteString
		mov		EDX, OFFSET	user_name		;Display user's name
		call	WriteString	
		call	Crlf
		mov		EDX, OFFSET	instruct1		;Display the set of the instruction in instruct1 & instruct2
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET instruct2
		call	WriteString
		call	Crlf
		call	Crlf

	;Ask user to enter how many number to print out and check for error
	Ask_Number_Loop:
		mov		EDX, OFFSET prompt_num		;Display the instruction asking user to enter a number of term for Fibonacci
		call	WriteString
		call	ReadInt						;User enter the number in here
		mov		fi_num, EAX					;Move the number ans save it in the fi_num variable
		cmp		fi_num, UPPER_LIMIT			;Post-test condition to see if it is in range with the upper limit
		jg		Out_Of_Range
		cmp		fi_num, LOWER_LIMIT			;Post-test condition to see if it is in range with the lower limit
		jl		Out_Of_Range
		call	Crlf
		jmp		Fibonacci_Pattern_Set_Up	;Else if everything is correct, jump to the printing section

		
	;This area display the out-of-range bound
	Out_Of_Range:
		call	Crlf
		mov		EDX, OFFSET error_bound		;Display error message
		call	WriteString
		call	Crlf
		jmp		Ask_Number_Loop				;Jump back to the section to ask user again until the number is in range

	;Fibonacci Numbers setting it up
	Fibonacci_Pattern_Set_Up:
		mov		EBX, num					;Set up the adding of the Fibonacci Number
		mov		ECX, fi_num					;If the number is correct, save the number for loop print out

	;Printing the Fibonacci numbers by term
	Print_Fibonacci:
		mov	    EAX, EBX					;Copy the data
		add		EAX, tmp_num				;Add the number by F(n)
		call	WriteDec					;Display the number
		mov		EDX, OFFSET fi_space		;Display the space "     "
		call    WriteString
		mov		tmp_num, EBX				;Update the F(n) number
		mov		EBX, EAX					;Update the printed number to the next Fibonacci Number
		cmp		columns, COLUMN_LIMIT		;Compare if the number of column have reach to 5 yet
		jge		New_Row
		inc		columns						;If column have not reach 5, add 1 to the column
		jmp		Current_Row					

	;This print out new row if column reach the limit
	New_Row:
		call	Crlf						;Make new line
		mov		columns, 1					;Reset the column

	;Keep printing out the Fibonacci Number
	Current_Row:
		loop	Print_Fibonacci				;Counted Loop until ECX = 0

	;Display the farewell message to the user but also display user name as saying goodbye
	Goodbye_Msg:
		call	Crlf
		call	Crlf
		mov		EDX, OFFSET verify			;Display verify results
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET gdbye			;Display Goodbye
		call	WriteString
		mov		EDX, OFFSET user_name		;Display user's name
		call	WriteString
		mov		EDX, OFFSET	peri			;Print out the period "."
		call	WriteString
		call	Crlf

		exit								;Exit the procedure
main ENDP

END main