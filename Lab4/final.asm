

 .MODEL SMALL
 .STACK 100H

 .DATA
   PROMPT_1  DB           'Enter an algebraic command line: $'
   PROMPT_2  DB  0DH,0AH, 'Result: $'
   ILLEGAL   DB  0DH,0AH, 'Error! Input Format must be "Operand1 space Operator space Operand2". $'
   Op_Loop   DB  0DH,0AH, 'Again? (Y/N): $'
  
   num1ascii DB 10 DUP (0)
   num2ascii DB 10 DUP (0)
   blen      db 25
   bread     db ?
   buffer    DB 25 DUP ('$')
   operator  DB ?
   negative  DB ?

   .CODE
   .startup
   MAIN PROC FAR
     @Loop:                       ; Loops the entire process

     MOV AX, @DATA                ; initialize DS
     MOV DS, AX
     MOV ES,AX

     LEA DX, PROMPT_1             ; load and display the string PROMPT_1
     MOV AH, 09H
     INT 21H

     MOV DX,OFFSET BLEN           ;SAME AS LEA DX, BLEN
     MOV AH,0AH                   ;SETTING AH TO 0AH
     INT 21H                      ;IN PREPARATION OF USING 21H TO SET THE BUFFER INPUT

                                  ;  Parse, separate operands and operator into variables
     CALL parsestr                ; separate operands and operator into variables

                                  ;  Convert first operand to binary
    mov bx,Offset num1ascii
    CALL decimal_input
    CMP DI,"E"                    ; check if error occured
    JE @Continue                  ; stop if error
    mov bx,Offset num1ascii    
    CALL check_negative           ; check if negative and negate if needed
    MOV SI, DI                    ; save first operand conversion
     
                                  ;  Convert first operand to binary   
    mov bx,Offset num2ascii
    CALL decimal_input
    CMP DI,"E"                    ; check if error occured
    JE @Continue                  ; stop if error
    mov bx,Offset num2ascii    
    CALL check_negative           ; check if negative and negate if needed    
    MOV BX, DI                    ; save second operand conversion
    MOV DI, SI                    ; position first operand conversion

                                  ;  Get operator and perform operation     
     
     LEA SI, operator             ; get memory address of operator
     MOV AL, BYTE PTR[SI]         ; Moves the operator value into AL
     CMP AL,2FH                   ; compare to determine what to perform   2F = '/'
     JE @DIV                      ; jump to label
     CMP AL,2BH                   ; compare to determine what to perform   2B = '+'
     JE @ADD                      ; jump to label
     CMP AL,2DH                   ; compare to determine what to perform   2D = '-'
     JE @SUB                      ; jump to label     
     
     MOV AX, DI                   ; move one operand to accumulator for operation
     CALL DO_MULTIPLY             ; perform multiplication
     MOV BX, AX                   ; position output for display
     JMP @RESULT
     
     @DIV:
     MOV AX, DI                   ; move one operand to accumulator for operation
     MOV CX, BX
     CALL DO_DIVIDE               ; perform division
     MOV BX, AX                   ; position output for display
     JMP @RESULT 
     
     @ADD:
     CALL DO_ADDITION             ; perform addition
     
     JMP @RESULT    
     
     @SUB:
     CALL DO_SUBTRACTION          ; perform subtraction
     MOV BX, DI
     
     @RESULT:
     LEA DX, PROMPT_2             ; load and display the string PROMPT_2
     MOV AH, 9 
     INT 21H
     
     CALL DECIMAL_OUTPUT          ; call the procedure DECIMAL_OUTPUT

     @Continue:     
     LEA DX, OP_Loop              ; prints out requested loop string
     MOV AH, 9                       
     INT 21H
     
     MOV AH,01                    ; set input function
     INT 21H                      ; interrupt
     
     CMP AL, 59H                  ; compares for yes
     JE @Yes
     CMP AL, 79H
     JE @Yes     
     CMP AL, 59H                  ; compares for no
     JNE @No
     
     @Yes:                        ; perform loop
     MOV dl, 10                   ; lines 88-94 insert a character return
     MOV ah, 02h
     INT 21h
     MOV dl, 13
     MOV ah, 02h
     INT 21h
     JMP @Loop                    ; Jumps to @loop which I set to the beginning of the code

     @No:                         ; continues to finish program
     MOV AH, 4CH                  ; return control to DOS
     INT 21H 
     
   MAIN ENDP

 ;**************************************************************************;
 ;--------------------------- DO_MULTIPLY  ------------------------------;
 ;**************************************************************************;

 DO_MULTIPLY PROC
 ; this procedure will multiply 2 numbers in decimal form    
   ; input : BX, DI
   ; output : store binary number in BX
   ; uses : MAIN
   ; MUL only takes one value, the other is assumed (DI)
   
    MUL BX                       ; perform multiplication
    RET                          ; return control to the calling procedure
 DO_MULTIPLY ENDP 
 
  ;**************************************************************************;
  ;--------------------------- DO_DIVIDE  ------------------------------;
 ;**************************************************************************;

 DO_DIVIDE PROC
   ; this procedure will divide 2 numbers in decimal form    
   ; input : AX, CX
   ; output : store binary number in BX
   ; uses : MAIN
   ; MUL only takes one value, the other is assumed (AX)
   
   MOV DX,0                      ; zero extend DX for dividing two 16 bit numbers
   CWD
   IDIV CX                       ; perform division
    RET                          ; return control to the calling procedure
 DO_DIVIDE ENDP 
 
 ;**************************************************************************;
 ;--------------------------- DO_ADDITION  ------------------------------;
 ;**************************************************************************;

 DO_ADDITION PROC
   ; this procedure will add 2 numbers in decimal form    
   ; input : BX, DI
   ; output : store binary number in BX
   ; uses : MAIN
   
    ADD BX, DI                   ; perform addition
    RET                          ; return control to the calling procedure
 DO_ADDITION ENDP 
 
  ;**************************************************************************;
  ;--------------------------- DO_SUBTRACTION  ------------------------------;
 ;**************************************************************************;

 DO_SUBTRACTION PROC
 ; this procedure will subtract 2 numbers in decimal form    
   ; input : BX, DI
   ; output : store binary number in BX
   ; uses : MAIN
   
    SUB DI, BX                   ; perform subtraction
    RET                          ; return control to the calling procedure
 DO_SUBTRACTION ENDP 
 
 ;**************************************************************************;
 ;--------------------------- DECIMAL_INPUT  ------------------------------;
 ;**************************************************************************;

 DECIMAL_INPUT PROC
   ; this procedure will read a number in decimal form from a buffer    
   ; input : BX contains buffer address
   ; output : store binary number in DI
   ; uses : MAIN
   
   JMP @READ                      ; jump to label @READ

