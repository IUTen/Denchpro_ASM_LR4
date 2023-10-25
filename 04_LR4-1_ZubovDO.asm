use16
org 100h

Start:
	jmp Init

Interruption:
	sti
	push ax
	push bx
	push dx
	push ds

	mov ax,cs
	mov ds,ax

	mov es, bx
	call dump

	pop ds
	pop dx
	pop bx
	pop ax
	iret

dump:
	pusha
	mov cx,16
	first_loop:
		push cx
		
		mov cx,16
		second_loop:
			mov al,byte[es:di]
			call main
			inc di

			push ax
			call space
			pop ax

			loop second_loop
		
		push ax
		push dx
		call next_string
		pop dx
		pop ax
		
		pop cx
		loop first_loop

	popa
	ret

space:
	mov ah,02h
	mov dx,0x20
	int 21h
	ret

next_string:
	mov ah,0x09
	mov dx, space_temp
	int 21h
	ret

main:	
	pusha
	mov cl,al

	mov ah, 0x02
	mov dl, cl
	shr dl,4
	call get_ascii
	int 21h

	mov dl, cl
	and dl,0x0f
	call get_ascii 
	int 21h

	popa
	ret

get_ascii:
  cmp dl,0x09   
  ja word_symbol  
  jmp digit_symbol

word_symbol:
  add dl,0x37
  ret

digit_symbol:
  add dl,0x30
  ret

space_temp:
  db 0xd, 0xa, '$'

Init:
	mov ah,0x25
	mov al,0x84
	mov dx,Interruption

	int 21h

	mov dx,Init
	int 27h