;STACK_SEG SEGMENT STACK USE16
;DB 100 DUP(?)
;STACK_SEG ENDS
.model small
.stack 100h


.data
				; declaring all of our variables
SYM1   DB 9 DUP (02H)
TAB   DB 0
SYM2   DB 22 DUP (02H)
SPACE   DB 00H
SYM3   DB 15 DUP (02H)
NUM   DB 10 DUP (04H)
SYM4   DB 7 DUP (02H)
A_CAP   DB 26 DUP (06H)
SYM5     DB 6 DUP (02H)
LCASE    DB 26 DUP (08H)
SYM6   DB 133 DUP (02H)

                
NOTSYM   DW 0000H
symc   DW 0000H
numc   DW 0000H
capc  DW 0000H
lowc    DW 0000H
					; messages we want printed on the screen
msg1 DB 'N&J: Enter a string: $' 	; to the user
msg2 DB 0DH,0AH,'Input String: $'
msg3 DB 0DH,0AH,'Contains: $'


capSTR    DB ' Capitol Letters',0DH,0AH,'$'	; more printed messages, 
lowSTR   DB ' Small Letters',0DH,0AH,'$'	; displaying the total countered
numSTR DB ' Number (s)', 0DH,0AH,'$'		; for each category
symbolSTR DB ' Symbols (s)', 0DH,0AH,'$'
msg4 DB 'Thank you!' ,0DH, 0AH, '$'


AMOUNT   DB 100
COUNT   DB ?
INCHAR   DB 100 DUP ('$')
NEWLINE DB 0DH,0AH,'$'

.code
.startup

MAIN PROC FAR
PUSH DS             
XOR AX,AX
PUSH AX
MOV AX,@data
MOV DS,AX

                
        LEA DX,msg1  
            MOV AH, 09H   		;DISPLAY STRING, MSG1    
                INT 21H

                
        LEA DX,amount
            MOV AH,0AH
                INT 21H

             MOV CL,COUNT
	MOV SI, OFFSET INCHAR

LOOP1:					;number counter

	CMP BYTE PTR[SI], '0'
	JB next1
	CMP byte ptr[SI], '9'
	JA next1
	inc numc
	jmp endofloop

next1:					;capital letter counter
	cmp byte ptr[SI], 'A'
	jb next2
	cmp byte ptr[SI], 'Z'
	ja next2
	inc capc
	jmp endofloop

next2:					;lowercase letter counter
	cmp byte ptr[SI], 'a'
	jb next3
	cmp byte ptr[SI], 'z'
	ja next3
	inc lowc
	jmp endofloop

next3:
	cmp byte ptr[SI], 20h		; recognizes spaces and tabs and if its anything
	je endofloop			; but spaces or tabs then it counts as a symbol
	cmp byte ptr[SI], 09h
	je endofloop
	inc symc
	
endofloop:
	inc SI
	dec count			; Ends loop when count reaches 0
	jnz Loop1




                
    LEA DX,msg2      
        MOV AH,9
            INT 21H			;all the of the print messages

     LEA DX,INCHAR          
            MOV AH,9
            INT 21H

            LEA DX,msg3          
         MOV AH,9
            INT 21H

                
            MOV AX, capc
             AAM
         ADD AX, 3030H
         MOV BX, AX
  
                
        MOV DL,BH           
        MOV AH,2
            INT 21H

                 
        MOV DL,BL           
        MOV AH,2
            INT 21H

                    
            LEA DX, capSTR     
        MOV AH,9
        INT 21H    ;xxxxxxx end capcount

                
        MOV AX, lowc				; prints the number of lower cap
         AAM
         ADD AX, 3030H
         MOV BX, AX
  
                 
         MOV DL,BH          			
         MOV AH,2
            INT 21H

                
        MOV DL,BL           
        MOV AH,2
            INT 21H

                
            LEA DX,lowSTR      
        MOV AH,9
        INT 21H ;xxxx endlowcount

                
        MOV AX,numc
        AAM
        ADD AX, 3030H			;prints numbers
        MOV BX, AX
  
                
        MOV DL,BH           
        MOV AH,2
            INT 21H

                    
        MOV DL,BL            
        MOV AH,2
            INT 21H

                 
            LEA DX,numSTR           
         MOV AH,9
         INT 21H ;xxx end numcount
  
                
         MOV AX,Symc			;prints symbols
             AAM
         ADD AX, 3030H
         MOV BX, AX
  
                
        MOV DL,BH           
        MOV AH,2
            INT 21H

                
        MOV DL,BL           
        MOV AH,2
            INT 21H


            LEA DX,symbolSTR
        MOV AH,9
        INT 21H  			;xxx end symcount

        MOV DX,OFFSET NEWLINE
        MOV AH,9
            INT 21H

.EXIT						;ends
MAIN ENDP
END MAIN