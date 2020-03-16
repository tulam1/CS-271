TITLE  Low-Level I/O Procedures		(macro.asm)

; Author: Tu Lam
; Last Modified: 3/15/2020
; OSU Email Address: lamtu@oregonstate.edu
; Course Number/Section: CS 271 Section #400
; Project Number: Program #6		Due Date: 3/15/2020
; Description: The program will asked the user to enter 10 signed integer numbers. Also, the 
;			   program will validate if the user enter a number higher than the registers or non-digit
;			   numbers. In the end, the program will then display the integers as they were enter and display
;			   the sum and the average. [Test will be done in positive & negative numbers]

INCLUDE Irvine32.inc


;This is all the constant values
	MAX_INT = 10

; /***********************************************************************************
;  * Description: This macro display any string that is pass through here.
;  * Receive(s):  Parameter {str_mem}
;  * Return(s):	  None
;  * Precondition(s): None preconditions are required
;  * Registers Changed: EDX
;  * Postcondition(s): None
;  **********************************************************************************/
displayString MACRO str_mem
	push	EDX
	mov		EDX, str_mem
	call	WriteString
	pop		EDX
ENDM


; /***********************************************************************************
;  * Description: This macro display the prompt and get the user input
;  * Receive(s):  Parameter {str, length}
;  * Return(s):	  None
;  * Precondition(s): None preconditions are required
;  * Registers Changed: EDX, ECX
;  * Postcondition(s): None
;  **********************************************************************************/
getString MACRO str, length
	push	EDX					
	push	ECX
	displayString str
	mov		EDX, length
	mov		ECX, 32
	call	ReadString
	pop		ECX
	pop		EDX
ENDM

;This is all the global variables declaration
.data
	;Global String
	title_p		BYTE	"Program #6: Designing low-level I/O procedures",0
	author		BYTE	"Written by: Tu Lam",0
	inst_1		BYTE	"Please provide 10 signed decimal integers.",0
	inst_2		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
	inst_3		BYTE	"After you have finished inputting the raw numbers, I will display a list",0
	inst_4		BYTE	"of the integers, their sum, and their average value.",0
	enter_p		BYTE	"Please enter an signed number: ",0
	error_msg	BYTE	"ERROR: You did not enter a signed number or your number was too big. Please try again!",0
	total_pmt	BYTE	"You entered the following numbers: ",0
	sum_msg		BYTE	"The sum of these numbers is: ",0
	avg_msg		BYTE	"The rounded average is: ",0
	neg_space	BYTE	"-",0
	comma_s		BYTE	", ",0
	goodbye		BYTE	"Thanks for playing!",0

	
	;Global Array & Nums
	arr			DWORD	MAX_INT		DUP(?)					;The array that hold 10 values
	str_arr		DWORD	32			DUP(?)					;String array when need to convert number to string
	input		BYTE	33			DUP(?)					;The string to be enter by the user
	tmp_str		BYTE	32			DUP(?)					;Temporary string for conversion
	tmp_str2	BYTE	32			DUP(?)					;Temporary string for conversion
	counter		DWORD	0									;A counter for counting the number of number has enter
	sum			DWORD	0									;Sum of the entire 10 numbers
	index_lo	DWORD	0									;The value at the current place
	tmp			DWORD	0									;A holder for thing to be exchange
	item_val	DWORD	0									;A counter to get the first item in the array
	sign_ck		DWORD	0									;A holder that check for the sign
	avg			DWORD	0									;The variable hold the average

