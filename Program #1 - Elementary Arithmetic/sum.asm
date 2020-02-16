TITLE Summations & Differences		(sum.asm)

; Author: Tu Lam
; Last Modified: 1/14/2020
; OSU Email Address: lamtu@oregonstate.edu
; Course Number/Section: CS 271 Section #400
; Project Number: Program #1		Due Date: 1/19/2020
; Description: The basic of the first program is to get familiar with using
;              MASM and letting the user enter three numbers (In descending order)
;              and calculate the sums and differences of the result.

INCLUDE Irvine32.inc

; All the variables decalaration that will be used in the program.
.data
title_card	BYTE	"Summations & Differences     by Tu Lam",0
borderline  BYTE    "-----------------------",0
ec1         BYTE    "**EC #1: Program allows user to go again if they wanted to.",0
greeting	BYTE	"Welcome to the program where the magic of calculation will happen!",0
ask         BYTE    "Enter 3 numbers which A > B > C (In descending order) and I'll calculate the sums & differences.",0
prompt_1    BYTE    "Enter the 1st number (A): ",0
prompt_2    BYTE    "Enter the 2nd number (B): ",0
prompt_3    BYTE    "Enter the 3rd number (C): ",0
num_A       DWORD   ?   ;1st number to be enter
num_B       DWORD   ?   ;2nd number to be enter
num_C       DWORD   ?   ;3rd number to be enter
result_info BYTE    "Here is the result of the sums & differences based on what you have entered:",0
_AB1        BYTE    "A + B: ",0
_AB2        BYTE    "A - B: ",0
_AC1        BYTE    "A + C: ",0
_AC2        BYTE    "A - C: ",0
_BC1        BYTE    "B + C: ",0
_BC2        BYTE    "B - C: ",0
_ABC        BYTE    "A + B + C: ",0
adding      BYTE    " + ",0
substract   BYTE    " - ",0
equal_to    BYTE    " = ",0
sumAB       DWORD   ?   ;Total value of sumAB
sumAC       DWORD   ?   ;Total value of sumAC
sumBC       DWORD   ?   ;Total value of sumBC
sumABC      DWORD   ?   ;Total value of sumABC
difAB       DWORD   ?   ;Total value of difAB
difAC       DWORD   ?   ;Total value of difAC
difBC       DWORD   ?   ;Total value of difBC
thanks      BYTE    "Are you impressed?  If so, Thank You!",0
retry       BYTE    "Do you want to go again? [Press 1] - Yes  OR  [Press 0] - No: ",0
op_enter    DWORD   ?   ;The option that the user enter if they want to go again
bye         BYTE    "Thank you for using the program. Goobye!",0

; This is the instruction of the program where it will run
.code
main PROC

; This section is for the intro of the program and greeting the user
  Introduction:
    mov   EDX, OFFSET title_card      ;Display the title for the user
    call  WriteString
    call  Crlf
    mov   EDX, OFFSET borderline      ;Add border
    call  WriteString
    call  Crlf
    mov   EDX, OFFSET ec1             ;Display the extra credit option
    call  WriteString
    call  Crlf
    call  Crlf
    mov   EDX, OFFSET greeting        ;Display a welcoming message
    call  WriteString
    call  Crlf
    call  Crlf

; This section ask the user to enter three numbers (In descending order)
  Ask_First_Number:
    mov   EDX, OFFSET ask             ;Display the program explaination
    call  WriteString
    call  Crlf
    mov   EDX, OFFSET prompt_1        ;Ask to enter 1st number
    call  WriteString
    call  ReadInt
    mov   num_A, EAX                  ;Save the 1st value

  Ask_Second_Number:
    mov   EDX, OFFSET prompt_2        ;Ask to enter 2nd number
    call  WriteString
    call  ReadInt
    mov   num_B, EAX                  ;Save the 2nd value

  Ask_Third_Number:
    mov   EDX, OFFSET prompt_3        ;Ask to enter 3rd number
    call  WriteString
    call  ReadInt
    mov   num_C, EAX                  ;Save the 3rd value
    call  Crlf

