.MODEL  SMALL
.STACK 100
.DATA
     X DB ?
     Y DW ?
     Z DW ?
.CODE
     .STARTUP
     
MAIN PROC FAR
     MOV DS, SS
     MOV [DI], [BX]
     MOV AX, 12H

