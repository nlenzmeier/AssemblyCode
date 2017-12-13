INCLUDE NUTS.dat

.MODEL SMALL
.STACK 1000H
 
STACK_SEG SEGMENT 'STACK'
   
    DB 100 DUP (?)

STACK_SEG ENDS

DATA_SEG SEGMENT 'DATA'
    
    NUTS
    SWAPFLAG DB ?
    PTR1     DW ?
    PTR2     DW ?
    PTR0     DW ?
    
DATA_SEG ENDS

.CODE
.STARTUP
CODE_SEG SEGMENT PARA 'CODE' PUBLIC USE16
ASSUME CS:CODE_SEG, DS:DATA_SEG, SS:STACK_SEG
MAIN PROC FAR     
     PUSH DS               ; initialize DS
     XOR AX, AX            ; clears out AX
     PUSH AX               ; Pushes Ax (0) to the stack
     MOV AX, DATA_SEG       
     MOV DS, AX            ; Data Segment memory address in DS
     MOV DI, LIST_ORG
     
     Call Display_Info     ; Output Data_Seg
     
     mov ah, 0Eh           ;print new line sequence
     mov al, 0Dh
     int 10h
     mov al, 0Ah
     int 10h
     
     Call BubbleSort
     
     MOV AX, DATA_SEG       
     MOV DS, AX            ; Data Segment memory address in DS
     MOV DI, LIST_ORG
     Call Display_Info    
     
     MOV AX, 4C00h            ;returns control to DOS
     INT 21h

Ret

MAIN ENDP

;*****************************************************
;---------------------- Display_Info ------------------
;*****************************************************

 DISPLAY_INFO PROC NEAR
 
    AGAIN2:
    MOV SI,DI                ; put beginning entry offset in SI
    ADD DI, 2                ; move DI offset to beginning of string
    Call PRINTSTR            ; output string of item
    
    MOV DL, 10               ; output a character return
    MOV AH, 02h              ; designates output char
    INT 21h                  ; send to DOS
    
    MOV DI, SI               ; put beginning of entry offset back in DI
    CMP [DI],0               ; if zero, then no more items in list
    JE RETT
    MOV DI, [DI]             ; get DI offset to next entry
    JMP AGAIN2
    RETT:
    RET  
    
 DISPLAY_INFO ENDP

;*****************************************************
;---------------------- PRINTSTR ------------------
;*****************************************************
  PRINTSTR PROC                       ; expecting SI to have string offset
     
     AGAIN3:
     CMP byte ptr [DI],20h            ; check if char is a space
     JE FINISH
     CONT:
     MOV DL,[DI]
     MOV AH, 02H                     ; 02H to display value in DL
     INT 21H                         ; send to DOS
     ADD DI, 1                       ; increment to the next character
     JMP AGAIN3
     FINISH:              
     CMP byte ptr [DI+1],20H         ; see if next char is a space
     JNE CONT                        ; not a space, go back and continue
     RET

  PRINTSTR ENDP

;*****************************************************
;---------------------- BUBBLE_SORT ------------------
;*****************************************************

BUBBLESORT PROC 
    MOV [SWAPFLAG],1      ; initialize swapflag so that will loop at least once
    MOV SI, [List_Org]    ; initialize start of sorted list to List_Org
OUTTER:
    CMP [SWAPFLAG], 0     ; check if a swap occured during last pass, if not done
    JE DONE
    MOV [SWAPFLAG], 0     ; Set SwapFlag to zero to reset 
    MOV PTR0,0 
    MOV SI, [List_Org]
    MOV DX, 8    
INNER:
    MOV DI,[SI]            ; Setup DI for string 2 for loop iteration
    SUB DX, 1   
    CMP DX,0               ; See if there is another value to compare
    JE OUTTER 
    MOV [PTR1],SI
    MOV [PTR2],DI
    ADD DI, 2             ; DI+2 is where string2 for compare starts
    ADD SI, 2             ; SI+2 is where string1 for compare starts 
    CALL Compare
    ; keep prior ptr
    MOV SI, DI            ; Setup SI for string 1 for next loop iteration
    JMP INNER
DONE:
    RET 

BUBBLESORT ENDP

;*****************************************************
;------------------------ COMPARE -------------------
;*****************************************************
COMPARE PROC NEAR 
    INT 3
    PUSH DS  
    POP ES   
    CLD                    ; sets direction of compare right to left
    MOV CX,100             ; designates how many bytes to compare
    REPE CMPSB             ; increments both SI & DI as comparing as long as equal
    JLE EXIT
    CALL SWAP
    MOV DI, [PTR2]
    MOV [PTR0], DI
    MOV DI, [PTR1]
    RET
 EXIT:
    MOV DI, [PTR1]
    MOV [PTR0], DI
    MOV DI, [PTR2]
    RET  
  
COMPARE ENDP

;*****************************************************
;------------------------ SWAP ----------------------
;*****************************************************
SWAP PROC NEAR 
    MOV [SWAPFLAG], 1         ;designate that a swap occured
    MOV DI,[PTR2]
    MOV SI,[PTR0]
    MOV [SI],DI
    MOV CX, [DI]
    MOV SI,[PTR1]
    MOV [DI],SI
    MOV [SI],CX
RET  
  
SWAP ENDP
;********************************************************

CODE_SEG ENDS  
.EXIT
END MAIN