.MODEL MEDIUM 
.STACK 100H

.DATA

     MYNAME   DB  '*** Nicolle Lenzmeier ***'

.CODE
.STARTUP

MAIN PROC FAR
     MOV AX, @DATA              ;INITIALIZE DS
     MOV DS, AX
     MOV ES, AX
     
     mov ah, 00h                ;change video mode
     mov al, 03h                ;80x25 CGA text
     int 10h                    ;set video mode

     mov al, 01h                ;color in bl, also move cursor
     mov ah, 13h                ;write string & attribute function
     mov cx, 20h                ;space for all of the characters
     mov bh, 00h                ;page 0(current page showing since we didn't change it)
     mov bl, 02h                ;CGA attribute
     mov bp, offset myname      ;set pointer to beginning of myname
     mov dh, 5                  ;row
     mov dl, 15                 ;column
     int 10h                    ;print string

     mov ah, 00h                ;is the function code for "read keyboard"
     int 16h                    ;wait for keypress
     
     MOV AH, 4CH                ;SETUP EXIT DOS PARAMETER
     INT 21H                    ;ACTUALLY EXIT DOS

.EXIT
MAIN ENDP
END