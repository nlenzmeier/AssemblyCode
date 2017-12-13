.MODEL MEDIUM 
.STACK 100
.DATA
	buffer 	db 80
	num 	db ?
	act_buf db 80 dup (?)
	message db 'ECE3210 LAB2', 0dh, 0ah
		db 'Enter a string from keyboard (lass than 80): $'
	INCHAR db ?
	NEWLINE db 0dh, 0ah, '$'

.CODE
	.STARTUP	;initialize the program
		main proc far
			LEA	DX, MESSAGE	;PRINT THE MESSAGE
			MOV	AH, 9		; DISPLAYS CHARACTER ADDRESS
			INT	21H
	
			MOV	DX, OFFSET BUFFER
			MOV	AH, 0AH
			INT	21H

.EXIT
	MAIN ENDP
END
	
