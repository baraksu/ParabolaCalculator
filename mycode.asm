.MODEL small
.STACK 100h
.DATA
a DB 0
b DB 0
c DB 0
y db 4 dup (?) 
$ db '$'
msg1 db 13,10,'please enter a value for a',13,10,'$'
msg2 db 13,10,'please enter a value for b',13,10,'$'
msg3 db 13,10,'please enter a value for c',13,10,'$' 
msg4 db 13,10,'please enter a value for x',13,10,'enter e to stop',13,10,'$'
msg5 db 13,10,'y=$'
.CODE 
proc kelet
    push bp
    mov bp,sp
    mov bx,[bp+4]
    lea dx,bx
    mov ah,09h
    int 21h
    mov ah,01h
    int 21h
    mov bx,[bp+6] 
    sub al,48
    mov [bx],al
    pop bp
    ret
endp kelet  
proc getY     
    restart:
    lea dx,msg4
    MOV ah,09h
    int 21h    
    mov ah,01h
    int 21h
    cmp al,'e'
    je FINISH 
    xor ah,ah  
    sub al,48
    push ax
    call equation
    pop ax
    lea dx,msg5
    mov ah,09h
    int 21h
    lea dx,y
    mov ah,09h
    int 21h
    jmp restart
    FINISH:
    ret
endp getY
proc equation
    push bp
    mov bp,sp
    mov cx,[bp+4]
    x equ cl
    mov al,a
    mul x
    mov bx,ax
    xor ah,ah
    mov al,x
    imul bx
    mov bx,offset y
    mov [bx],dx
    mov [bx+2],ax
    mov al,b
    imul x
    add [bx],ax
    add al,c
    add [bx],al
    pop bp
    ret
endp equation
start:
mov ax,@data
mov ds,ax  
push offset a
push offset msg1
call kelet 
pop ax
pop ax
push offset b
push offset msg2
call kelet      
pop ax
pop ax
push offset c
push offset msg3
call kelet
pop ax
pop ax
MOV BX,OFFSET y     
call getY
end start