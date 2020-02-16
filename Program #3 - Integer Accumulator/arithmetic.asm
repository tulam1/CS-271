TITLE  Integer Accumulator		(arithmetic.asm)

; Author: Tu Lam
; Last Modified: 2/8/2020
; OSU Email Address: lamtu@oregonstate.edu
; Course Number/Section: CS 271 Section #400
; Project Number: Program #3		Due Date: 2/9/2020
; Description: The program ask the user for their name and enter a number that is
;              in range from [-88,-55] or [-40,-1]. Then the check the number for
;              valiadation and find the max, min, sum, and average of the numbers.

INCLUDE Irvine32.inc

;This is the constant for comparision later on
	FIRST_LOWER = -88
	FIRST_UPPER = -55
	SECOND_LOWER = -40
	SECOND_UPPER = -1
	COUNTER_CONST = 1
	NOTHING_ENTER = 0

;This include all the declaration of variable
.data
	program_title	BYTE	"Integer Accumulator",0
	border			BYTE	"-------------------",0
	ec1				BYTE	"EC: Increment & display the line number for only the valid number.",0
	welcome			BYTE	"Welcome to the Integer Accumulator by Tu Lam",0
	ask_name		BYTE	"What Is Your Name? ",0
	greet_user		BYTE	"Hello there, ",0
	user_name		BYTE	40 DUP(0)		;Save user's name in here
	instruct1		BYTE	"Please enter numbers in [-88, -55] or [-40, -1].",0
	instruct2		BYTE	"Enter a non-negative number when you are finished to see results."
	counter			DWORD	0				;This will count how many numbers the user enter for the calculation of average
	num_enter		BYTE	". Enter Number: ",0
	numb			DWORD	?				;This use as a temporary to hold the number the user enter
	error_mess		BYTE	"Number Invalid!",0
	sum				DWORD	?				;This is the total sum of all the number that is enter
	total_num1		BYTE	"You entered ",0
	total_num2		BYTE	" valid number(s).",0
	summation		BYTE	"The sum of your valid numbers is: ",0
	min_val			DWORD	?				;This is where it hold the minimum value
	max_val			DWORD	?				;Hold the maximum value
	min_sen			BYTE	"Your minimum valid number is: ",0
	max_sen			BYTE	"Your maximum valid number is: ",0
	round_avg		DWORD	?				;This store the average value
	avg_sen			BYTE	"The rounded average is: ",0
	no_num			BYTE	"Since there is no number entered, there is no min, max, sum = 0, and average is 0.",0
	goodbye_msg		BYTE	"We have to stop meeting like this. Farewell, ",0
	line_num		DWORD	0				;This display number line

	

