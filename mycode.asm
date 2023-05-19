.MODEL small
.STACK 100h
.DATA
a DB 0
b DB 0
c Dw 0
msg1 db 13,10,'please enter a value for a(1-9)',13,10,'$'
msg2 db 13,10,'please enter a value for b(0-9)',13,10,'$'
msg3 db 13,10,'please enter a value for c(0-9)',13,10,'$' 
msg4 db 13,10,'please enter a value for x(0-9)',13,10,'enter e to stop',13,10,'$'
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
    mov cx,dx
    lea dx,msg5
    mov ah,09h
    int 21h
    mov ax,cx
    call print_ax
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
    imul x
    imul x
    mov dx,ax
    xor ax,ax
    mov al,b
    imul x
    add dx,ax
    add dx,c
    pop bp
    ret
endp equation 
print_ax proc
    cmp ax, 0
    jne print_ax_r
    push ax
    mov al, '0'
    mov ah, 0eh
    int 10h
    pop ax
    ret 
print_ax_r:
    pusha
    mov dx, 0
    cmp ax, 0
    je pn_done
    mov bx, 10
    div bx    
    call print_ax_r
    mov ax, dx
    add al, 30h
    mov ah, 0eh
    int 10h    
    jmp pn_done
pn_done:
    popa  
    ret  
endp print_ax 
proc vertex    
    mov al,a
    mov bl,2
    mul bl
    mov bx,ax
    mov al,b
    neg ax
    idiv bl
    push ax
    call equation
    pop cx
    cmp cl,0
    jg positive
    mov bx,160d
    neg cx
    sub bl,cl
    mov cx,bx
    jmp continue
    positive:
    add cx,160d
    continue:
    mov al,01h
    mov ah,0ch
    mov bx,100d
    sub bx,dx
    mov dx,bx
    xor bx,bx
    int 10h
    ret
endp vertex
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
call getY
mov ax,13h
int 10h 
;x axis
mov al,01h
mov ah,0ch
xor bx,bx
mov cx,320d
mov dx,100d
loopa:
int 10h
loop loopa
;y axis
mov cx,160d
mov dx,0d
y_axis:
int 10h 
inc dx
cmp dx,200
jne y_axis 
call vertex
end start