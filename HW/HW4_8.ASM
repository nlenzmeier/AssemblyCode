STSEG SEGMENT
	DB 64 DUP (?)
STSEG ENDS
;--------------------
DTSEG SEGMENT
COUNT EQU 08
DATA  DW 2300, 4300, 1200, 3700, 1298, 4323, 5673, 986
      ORG 0010H
SUM   DW 2 DUP(?)
DTSEG ENDS
;-------------------
CDSEG SEGMENT

MAIN PROC FAR
     ASSUME CS:CDSEG,DS:DTSEG,SS:STSEG
		MOV AX, DTSEG
		MOV DS, AX
                MOV CX, COUNT
                MOV SI, OFFSET DATA
                MOV AX, 00
                MOV BX, AX
  BACK:         ADD AX, [SI]
                ADC BX, 0
                INC SI
                INC SI
                DEC CX
                JNZ BACK
                MOV SUM, AX
		MOV AH, 4CH
		INT 21H
MAIN ENDP
CDSEG ENDS
END MAIN
	