;This is all the code for the running program and the other procedures
.code
main PROC
	;Push by reference of the strings onto the stack into the introduction
	push	OFFSET title_p
	push	OFFSET author
	push	OFFSET inst_1
	push	OFFSET inst_2
	push	OFFSET inst_3
	push	OFFSET inst_4
	call	introduction

	;Push by value & reference onto the readVal
	push	sign_ck
	push	OFFSET enter_p
	push	OFFSET input
	push	OFFSET arr
	push	OFFSET error_msg
	push	counter
	push	index_lo
	push	tmp
	call	readVal
	call	Crlf

	;Push by value & reference onto the writeVal
	push	OFFSET neg_space
	push	OFFSET comma_s
	push	item_val
	push	counter
	push	OFFSET total_pmt
	push	OFFSET arr
	push	OFFSET str_arr
	call	writeVal
	call	Crlf

	;Push by reference into the getSum_Avg
	push	OFFSET tmp_str2
	push	OFFSET avg
	push	OFFSET avg_msg
	push	OFFSET neg_space
	push	OFFSET tmp_str
	push	OFFSET arr
	push	OFFSET sum_msg
	push	OFFSET sum
	call	getSum_Avg

	;This is for dipslayign the farewell message
	call	Crlf
	push	OFFSET goodbye
	call	farewell

	exit
main ENDP


; /***********************************************************************************
;  * Description: This procedure will display the title of program and the instuction.
;  * Receive(s):  Reference {title_p, author, inst_1, inst_2, inst_3, inst_4}
;  * Return(s):	  None
;  * Precondition(s): None preconditions are required
;  * Registers Changed: None
;  * Postcondition(s): None
;  **********************************************************************************/
introduction PROC
	push	EBP											;Set up the stack frame
	mov		EBP, ESP
	pushad											;Push Register

	displayString [EBP + 28]							;Call macro to display title
	call	Crlf
	displayString [EBP + 24]							;Display author of the program
	call	Crlf
	call	Crlf
	displayString [EBP + 20]							;Display intruction set from 1-4
	call	Crlf
	displayString [EBP + 16]		
	call	Crlf
	displayString [EBP + 12]		
	call	Crlf
	displayString [EBP + 8]		
	call	Crlf
	call	Crlf

	popad
	pop		EBP											;Pop the stack frame (Restored)
	ret		24
introduction ENDP


