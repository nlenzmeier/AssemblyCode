.data
     x    db 100 dup (?)
     y    db 100 dup (?)

.code
.startup

MAIN proc far

     mov ax, @data                     ;initialize ds
     mov ds, ax
     mov es, ax
     
     mov ax, 0                         ;clear the ax register, just because
     mov si, offset x                  ;point si to x
     mov di, offset y                  ;point di to y
     mov cx, 0                         ; initialize loop counter
     
LOOP1:
      mov ah, [si]                     ;copy the byte pointer to by si into ah
                                       ;i.e. "read"
      mov al, ah
      and al, 10000000B
      cmp al, 00000000B
      je positive
      xor ah, 11111111B
      add ah, 00000001B
      jmp positive

positive:
      mov [di], ah                     ;then copy ah into the y array
      
      inc si                           ;advance source (x) pointer to the next element
      inc di                           ;advance destination (y) pointer to the next element
      inc cx                           ;add one to loop counter
      cmp cx, 100                      ;are we at the end?
      jne loop1                        ;if yes, then go back
      
      mov ah, 4ch                      ;exit to dos
      int 21h
      .exit

MAIN endp