@ERROR:                           ; jump label
   LEA DX, ILLEGAL                ; load and display the string ILLEGAL
   MOV AH, 9                        
   INT 21H
   MOV DI, "E"
   JMP B2

@READ:                            ; jump label
    XOR DI,DI
    mov cx,0
    MOV AX, DX
    MOV cl,[bx]
    
    CMP CL, "-"                    ; compare AL with "-"
    JE B0                          ; jump if AL="-"
    
    CMP CL, "+"                    ; compare AL with "+"
    JE B0                          ; jump if AL="+"
    JMP B1                         ; jump to label
    
B0:                                ; jump label
    inc bx                         ; move bx to point to next char
    
B1: mov cl,[bx]                    ; read char
    inc bx
    cmp cl,0                       ; no more char to process, return
    je B2
                                   ; Be sure char is a number
    cmp cl,20H                     ; compare char with 0
    jl @ERROR                      ; error if char is less than 0
    cmp cl,45H                     ; compare char with 9
    jg @ERROR                      ; error if char is greater than 9
    sub cl,30h
    mov ax,10
    Mul DI
    add ax,cx
    mov DI,ax
    jmp B1
B2:
   RET                             ; return control to the calling procedure   

 DECIMAL_INPUT ENDP
  
 ;**************************************************************************;
 ;--------------------------- CHECK_NEGATIVE  ------------------------------;
 ;**************************************************************************;

 CHECK_NEGATIVE PROC
   ; this procedure checks if first character is minus and then negates if so     
   ; input : BX contains buffer address
   ; output : binary number in DI negated if needed
   ; uses : MAIN
   
    MOV cl,[bx]
    CMP CL, "-"                    ; compare CL with "-"
    JNE B3                         ; jump if CL="-"
    NEG DI
 B3:   
    ret
    
 CHECK_NEGATIVE ENDP

 ;**************************************************************************;
 ;---------------------------  DECIMAL_OUTPUT  -----------------------------;
 ;**************************************************************************;

 DECIMAL_OUTPUT PROC
   ; this procedure will display a decimal number from binary number
   ; input : BX
   ; output : none
   ; uses : MAIN

   CMP BX, 0                      ; compare BX with 0
   JGE @START                     ; jump to label @START if BX>=0
   MOV AH, 2                      ; set output function
   MOV DL, "-"                    ; set DL='-'
   INT 21H                        ; print the character

   NEG BX                         ; take 2's complement of BX

   @START:                        ; jump label
     MOV AX, BX                   ; set AX=BX
     XOR CX, CX                   ; clear CX
     MOV BX, 10                   ; set BX=10

   @REPEAT:                       ; loop label
     XOR DX, DX                   ; clear DX
     DIV BX                       ; divide AX by BX
     PUSH DX                      ; push DX onto the STACK
     INC CX                       ; increment CX
     OR AX, AX                    ; take OR of Ax with AX
   JNE @REPEAT                    ; jump to label @REPEAT if ZF=0

     MOV AH, 2                    ; set output function

   @DISPLAY:                      ; loop label
     POP DX                       ; pop a value from STACK to DX
     OR DL, 30H                   ; convert decimal to ascii code
     INT 21H                      ; print a character
   LOOP @DISPLAY                  ; jump to label @DISPLAY if CX!=0

   RET                            ; return control to the calling procedure
 DECIMAL_OUTPUT ENDP

 ;**************************************************************************;
 ;-----------------------------  Parse_String  -----------------------------;
 ;**************************************************************************;
 ; String in buffer that ends with $ is parsed according to space. An
 ; operand then operator then operand are each stored in separate variables
 ; Assumes that first character is not a space and no multiple spaces exist.
 
 parsestr PROC near
    
     MOV AL, 20H               ; Determine length until first space    
     MOV DI, Offset buffer     ; Initialize DI to beginning of buffer
     CLD                       ; Increment DI after each character
     MOV CX, 100H              ; Start count for CX doesn't matter
     REPNE SCASB               ; Scan string for space decrementing CX for each character

     MOV BX, DI                ; Retain address of byte after space
     MOV SI, DI                ; Set address for operator move in next character
     MOV DI, Offset operator   ; Move address of operator variable to DI
     MOVSB ; copies byte from addrs DS:SI to addrs ES:DI, then increments both SI and DI

     MOV CX, BX                ; set address of byte after space into CX
     DEC CX                    ; move CX address to space
     SUB CX, Offset buffer     ; determines the number of times for REP on MOVSB
     MOV SI, Offset buffer     ; sets SI to beginning of buffer for character copy
     MOV DI, Offset num1ascii  ; sets DI to beginning of variable for copy
     REP MOVSB ; copies byte from addrs DS:SI to addrs ES:DI, then increments both SI and DI no.times in CX

     ADD BX, 2                 ; assumes that a space follows the operand and moves to next operand
     MOV AL, 0DH               ; puts a CR byte into AL to search for end of string
     MOV DI, BX                ; position DI where to start search for end of string
     MOV CX, 100H              ; Start count for CX doesn't matter
     REPNE SCASB               ; Scan string for $ decrementing CX for each character

     DEC DI                    ; Move DI back so that it points to $ character
     MOV CX, DI                ; Set CX to DI to setup for SUB 
     SUB CX, BX                ; Determine number of characters to move
     MOV SI, BX                ; Set SI to first character to move from buffer
     LEA DI, num2ascii         ; sets DI to beginning of variable for copy 
     REP MOVSB ; copies byte from addrs DS:SI to addrs ES:DI, then increments both SI and DI no.times in CX             
  
  RET
parsestr ENDP   

 
 .exit
 END MAIN
 