; /*******************************************************************************************************
;  * Description: This procedure will get the user input and verify if it is a number
;  * Receive(s):  Reference {enter_p, input, arr, error_msg}	Value {sign_ck, counter, index_lo, tmp}
;  * Return(s):	  The number that is is verified
;  * Precondition(s): None preconditions are required
;  * Registers Changed: EAX, EBX, ECX, EDX, ESI, EDI
;  * Postcondition(s): None
;  ******************************************************************************************************/
readVal PROC
	push	EBP											;Set up the stack frame
	mov		EBP, ESP
	pushad

	Enter_Val:
		getString [EBP + 32], [EBP + 28]				;Passing parameter of the prompt and the input
		mov		ECX, EAX								;Get the number of elements
		mov		ESI, [EBP + 28]							;Move the input string into ESI
		mov		EAX, 0									;Set both EAX & EBX to 0
		mov		EBX, 0
		mov		[EBP + 8], EAX							;Reset the holder
		mov		EDI, MAX_INT							;Set EDI to 10
		jmp		Check_Sign_Indicator
		
	Check_Sign_Indicator:
		lodsb
		cmp		AL,	43									;Check for +
		je		Check_Positive
		cmp		AL, 45									;Check for -
		je		Check_Negative
		cmp		AL, 0									;Compare the it is reach null terminator
		je		Done									;If so, jump to done
		cmp		AL, 48									;Check if each bit is not less than 0
		jl		Not_Valid
		cmp		AL, 57									;Check if each bit is not greater than 9
		jg		Not_Valid
		sub		AL, 48									;Subtract to get the number from string
		movzx	EBX, AL									;Extend zero when copied AL into EBX
		mov		EAX, [EBP + 8]							;Put the placeholder into the EAX
		mul		EDI										;Multiply it by 10
		add		EAX, EBX								;Add the value in EBX into EAX (EAX hold the value of the number and EBX hold the next value in string)
		mov		[EBP + 8], EAX							;Copy the EAX value into the placeholder
		jmp		Check_Num

	Check_Positive:
		mov		EAX, [EBP + 36]							;Move sign_ck into EBX
		add		EAX, 1									;Add 1 to the EBX
		mov		[EBP + 36], EAX							;Move the value back to sign_ck
		mov		EAX, 0									;Set EAX to 0
		jmp		Check_Num

	Check_Negative:
		mov		EAX, [EBP + 36]							;Move sign_ck into EBX
		add		EAX, 2									;Add 2 to the EBX
		mov		[EBP + 36], EAX							;Move the value back to sign_ck
		mov		EAX, 0									;Set EAX to 0
		jmp		Check_Num
	
	Check_Num:
		lodsb
		cmp		AL, 0									;Compare the it is reach null terminator
		je		Done									;If so, jump to done
		cmp		AL, 48									;Check if each bit is not less than 0
		jl		Not_Valid
		cmp		AL, 57									;Check if each bit is not greater than 9
		jg		Not_Valid
		sub		AL, 48									;Subtract to get the number from string
		movzx	EBX, AL									;Extend zero when copied AL into EBX
		mov		EAX, [EBP + 8]							;Put the placeholder into the EAX
		mul		EDI										;Multiply it by 10
		add		EAX, EBX								;Add the value in EBX into EAX (EAX hold the value of the number and EBX hold the next value in string)
		mov		[EBP + 8], EAX							;Copy the EAX value into the placeholder
		loop	Check_Num								;Loop back to check it again for the rest of the string value
		cmp		EDX, 0									;Compare the EDX to 0
		jne		Not_Valid								;If it is not equal to 0, mean there is a overflow flag
		jmp		Done									;Jump to Done

	Negate_Num:
		mov		EAX, [EBP + 8]							;Move the tmp holder into the EAX
		not		EAX										;Negate the value in EAX
		inc		EAX										;Add 1 to get back to the original number
		mov		EBX, 0									;Reset the sign indicator to 0
		mov		[EBP + 36], EBX
		mov		[EDI + ECX], EAX						;Copy the value into the spot at that array index
		mov		ECX, 4									;Copied the value 4 into ECX
		add		[EBP + 12], ECX							;Add 4 into the index_location
		mov		EAX, 0									;Reset EAX to 0
		inc		EAX										;Add 1 to the EAX
		add		[EBP + 16], EAX							;Add the value of the EAX to the counter
		mov		EAX, [EBP + 16]							;Move it back to EAX
		cmp		EAX, MAX_INT							;Compare if the counter is at max at 10 yet
		jl		Enter_Val								;If not, jump back to the entering field
		jmp		Done2

	Not_Valid:
		displayString [EBP + 20]						;Display the error message if it is not a number
		call	Crlf
		jmp		Enter_Val

	Done:
		mov		ECX, [EBP + 12]							;Move the index_location into ECX
		mov		EDI, [EBP + 24]							;Move the array into EDI
		mov		EBX, [EBP + 36]							;Move sign_ck to EBX
		cmp		EBX, 2									;Compare the value with 2
		je		Negate_Num								;If the value is equal 2, jump to Negate_Num as the value is negative
		mov		EBX, 0									;Reset the sign indicator to 0
		mov		[EBP + 36], EBX
		mov		EAX, [EBP + 8]							;Move the tmp holder value into the EAX
		mov		[EDI + ECX], EAX						;Copy the value into the spot at that array index
		mov		ECX, 4									;Copied the value 4 into ECX
		add		[EBP + 12], ECX							;Add 4 into the index_location
		mov		EAX, 0									;Reset EAX to 0
		inc		EAX										;Add 1 to the EAX
		add		[EBP + 16], EAX							;Add the value of the EAX to the counter
		mov		EAX, [EBP + 16]							;Move it back to EAX
		cmp		EAX, MAX_INT							;Compare if the counter is at max at 10 yet
		jl		Enter_Val								;If not, jump back to the entering field

	Done2:
		popad
		pop		EBP										;Pop the stack frame (Restored)
		ret		32
readVal ENDP


