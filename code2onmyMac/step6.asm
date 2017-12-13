.MODEL MEDIUM
.STACK 100H
.DATA
.CODE
	.STARTUP
 	MAIN PROC FAR
L1: MOV AL,18H ;1 What is L1 here?(Hint: address)
	CMP AL,20H ;2
	JE L1 ;3
	MOV AL,20H ;4
	CMP AL,20H ;5
	JE L2 ;6 What’s the difference between 3 and 6?
	MOV AL,33H ;7 Does AL change to 33H?
	L2: MOV AL,44H ;8
	.EXIT
 	MAIN ENDP
END