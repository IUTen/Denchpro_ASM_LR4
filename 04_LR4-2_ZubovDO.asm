use16
org 100h

mov bx,0x0
mov di,0x0

int 0x84

mov ax,0x0
int 16h
int 20h
