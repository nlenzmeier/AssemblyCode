.MODEL MEDIUM
.STACK 100H
.DATA
	NUM1	DB 23H
	NUM2	DB 35
	NUM3	DW 454H	;WHAT'S THE DIFFERENCE BETWEEN NUM1, NUM2, AND NUM3?
			;ANSWER: NUM3 IS A DOUBLE WORD, AND NUM2 IS IN DECIMAL 
			; WHILE NUM1 IS IN HEX
	MESSAGE	DB 'HELLO WORLD!', '$', 0DH, 0AH

.CODE
	.STARTUP
	MAIN PROC FAR
	MOV AX, @DATA
	MOV DS,AX ; why cannot do "MOV DS,@data"?
	MOV AX,0000H
	MOV AL,NUM1 ;1
	MOV AH,NUM2 ;2 What’s the difference between AL and AH?
	MOV AX,NUM3 ;3 Is “MOV AX,NUM1” valid? Why?
	MOV AX,offset NUM3 ;4 What does this MOV operation do compare to 3?
	MOV BX,0000H
	MOV CX,0000H
	MOV DX,0000H
	MOV SI,offset MESSAGE ;5
	MOV BX,SI ;6
	MOV BX,[SI] ;7 What’s the difference between 6 and 7?
		    ; Can we use registers other than SI?
	MOV CL,[SI] ;8 Does the value of SI change between 8 and 9?
	MOV CL,[SI+1] ;9 What’s the difference between them?
	MOV DL,[SI] ;10
	MOV DX,[SI] ;11 What’s the difference between 10 and 11?
	.EXIT
      ;MAIN ENDP
END