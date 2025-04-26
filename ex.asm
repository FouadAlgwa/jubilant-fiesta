.model small
.stack 100h
.data
    msg1 db 0dh, 0ah, 'Enter a decimal number: $'
    msg2 db 0dh, 0ah, 'The binary equivalent is: $'
    num dw ?
    binary db 16 dup('0'), '$'
.code
main proc
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    lea dx, msg1
    int 21h
    call read_decimal
    mov num, ax
    mov ah, 09h
    lea dx, msg2
    int 21h
    mov ax, num
    call decimal_to_binary
    mov ah, 09h
    lea dx, binary
    int 21h
    mov ah, 4ch
    int 21h
main endp
read_decimal proc
    xor bx, bx
read_loop:
    mov ah, 01h
    int 21h
    cmp al, 0dh
    je done_reading
    sub al, '0'
    mov ah, 0
    mov cx, ax
    mov ax, bx
    mov bx, 10
    mul bx
    add ax, cx
    mov bx, ax
    jmp read_loop
done_reading:
    mov ax, bx
    ret
read_decimal endp
decimal_to_binary proc
    mov bx, 15
    mov cx, 0
    cmp ax, 0
    je zero_case
convert_loop:
    mov dx, 0
    mov bx, 2
    div bx
    add dl, '0'
    mov bx, cx
    mov binary[bx], dl
    inc cx
    cmp ax, 0
    jne convert_loop
    mov si, 0
    mov di, cx
    dec di
reverse_loop:
    cmp si, di
    jge done_reversing
    mov al, binary[si]
    mov bl, binary[di]
    mov binary[si], bl
    mov binary[di], al
    inc si
    dec di
    jmp reverse_loop
zero_case:
    mov binary[0], '0'
    mov binary[1], '$'
    ret
done_reversing:
    mov binary[cx], '$'
    ret
decimal_to_binary endp
end main