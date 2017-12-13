
;CGA text mode
; mode 03h
;(a)Change the video mode
;(b)Display the letter 'F' IN high ontensity white on blue

INCLUDE DOS.MAC
.model small
.386
.stack 100h
.data

    SYMBOL DB    'N'  ; ASCII CHARCHTER 1H= FUNNY  FACE, 03H HEART...ETC
    SYM2   DB    ':'
    SYM3   DB    '<3'
    SYM4   DB    '*'
    SYM5   DB    ' '
    COLOR DB    1FH    ; high intensity white on blue
.code
.startup

main proc far
  mov ax,@data
  mov ds,ax
  mov es, ax

;;;;;; SET THE VIDEO MODE;;;;;;;;;;;
       mov ah,00h
       mov al,03h    ;CGA color text mode of 80*25
       int  10h


; macros are defined in  DOS.AMC

    SET_CURSOR   30,10
    WRITE_CHAR   SYMBOL,COLOR,2       ;NN
    SET_CURSOR   36,10
    WRITE_CHAR   SYMBOL, COLOR, 2     ;NN
    SET_CURSOR   30, 11
    WRITE_CHAR   SYMBOL,COLOR,3        ;FF
    SET_CURSOR   36,11
    WRITE_CHAR   SYMBOL,COLOR, 2
    SET_CURSOR   30, 12
    WRITE_CHAR   SYMBOL,COLOR,4        ;FF
    SET_CURSOR   36,12
    WRITE_CHAR   SYMBOL,COLOR,2        ;FFFFFFF
    SET_CURSOR   30,13
    WRITE_CHAR   SYMBOL,COLOR,2        ;FF
    SET_CURSOR   33,13
    WRITE_CHAR   SYMBOL,COLOR,2
    SET_CURSOR   36,13
    WRITE_CHAR   SYMBOL,COLOR,2
    SET_CURSOR   30,14
    WRITE_CHAR   SYMBOL,COLOR,2
    SET_CURSOR   34,14
    WRITE_CHAR   SYMBOL,COLOR,4
    SET_CURSOR   30,15
    WRITE_CHAR   SYMBOL,COLOR,2        ;FF
    SET_CURSOR   35,15
    WRITE_CHAR   SYMBOL,COLOR,3        ;FF
    SET_CURSOR   30,16
    WRITE_CHAR   SYMBOL,COLOR,2
    SET_CURSOR   36,16
    WRITE_CHAR   SYMBOL,COLOR,2
    
    SET_CURSOR   40,10                     ;I
    WRITE_CHAR   SYM2,COLOR,2
    SET_CURSOR   40,11
    WRITE_CHAR   SYM2,COLOR,2
    SET_CURSOR   40,12
    WRITE_CHAR   SYM2,COLOR,2
    SET_CURSOR   40,13
    WRITE_CHAR   SYM2,COLOR,2
    SET_CURSOR   40,14
    WRITE_CHAR   SYM2,COLOR,2
    SET_CURSOR   40,15
    WRITE_CHAR   SYM2,COLOR,2
    SET_CURSOR   40,16
    WRITE_CHAR   SYM2,COLOR,2
    
    SET_CURSOR   44,10
    WRITE_CHAR   SYM3,COLOR,6
    SET_CURSOR   44,11
    WRITE_CHAR   SYM3,COLOR,6
    SET_CURSOR   44,12
    WRITE_CHAR   SYM3,COLOR,2
    SET_CURSOR   44,13
    WRITE_CHAR   SYM3,COLOR,2
    SET_CURSOR   44,14
    WRITE_CHAR   SYM3,COLOR,2
    SET_CURSOR   44,15
    WRITE_CHAR   SYM3,COLOR,6
    SET_CURSOR   44,16
    WRITE_CHAR   SYM3,COLOR,6
    
    SET_CURSOR   52,10
    WRITE_CHAR   SYM4,COLOR,6
    SET_CURSOR   52,11
    WRITE_CHAR   SYM4,COLOR,6
    SET_CURSOR   52,12
    WRITE_CHAR   SYM4,COLOR,2
    SET_CURSOR   56,12
    WRITE_CHAR   SYM4,COLOR,2
    SET_CURSOR   52,13
    WRITE_CHAR   SYM4,COLOR,2
    SET_CURSOR   56,13
    WRITE_CHAR   SYM4,COLOR,2
    SET_CURSOR   52,14
    WRITE_CHAR   SYM4,COLOR,2
    SET_CURSOR   56,14
    WRITE_CHAR   SYM4,COLOR,2
    SET_CURSOR   52,15
    WRITE_CHAR   SYM4,COLOR,6
    SET_CURSOR   52,16
    WRITE_CHAR   SYM4,COLOR,6

    SET_CURSOR   60, 10
    WRITE_CHAR   SYM5,COLOR,10

;;;;;;;;END;;;;;;;;
  mov ah,4ch
  int 21h


main endp

end
