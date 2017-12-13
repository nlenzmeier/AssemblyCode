.MODEL MEDIUM

.STACK 100H

.data
     k dw ?
     p db 500 dup (?)
     
.code
.startup

MAIN proc far
     mov ax, @data              ;initialize ds
     mov ds, ax
     mov es, ax

     mov ax, 0
     mov si, offset p           ;point si to p
     mov cx, k                  ;have k equal to cx

LOOP1:
     mov ax, [si]               ;copy the byte pointer to by si into ah
                                ;i.e. "read

     cmp ax, 300d               ;if(p[k]<300)
     jb LESS                    ;go to less
     sub ax, cx                 ;ELSE p[k] = p[k] - k
     mov [si], ax
     add si, 2                  ;moves si to next "element"
     inc cx                     ;k++
     mov k, cx                  ;moves value of cx to k
     cmp cx, 500                ;sees if cx is greater or equal to 500
     jne loop1                  ;if not, loop again
     jmp FINISH                 ;else, finish

LESS:
     add ax, cx                ;p[k] = p[k] + k
     mov [si], ax
     add si, 2                 ;moves si to next "element"
     inc cx                    ;k++
     mov k, cx                 ;moves value of cx to k
     cmp cx, 500               ;sees if cx is great or equal to 500
     jne loop1                 ;if not, loop again

FINISH:
     mov ah, 4ch                  ;exit to dos
     int 21h
     .exit

MAIN endp

END