;This section display all the codes for the program procedures
.code
main PROC

	;Dipslaying the program title and who created it
	Program_Introduction:
		mov		EDX, OFFSET program_title
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET border
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET ec1
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET welcome
		call	WriteString
		call	Crlf
		call	Crlf

	;This ask the user to enter their name
	Ask_For_Name:
		mov		EDX, OFFSET ask_name		;Ask the user for their name
		call	WriteString
		mov		EDX, OFFSET user_name
		mov		ECX, SIZEOF user_name
		call	Readstring					;Let the user enter their name
		mov		EDX, OFFSET greet_user		;Display "Hello there, "
		call	WriteString
		mov		EDX, OFFSET	user_name		;Display user's name
		call	WriteString	
		call	Crlf
		call	Crlf

	;This display the instruction of the program to the user
	Instruction_Display:
		mov		EDX, OFFSET instruct1		;Display the first set of instruction
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET	instruct2		;Display the second set of instruction
		call	WriteString
		call	Crlf

	;This is a loop that will keep repeating to the user to enter a number until hit the non-negative numbers
	Loop_Ask_Number:
		mov		EAX, counter				;Move counter to register
		add		EAX, 1						;Add 1 to match with the valid number
		mov		line_num, EAX				;Copy the line number to a holder
		call	WriteDec					;Call line number
		mov		EDX, OFFSET num_enter		;Display the " Enter Number: "
		call	WriteString
		call	ReadInt						;This is where the number is being enter
		mov		numb, EAX					;Copied to numb variable
		jmp		Verify_1					;Jump to the first verification

	;This is to verify the first set [-88, -55]
	Verify_1:
		cmp		numb, FIRST_LOWER			;Compare -88
		jl		Verify_2					;If it is less than -88, move to the second verification
		cmp		numb, FIRST_UPPER			;Compare -55
		jg		Verify_2					;If it is greater than -55, move to check the second condition
		inc		counter						;Increment the counter
		jmp     Calculation					;Since the comparision is correct, jump to calculation

	;This is to verify the second set [-40, -1]
	Verify_2:
		cmp		numb, SECOND_LOWER			;Compare -40
		jl		Error_Bound					;Not in bound, print out message
		cmp		numb, SECOND_UPPER			;Compare -1
		jg		Done_Condition				;Jump to the done part if the user enter a non-negative number
		inc		counter						;Increment the counter
		jmp		Calculation					;Since the comparision is correct, jump to calculation

	;Print out error if not in bound
	Error_Bound:
		mov		EDX, OFFSET error_mess		;Print out error message
		call	WriteString
		call	Crlf
		loop	Loop_Ask_Number				;Loop back to the ask number section

	;Calculate the sum of the number that is enter
	Calculation:
		cmp		counter, COUNTER_CONST	    ;Compare the number of counter
		jg		Calculation_2				;If there is more than 1 number, jump to this calculation section
		mov		EAX, 0
		add		EAX, numb					;Adding the user number they enter into the sum variable
		mov		sum, EAX
		jmp		Min_Max				        ;Go to finding min and max
		 
	;This is for if the number of counter is greater than 1
	Calculation_2:
		mov		EAX, sum					;Copied sum into register
		add		EAX, numb					;Add the new number together with the new sum
		mov		sum, EAX					;Pass it back to sum
		jmp		Min_Max				        ;go to finding min and max

	;This min and max look at if there is only 1 number enter
	Min_Max:
		cmp		counter, COUNTER_CONST		;Compare the counter
		jg		Update_Min					;If the counter is greater than 1, move to update min
		mov		EAX, numb					;If not, copy it to both of the min and max
		mov		min_val, EAX
		mov		max_val, EAX
		jmp		Loop_Ask_Number				;Loop back to ask number

	;This will update the minimum value
	Update_Min:
		mov		EAX, numb					;Copy the entered number
		cmp		EAX, min_val				;Make a compare to min_val
		jg		Update_Max					;If the value is greater than the min, move to update max
		mov		min_val, EAX				;If not, then just copy the number into min
		jmp		Loop_Ask_Number				;Jump to back to loop

	;This will update the max value
	Update_Max:
		mov		EAX, numb					;Move the numb into the register
		cmp		EAX, max_val				;Compare the max value to see if it needs to be replace or not
		jl		Loop_Back					;If the value is smaller than the current max val, then do nothing and loop back
		mov		max_val, EAX				;Copy it into max value
		jmp		Loop_Ask_Number				;Jump back to ask number

	;This is for loop back to the ask number
	Loop_Back:
		jmp		Loop_Ask_Number

	;This post-condition where the user finish entering the number
	Done_Condition:
		cmp		counter, NOTHING_ENTER		;Compare counter if it is equal to zero or not
		je		Nothing_At_All				;Jump to nothing case
		call	Crlf
		mov		EDX, OFFSET total_num1		;Print "You entered "
		call	WriteString
		mov		EAX, counter				;Move the number of time the user has enter into the register
		call	WriteDec					;Print out number
		mov		EDX, OFFSET	total_num2		;Print the rest of the message
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET max_sen		    ;Print the maximum number sentence
		call	WriteString
		mov		EAX, max_val
		call	WriteInt					;Print the maximum number
		call	Crlf
		mov		EDX, OFFSET min_sen			;Print the minimum number sentence
		call	WriteString
		mov		EAX, min_val
		call	WriteInt					;Print the min number
		call	Crlf
		mov		EDX, OFFSET summation		;Print the summation sentence
		call	WriteString
		mov		EAX, sum
		call	WriteInt					;Print the sum number
		call	Crlf
		mov		EAX, sum
		cdq									;Extend EAX to EDX for the number to not overflow
		mov		EBX, counter				;Move to EBX register for division
		idiv	EBX							;Divide the sum
		mov		round_avg, EAX				;Copied to the round_avg
		mov		EDX, OFFSET avg_sen		    ;Print the average sentence
		call	WriteString
		mov		EAX, round_avg
		call	WriteInt					;Print the average number
		call	Crlf
		mov		EDX, OFFSET	goodbye_msg		;Print the goodbye message
		call	WriteString
		mov		EDX, OFFSET user_name		;Print user's name
		call	WriteString
		call	Crlf
		jmp		Exit_Protocol				;jump to exit
		
	 ;Special case if nothing is entered
	 Nothing_At_All:
		call	Crlf
		mov		EDX, OFFSET total_num1		;Print "You entered "
		call	WriteString
		mov		EAX, counter				;Move the number of time the user has enter into the register
		call	WriteDec					;Print out number
		mov		EDX, OFFSET	total_num2		;Print the rest of the message
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET	no_num			;Print the special case statement
		call	WriteString
		call	Crlf
		mov		EDX, OFFSET	goodbye_msg		;Print the goodbye message
		call	WriteString
		mov		EDX, OFFSET user_name		;Print user's name
		call	WriteString
		call	Crlf
		jmp		Exit_Protocol				;jump to exit
		

	 ;Exit section
	 Exit_Protocol:
		exit								;Exit the procedure
main ENDP

END main