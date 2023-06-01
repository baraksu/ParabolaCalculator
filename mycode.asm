.MODEL small
.STACK 100h
.DATA 

 msg0 db '                       _           _      ',13,10, 
db '                       | |         | |      ',13,10,
db '  _ __   __ _ _ __ __ _| |__   ___ | | __ _ ',13,10,
db ' | _  \ / _` | __/ _` | _   \ / _ \| |/ _` |',13,10,
db ' | |_) | (_| | | | (_| | |_) | (_) | | (_| |',13,10,
db ' | .__/ \__,_|_|  \__,_|_.__/ \___/|_|\__,_|',13,10,
db ' | |                                        ',13,10,
db ' |_|                                        ',13,10,'$'

a DB 0;the first parameter
b DB 0;the second parameter
c Dw 0;the third parameter
msg1 db 13,10,'please enter a value for a(1-9)',13,10,'$';a's input-value request
msg2 db 13,10,'please enter a value for b(0-9)',13,10,'$';b's input-value request
msg3 db 13,10,'please enter a value for c(0-9)',13,10,'$';c's input-value request 
msg4 db 13,10,'please enter a value for x(0-9)',13,10,'enter e to stop',13,10,'$';x's endless input-value requests, until the user enters 'e' 
msg5 db 13,10,'axx+bx+c=y=$';a message to print before the y's calculated value
msg6 db 13,10,'hit any key to exit',13,10,'$';exit message
endCheck db 0;an indicator that is used to check if the drawing process has been finished
.CODE 
proc kelet
    ;gets the addresses of the parameter and of the required message to get it's value
    ;prints the message,gets the parameter's value and puts it in the right place
    push bp
    mov bp,sp
    mov dx,[bp+4]
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
    ;gets x values as an input, then calculates their y values and prints them.
    ;keeps going until the user writes 'e'.    
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
    ;gets the x value from the stack and the parameters from the data segment.
    ;calculates the matching y value and puts it in dx.
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
    ;gets a hexadecimal value in ax.
    ;prints the digits of the value one by one in decimal base.
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
proc x_axis     
     ;draws the x axis
     mov al,01h
     mov ah,0ch
     xor bx,bx
     mov cx,320d
     mov dx,100d
     next:
     int 10h
     loop next
     ret
endp x_axis
proc yAxis 
    ;draws the y axis
    mov cx,160d
    mov dx,0d
    y_axis:
    int 10h 
    inc dx
    cmp dx,200
    jne y_axis
    ret
endp yAxis
proc vertex  
    ;gets the parameters from the data segment.
    ;calculates the x and y values of the parabola's vertex,then draws it.  
    mov al,a
    mov bl,2
    mul bl
    mov bx,ax
    mov al,b
    neg ax
    idiv bl
    push ax
    call draw
    ret
endp vertex 
proc right    
    ;starting from the vertex, draws the on-screen points for each x values in the right side of the parabola.
    another_right:
    inc cx
    sub cx,160
    push cx
    call draw
    cmp endCheck,1
    je endOfRight
    jmp another_right
    endOfRight:
    mov endCheck,0
    ret
endp right
proc left 
    ;starting from the vertex, draws the on-screen points for each x values in the left side of the parabola.
    another_left:
    dec cx
    sub cx,160
    push cx
    call draw   
    cmp endCheck,1
    je endOfleft
    jmp another_left
    endOfLeft:
    ret
endp left
proc draw
    ;calculates the y value of the given x (from the stack)...
    ;...then draws the point in the right spot on the screen.
    pop di
    call equation
    pop cx  
    mov ax,dx
    mov bx,5
    div bl
    xor ah,ah
    mov dx,ax        
    mov ax,100d
    sub ax,dx
    mov dx,ax
    cmp dx,200
    jae endDraw
    cmp dx,0
    jbe endDraw
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
    mov al,04h
    mov ah,0ch
    xor bx,bx
    int 10h
    jmp endOfDraw
    endDraw:
    mov endCheck,1
    endOfDraw:
    push di 
    ret
endp draw 
start:
mov ax,@data
mov ds,ax        
lea dx,msg0
mov ah,09h
int 21h
;gets a parameter 
push offset a
push offset msg1
call kelet 
pop ax
pop ax           
;gets b parameter
push offset b
push offset msg2
call kelet      
pop ax
pop ax       
;gets c parameter
push offset c
push offset msg3
call kelet
pop ax
pop ax 
;gives y values for input x values
call getY    
;set graphic mode
mov ax, 13h
int 10h
;draws the x axis
call x_axis
;draws the y axis
call yAxis
;draws the vertex of the parabola 
call vertex
mov si,cx
;draws the right side of the parabola 
call right
;draws the left side of the parabola
mov cx,si 
call left
;exit
lea dx,msg6
mov ah,09h
int 21h
mov ah,01h
int 21h
mov ah,4ch
int 21h
end start