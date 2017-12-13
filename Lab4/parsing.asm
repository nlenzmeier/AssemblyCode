STACK_SEG SEGMENT STACK USE16
DB 100 DUP(?)
STACK_SEG ENDS

DATA_SEG SEGMENT 'DATA' USE16    ;CREATE THE TABLE

        Num1 DB 10 DUP ('$')
        Num2 DB 10 DUP ('$')
	RESULT DB 2 DUP ('$')
        Operator DB ?
        Buffer DB 100 					; max number(100) of chars expected
	Num3 DB ?
        Act_Buf DB 100 DUP ('$') 			; actual buffer w/ size=?max number?

        Buffer2 DB 100 					; max number(100) of chars expected
	Num4 DB ?
        Act_Buf2 DB 100 DUP ('$') 			; actual buffer w/ size=?max number?
        
        msgAGAIN  db 0DH, 0AH,'Again? (1)To quit: $'
        msgNEWLINE db 0DH,0AH,'$'
        msgINPUT  db 0DH, 0AH,'Enter an algebraic command line: $'
        msgResult db 0DH, 0AH,'Result: $'
        msgError0 db 0DH, 0AH,'Error!!'
        msgNUM1   db 0DH, 0AH,'first number: $'
	msgNUM2   db 0DH, 0AH,'second number: $'
	msgOPERATOR db 0DH, 0AH,'the operator: $'

DATA_SEG ENDS

CODE_SEG SEGMENT PARA 'CODE' PUBLIC USE16
ASSUME CS:CODE_SEG, DS:DATA_SEG, SS:STACK_SEG

MAIN PROC FAR


	MOV AX,DATA_SEG                         ;initialize data
	MOV DS,AX
	MOV ES,AX

	CALL INPUT				;parsing string

	PUSH offset Num1                            ;input of ascii2hex
	CALL ASCII2HEX                              ;returns value of number string to dx
	PUSH DX                                     ;pushes value for operation
	PUSH offset Num2                            ;input of ascii2hex
	CALL ASCII2HEX                              ;returns value of number string to dx
	PUSH DX                                     ;pushes value for operation

	SUMLOOP:
		CMP OPERATOR, '+'
		JNE SUBLOOP
	;	CALL SUM
		JMP ENDOFLOOP
	SUBLOOP:
		CMP OPERATOR, '-'
		JNE DIVLOOP
	;	CALL SUB
		JMP ENDOFLOOP
	DIVLOOP:
		CMP OPERATOR, '/'
		JNE MULLOOP
	;	CALL DIVIDE
		JMP ENDOFLOOP
	MULLOOP:
		CMP OPERATOR, '*'
		JNE ERRORLOOP
	;	CALL MULTIPLY
		JMP ENDOFLOOP
	ERRORLOOP:
		CALL ERROR
		JMP ENDOFLOOP
	ENDOFLOOP:
	
	

	LEA DX, msgNEWLINE
 	MOV AH, 09h
	INT 21H

	LEA DX, msgNUM1
	MOV AH, 09H
 	INT 21H
   
	LEA DX, Num1				; print number 1
	MOV AH, 09H
	INT 21H

	LEA DX, msgNEWLINE
	MOV AH, 09h
	INT 21H

	LEA DX, msgNUM2				; print number 2
	MOV AH, 09H
	INT 21H

	LEA DX, Num2
	MOV AH, 09h
	INT 21H
   
	LEA DX, msgNEWLINE
	MOV AH, 09h
	INT 21H

	LEA DX, msgOPERATOR			; print operator
	MOV AH, 09h
	INT 21H

	MOV DL, operator
	MOV AH, 02H
	INT 21H

	LEA DX, msgNEWLINE			; print result
	MOV AH, 09H
	INT 21H

	LEA DX, msgRESULT
	MOV AH, 09H
	INT 21H


	LEA DX, RESULT
	MOV AH, 09H
	INT 21H
    
	MOV AH, 4CH                             ;end program
	INT 21H
;------------------
INPUT PROC NEAR

	LEA    DX,msgINPUT                       ;print message
	MOV    AH,9
	INT    21H

	MOV DX,offset Buffer                     ;read and store string
	MOV AH,0AH
	INT 21H

        MOV CX,0
        MOV CL,Num3

        CLD
        MOV DI,offset Act_Buf                       ;sets di to beginning of string
        MOV AL,20H
        REPNE SCASB

        MOV BX,DI
        MOV SI,DI
        MOV DI,OFFSET OPERATOR
        MOVSB                                       ;stores operator in new string

        ADD SI,1
        MOV DI,offset Num2                          ;stores num2 in new string
        REP MOVSB

        SUB BX,1
        SUB BX,offset Act_Buf
        MOV CX,BX

        MOV SI,offset Act_Buf
        MOV DI,offset Num1

        REP MOVSB                                  ;stores num1 in new string

        MOV DI,offset Num2
        MOV AL,13D
        MOV CX,5
        REPNE SCASB
        SUB DI,1
        MOV AL,0H
        STOSB

	;--------------make error checks for num1 and num2
		

RET
INPUT ENDP
;----------------
ERROR PROC NEAR

	LEA    DX,msgError0                               ;print message
        MOV    AH,09H
      	INT    21H

	RET
 	ERROR ENDP
;-------------------
ASCII2HEX PROC NEAR

        PUSH BP
        MOV BP,SP
        MOV BX,[BP+4]                               ;obtain DI from stack
        MOV CX,0
        MOV AX,0
        MOV DX,0

        LOOP1: MOV CL,[BX]			;loop to check if equal to zero and converts every digit
            INC BX
            CMP CL,0DH
            JE LOOP2
            SUB CL,30H
            MOV AX,10
            MUL DX
            ADD AX,CX
            MOV DX,AX
            JMP LOOP1
        LOOP2:

        POP BP
RET 2                                               ;value of number is in dx
ASCII2HEX ENDP
;------------------
HEX2ASCII PROC NEAR

	MOV CX, 10
	PUSH 10
	MOV SI, BX
L1:
	MOV DX, 0
	DIV CX
	PUSH DX
	CMP AX, 0
	JNZ L1
L2:
	POP DX
	CMP DX, 10
	JE L4
	ADD DL, 30H
	CMP DL, 39H
	JMP L3
L3:
	MOV [BX], DL
	INC BX
	JMP L2
L4:
	MOV BYTE PTR[BX], 0

RET
HEX2ASCII ENDP
;-----------------
SUM PROC NEAR					; sum function

	PUSH BP
	 MOV BP,SP
	MOV AX,[BP+4]
	ADD AX,[BP+6]
	MOV RESULT, AX
	POP BP

RET 4
SUM ENDP
;----------------


CODE_SEG ENDS
END MAIN