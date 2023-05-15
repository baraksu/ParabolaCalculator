 ;101 version
.MODEL small
.STACK 100h
.DATA

.CODE 
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
endp

start:
mov ax,@data
mov ds,ax  

mov ax, 333h
call print_ax

; print 16 


end start