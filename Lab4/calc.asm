    STACK_SEG SEGMENT STACK USE16
DB 100 DUP(?)
STACK_SEG ENDS

DATA_SEG SEGMENT 'DATA' USE16
                
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

num1ascii DB 10 DUP (0)
num2ascii DB 10 DUP (0)
operator DB  0H


msg1     DB 0DH,0AH,'Enter an Algebraic Expression: $'
msg2     DB 0DH,0AH,'Expression Entered is: $'
msgerror DB 0DH,0AH,'Error! Input format: Op1, operator, Op2 $'



msgOperand1 DB ' OP1', 0DH,0AH,'$'
msgOperand2 DB ' Op2', 0DH,0AH,'$'
msgOperator  DB ' Operand', 0DH,0AH,'$'
msgResult    DB ' Result', 0DH,0AH,'$'


AMOUNT   DB 255
COUNT   DB ?
EXP   DB 100 DUP ('$')
NEWLINE DB 0DH,0AH,'$'
DATA_SEG ENDS

CODE_SEG SEGMENT PARA 'CODE' PUBLIC USE16

ASSUME CS:CODE_SEG, DS:DATA_SEG, SS:STACK_SEG


MAIN PROC FAR
PUSH DS             
XOR AX,AX
PUSH AX
MOV AX,DATA_SEG
MOV DS,AX

    Lea DX, MSG1
    mov ah,9
    int 21H
    
     LEA DX,amount
            MOV AH,0AH          
                INT 21H

             MOV CX,0

                
             MOV CL,COUNT               
             TEST CL,0FFH
             JZ FINISH
             LEA DI,exp

L1:           
     MOV BL,BYTE PTR [DI]       
         MOV BH, 00H            
     MOV BL, BYTE PTR [BX]      
     MOV BH, 01H            
     INC WORD PTR [BX]          
     INc DI
  
   LOOP L1


                
   FINISH: LEA DX,msg2      
        MOV AH,9
        INT 21H
            
        MOV DI, OFFSET EXP   ;xxxxxx
        MOV CX, 100H
        CLD
        Mov AL, 20H
        REPNE SCASB  ; di now points to operator save bx+2
        
        mov bx, di
        mov si, di
        mov di, offset operator
        movsb
        
        mov cx, bx
        dec cx
        sub cx, offset EXP
        
        mov si, offset exp
        mov di, offset num1ascii
        rep movsb 
        add bx, 2
        mov di , bx
        mov Al, 0D
        mov cx, 10
        repne scasb 
        
        dec di
        mov cx, di
        sub cx, BX
        mov si, bx
        mov di,  offset num2ascii
        rep movsb
        
     
        c1:
        mov ax, 2ah
        cmp ax, offset operator
        je c2
        jne c3
        c3:lea dx, msgerror
        mov ah,9 
        int 21h
        c2: ret 
        
        
        ;;;; check for negative and make sure its numbers here
       
        
        num1 dw 0
        num2 dw 0
        
        ascii proc far
        
        mov si, offset num1ascii
        mov di, offset num1
        call a2h
        
        mov si, offset num2ascii
        mov di, offset num2
        call a2h
        
        ascii endp
        
        a2h proc Near
        mov cx, 0
        mov ax,0
        
       b1:
       mov cl, [si]
       inc si
       cmp cl,0
       je b2
       sub cl, 30h
       mov ax,10
       mul word ptr [di]
       add ax, cx
       jmp b1
       
       b2:
        ret
        
        a2h endp
        

RET
MAIN ENDP
CODE_SEG ENDS
END MAIN