; Diplaying the result of the sums & differences
  Calculating_A_plus_B:
    mov   EDX, OFFSET result_info     ;Display a message about the result
    call  WriteString
    call  Crlf
    mov   EDX, OFFSET _AB1            ;Display "A + B: "
    call  WriteString
    mov   EAX, num_A
    call  WriteDec
    mov   EDX, OFFSET adding          ;Display " + "
    call  WriteString
    mov   EAX, num_B
    call  WriteDec
    mov   EDX, OFFSET equal_to        ;Display " = "
    call  WriteString
    mov   EAX, num_A
    add   EAX, num_B                  ;Adding A + B together
    mov   sumAB, EAX
    call  WriteDec                    ;Displaying the result of A + B
    call  Crlf

  Calculating_A_minus_B:
    mov   EDX, OFFSET _AB2            ;Display "A - B: " 
    call  WriteString
    mov   EAX, num_A
    call  WriteDec
    mov   EDX, OFFSET substract       ;Display " - " 
    call  WriteString
    mov   EAX, num_B
    call  WriteDec
    mov   EDX, OFFSET equal_to        ;Display " = "
    call  WriteString
    mov   EAX, num_A
    sub   EAX, num_B                  ;Substract A - B
    mov   difAB, EAX
    call  WriteDec                    ;Displaying the result of A - B
    call  Crlf

  Calculating_A_plus_C:
    mov   EDX, OFFSET _AC1            ;Display "A + C: " 
    call  WriteString
    mov   EAX, num_A
    call  WriteDec
    mov   EDX, OFFSET adding          ;Display " + "
    call  WriteString
    mov   EAX, num_C
    call  WriteDec
    mov   EDX, OFFSET equal_to        ;Display " = "
    call  WriteString
    mov   EAX, num_A
    add   EAX, num_C                  ;Adding A + C together
    mov   sumAC, EAX
    call  WriteDec                    ;Displaying the result of A + C
    call  Crlf

  Calculating_A_minus_C:
    mov   EDX, OFFSET _AC2            ;Display "A - C: " 
    call  WriteString
    mov   EAX, num_A
    call  WriteDec
    mov   EDX, OFFSET substract       ;Display " - " 
    call  WriteString
    mov   EAX, num_C
    call  WriteDec
    mov   EDX, OFFSET equal_to        ;Display " = "
    call  WriteString
    mov   EAX, num_A
    sub   EAX, num_C                  ;Substract A - C
    mov   difAC, EAX
    call  WriteDec                    ;Displaying the result of A - C
    call  Crlf

  Calculating_B_plus_C:
    mov   EDX, OFFSET _BC1            ;Display "B + C: " 
    call  WriteString
    mov   EAX, num_B
    call  WriteDec
    mov   EDX, OFFSET adding          ;Display " + "
    call  WriteString
    mov   EAX, num_C
    call  WriteDec
    mov   EDX, OFFSET equal_to        ;Display " = "
    call  WriteString
    mov   EAX, num_B
    add   EAX, num_C                  ;Adding B + C together
    mov   sumBC, EAX
    call  WriteDec                    ;Displaying the result of B + C
    call  Crlf

  Calculating_B_minus_C:
    mov   EDX, OFFSET _BC2            ;Display "B - C: " 
    call  WriteString
    mov   EAX, num_B
    call  WriteDec
    mov   EDX, OFFSET substract       ;Display " - " 
    call  WriteString
    mov   EAX, num_C
    call  WriteDec
    mov   EDX, OFFSET equal_to        ;Display " = "
    call  WriteString
    mov   EAX, num_B
    sub   EAX, num_C                  ;Substract B - C
    mov   difBC, EAX
    call  WriteDec                    ;Displaying the result of B - C
    call  Crlf

  Calculating_A_add_B_add_C:
    mov   EDX, OFFSET _ABC            ;Display "A + B + C: " 
    call  WriteString
    mov   EAX, num_A
    call  WriteDec
    mov   EDX, OFFSET adding          ;Display " + " 
    call  WriteString
    mov   EAX, num_B
    call  WriteDec
    mov   EDX, OFFSET adding          ;Display " + " 
    call  WriteString
    mov   EAX, num_C
    call  WriteDec
    mov   EDX, OFFSET equal_to        ;Display " = "
    call  WriteString
    mov   EAX, num_A
    add   EAX, num_B                  ;Add A + B together
    add   EAX, num_C                  ;Add (A + B) + C together
    mov   sumABC, EAX
    call  WriteDec                    ;Displaying the result of A + B + C
    call  Crlf
    call  Crlf

; This section dipslay the message on if the user is happy with the result
  Thanks_Message:
    mov   EDX, OFFSET thanks          ;Display "Are you impressed?  If so, Thank You!" 
    call  WriteString
    call  Crlf
    call  Crlf

; This section ask user if they want to go again
  Retry_Option:
    mov   EDX, OFFSET retry           ;Display "Do you want to go again? [Press 1] - Yes  OR  [Press 0] - No: " 
    call  WriteString
    call  ReadInt
    mov   op_enter, EAX
    cmp   op_enter, 0                 ;Comparing the value that the user enter
    jne   Ask_First_Number            ;If it is not equal to 0, then jump back to asking the user the first number
    jmp   Goobye                      ;Skip over the false block

; If the user choose the number 0, then the program exit
  Goobye:
    call  Crlf
    mov   EDX, OFFSET bye             ;Display "Thank you for using the program. Goobye!" 
    call  WriteString
    call  Crlf
     
	exit                              ;Exiting the procedure
main ENDP

END main