; /**************************************************************************************************************
;  * Description: This procedure will convert number into string
;  * Receive(s):  Reference {arr, str_arr, comma_s, total_pmt, tmp_str, neg_space}     Value {counter, item_val}
;  * Return(s):	  The string array after convert
;  * Precondition(s): None preconditions are required
;  * Registers Changed: EAX, EBX, ECX, EDX, EDI
;  * Postcondition(s): None
;  *************************************************************************************************************/
writeVal PROC
	push	EBP											;Set up the stack frame
	mov		EBP, ESP
	pushad

	mov		EDI, [EBP + 12]								;Move the arr into EDI
	mov		EBX, 0										;Set EBX to 0
	mov		[EBP + 24], EBX								;Move value into item_val
	displayString [EBP + 16]							;Display the total_p
	call	Crlf

	Print_Num:
		mov		EAX, [EDI + EBX]						;Move the index value into EAX
		push	EAX										;Push EAX and the str_arr for convert
		push	[EBP + 8]
		call	convert									;Call the convert procedure
		cmp		EAX, 0									;Compare the value if it less than 0
		jl		Print_Neg								;If less, jump to Print_Neg
		mov		EDX, 0									;Reset EDX to 0
		add		EDX, 1									;Add 1 to the EDX
		add		[EBP + 20], EDX							;Increment the counter
		mov		EAX, [EBP + 20]							;Move the counter value into EAX
		displayString [EBP + 8]							;Display the string after being converted
		cmp		EAX, MAX_INT							;Compare the counter to MAX_INT
		je		Done_Printing							;If all 10 numbers printed, jmp to Done_Print
		displayString [EBP + 28]						;If not, print the comma
		jmp		Done_Printing

	Print_Neg:
		mov		EDX, 0									;Reset EDX to 0
		add		EDX, 1									;Add 1 to the EDX
		add		[EBP + 20], EDX							;Increment the counter
		mov		EAX, [EBP + 20]							;Move the counter value into EAX
		displayString [EBP + 32]						;Print the negative sign
		displayString [EBP + 8]							;Display the string after being converted
		cmp		EAX, MAX_INT							;Compare the counter to MAX_INT
		je		Done_Printing							;If all 10 numbers printed, jmp to Done_Print
		displayString [EBP + 28]						;If not, print the comma
		jmp		Done_Printing

	Done_Printing:
		mov		EBX, 4									;Put 4 into EBX
		add		[EBP + 24], EBX							;Add 4 to move to the next value
		mov		EBX, [EBP + 24]							;Move the item value index to EBX
		cmp		EAX, MAX_INT							;Compare if it reaches 10 numbers yet
		jl		Print_Num								;If not, print again
	
	popad
	pop		EBP											;Pop the stack frame (Restored)
	ret		28
writeVal ENDP


; /***********************************************************************************
;  * Description: This procedure will calculate the sum and print out the number
;  * Receive(s):  Reference {arr, sum_msg, sum, neg_space, tmp_str}
;  * Return(s):	  The value of the sum
;  * Precondition(s): Have the array fill with numbers
;  * Registers Changed: EAX, EBX, ECX, EDI
;  * Postcondition(s): None
;  **********************************************************************************/
getSum_Avg PROC
	push	EBP											;Set up the stack frame
	mov		EBP, ESP
	pushad

	mov		EDI, [EBP + 16]								;Move array into the EDI
	mov		ECX, MAX_INT								;Set loop to 10
	mov		EAX, 0										;Set EBX & EAX to 0
	mov		EBX, 0

	Sum_Loop:
		mov		EBX, [EDI]								;Move the value into the EBX
		add		EAX, EBX								;Add the EBX value into EBX
		add		EDI, 4									;Move to the next element
		loop	Sum_Loop								;Loop back until all numbers been added

	mov		[EBP + 8], EAX								;Copy the sum into the sum variable
	push	EAX											;Push EAX and tmp_str to EAX
	push	[EBP + 20]
	call	convert
	cmp		EAX, 0										;Compare if the sum is less than 0
	jl		Neg_Value
	displayString [EBP + 12]							;Display the sum message and value
	displayString [EBP + 20]
	call	Crlf
	jmp		get_Average
	
	Neg_Value:
		displayString [EBP + 12]						;Display the sum message and value
		displayString [EBP + 24]
		displayString [EBP + 20]
		call	Crlf
		jmp		get_Average
		
	Get_Average:
		mov		EAX, [EBP + 8]							;Move the sum variable into the EAX
		cmp		EAX, 0									;Compare if the value is less than 0
		jl		Neg_Value2
		mov		EBX, MAX_INT							;Move 10 into EBX
		mov		EDX, 0									;Move 0 into EDX to clear the division
		div	    EBX										;Take the EAX divide by EBX
		mov		[EBP + 32], EAX							;Move the value into the average
		push	EAX										;Push EAX and tmp_str2 onto convert
		push	[EBP + 36]
		call	convert
		displayString [EBP + 28]						;Display the string on average & avg
		displayString [EBP + 36]
		call	Crlf
		jmp		Done

	Neg_Value2:
		mov		EAX, [EBP + 8]							;Move sum into EAX to make sure
		not		EAX										;Negate the number to make it positive and restore to the original num
		add		EAX, 1
		mov		EBX, MAX_INT							;Move 10 into EBX
		mov		EDX, 0									;Move 0 into EDX to clear the division
		div	    EBX
		mov		[EBP + 32], EAX							;Move the value into the average
		push	EAX										;Push EAX and tmp_str2 onto convert
		push	[EBP + 36]
		call	convert
		displayString [EBP + 28]						;Display the average message and value
		displayString [EBP + 24]
		displayString [EBP + 36]
		call	Crlf
		jmp		Done

	Done:
		popad
		pop		EBP										;Pop the stack frame (Restored)
		ret		32
