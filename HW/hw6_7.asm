.MODEL MEDIUM

.STACK 100H

PUBLIC MYARRAY, COUNT, RESULT

.DATA
     MYARRAY DW -45, 1000, -34, 1500, 20, 60
     COUNT   EQU 6                                ;SIX ELEMENTS IN THE ARRAY
     RESULT  DW 0
     
.CODE
.startup
MAIN PROC FAR
     MOV AX, @DATA
     MOV DS, AX
     MOV CX, COUNT
     LEA SI, MYARRAY
     CALL FINDMIN
     MOV result, bx

     MOV AH, 4CH                             ;exit to dos
     INT 21H
     .EXIT
MAIN ENDP

;PUBLIC FINDMIN
FINDMIN PROC NEAR
      mov ax, [si]                           ;PULL NEXT ELEMENT OUT OF ARRAY
      mov bx, ax                             ;loading BX with the first array element
      add si, 2                              ;Advance SI to the next array element

loop1:
      mov ax, [si]                           ;moves new si into ax before changing si again
      add si, 2                              ;Advance SI to the next array element
      cmp ax, bx                             ;compares array elements
      jg  AGAIN                              ;If new values smaller than current value, go to replace it
                                             ;new value is larger so skip to loop end to go around again
      mov bx, ax                            ;moves second element into first element
                                             ;therefore making it the "new min"

AGAIN:
      loop loop1                             ;run program again
      ret

FINDMIN ENDP
END