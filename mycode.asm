.MODEL small
.STACK 100h
.DATA
a DB 0
b DB 0
c DB 0
y db 3 dup (?) 
$ db '$'
msg1 db 13,10,'please enter a value for a',13,10,'$'
msg2 db 13,10,'please enter a value for b',13,10,'$'
msg3 db 13,10,'please enter a value for c',13,10,'$' 
msg4 db 13,10,'please enter a value for x',13,10,'enter e to stop',13,10,'$'
msg5 db 13,10,'y=$'
sixteen db 16h
.CODE 
proc kelet ;gets the parameter's value,from 0-9, and puts it in it's place
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
proc getY ;gets the x value(0-9),and uses the equation proc to get y,then prints it     
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
proc equation;use the input values to calculate the y value,then it puts it in cx
    push bp
    mov bp,sp
    mov cx,[bp+4]
    x equ cl
    mov al,a
    mul x
    mul x
    mov dx,ax
    xor ax,ax
    mov al,b
    mul x
    add dx,ax
    add dl,c
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