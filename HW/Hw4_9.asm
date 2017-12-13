.MODEL MEDIUM

.STACK 100H

.DATA
X DW 5
Y DW 10
RESULT DW  2 DUP(?)

.CODE
     .STARTUP
MAIN     PROC FAR

         MOV AX, @DATA
         MOV DS, AX
         MOV ES, AX
         
         PUSH X
         PUSH Y
         CALL FCTN1
         MOV RESULT, AX
         MOV RESULT[2], DX

         .EXIT
MAIN ENDP

;PROCEDURE: INT FCTN1(INT X, INT Y)
;RETURNS 3*X+7*Y IN DX-AX

FCTN1 PROC near

      PUSH SP
      MOV BP, SP
      MOV AX, [BP+6]
      MOV BX, 3
      MUL BX
      MOV BX, AX
      MOV AX, [BP+4]
      MOV CX, 7
      MUL CX
      ADD AX, BX
      POP SP
      RET

FCTN1 ENDP

END