getSum_Avg ENDP

; /***********************************************************************************
;  * Description: This procedure will print out the goodbye message
;  * Receive(s):  Reference {goodbye}
;  * Return(s):	  None
;  * Precondition(s): None preconditions are required
;  * Registers Changed: None
;  * Postcondition(s): None
;  **********************************************************************************/
farewell PROC
	push	EBP											;Set up the stack frame
	mov		EBP, ESP
	pushad

	displayString [EBP + 8]								;Display the string [goodbye]
	call Crlf

	popad
	pop		EBP											;Pop the stack frame (Restored)
	ret		4
farewell ENDP


; /*******************************************************************************************
;  * Description: This procedure will convert the array value into string
;  * Receive(s):  Value {EAX, str_arr}
;  * Return(s):	  The string array after convert from number
;  * Precondition(s): None preconditions are required
;  * Registers Changed: EAX, EDI, ECX, EBX, AL
;  * Postcondition(s): None
;  ******************************************************************************************/
convert PROC
	push	EBP											;Set up the stack frame
	mov		EBP, ESP
	pushad												;Push EAX, EBX, and others

	Set_Up:
		mov		EDI, [EBP + 8]							;Move String_arr into EDI
		mov		EAX, [EBP + 12]							;The value at arr index move into EAX
		mov		ECX, 0									;Making sure ECX is 0
		mov		EBX, MAX_INT							;Set EBX to 10

	Check_Sign:
		cmp		EAX, 0
		jl		Convert_Back							;If the number is less than 0, jump convert
		jmp		Converting								;If number is positive jump to converting

	Converting:
		mov		EDX, 0									;Set EDX to 0
		cdq												;Extend the EAX:EDX
		idiv	EBX										;Divide the EAX value by 10
		push	EDX										;Save the remainder
		inc		ECX										;Add 1 to the ECX
		cmp		EAX, 0									;Compare if the conversion is done
		jne		Converting								;If it is not done, keep jmp back
		jmp		Done

	Convert_Back:
		not		EAX										;Negate the number back to positive
		add		EAX, 1									;Add 1 to restore to the original position
		mov		EDX, 0									;Set EDX to 0
		cdq												;Extend the EAX:EDX
		idiv	EBX										;Divide the EAX value by 10
		push	EDX										;Save the remainder
		inc		ECX										;Add 1 to the ECX
		cmp		EAX, 0									;Compare if the conversion is done
		jne		Converting								;If it is not done, keep jmp back
		jmp		Done

	Done:
		pop		[EDI]									;Pop the value off stack
		mov		AL, [EDI]								;Move the element into AL
		add		AL, 48									;Add 48 to convert back to string
		stosb											;Store string from AL to an address
		loop	Done

	popad												;Pop the EAX, EBX, and others
	pop		EBP											;Pop the stack frame (Restored)
	ret		8
convert ENDP

END main