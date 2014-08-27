.model small

; Constantes
	TOP_LEFT_CHAR		equ 201
	TOP_CHAR			equ 205
	TOP_RIGHT_CHAR		equ 187
	RIGHT_CHAR			equ 186
	BOTTOM_RIGHT_CHAR	equ 188
	BOTTOM_CHAR			equ 205
	BOTTOM_LEFT_CHAR	equ 200
	LEFT_CHAR			equ 186

.data
	xTopLeft		db (?)
	yTopLeft		db (?)
	xBottomRight	db (?)
	yBottomRight	db (?)

.code
	extrn setxy:proc, putc:proc
;	Subrotina para desenhar uma moldura na tela
;	Entrada:
;		al = x superior esquerdo
;		ah = y superior esquerdo
;		bl = x inferior direito
;		bh = y inferior direito
;

public draw_frame
draw_frame proc
	mov 	dx, ax
	; Guardar valores de referencia
	mov		xTopLeft, dl
	mov		yTopLeft, dh

	; mover cl e ch de acordo com altura e largura do frame
	mov 	xBottomRight, bl
	mov 	yBottomRight, bh

	call 	setxy
	mov 	al, TOP_LEFT_CHAR
	call	putc

	mov		al, TOP_CHAR
top:
	inc		dl
	cmp		dl, xBottomRight
	je		topright
	call 	setxy
	call	putc
	jmp 	top

topright:
	call	setxy
	mov		al, TOP_RIGHT_CHAR
	call	putc

	mov		al, RIGHT_CHAR
right:
	inc		dh
	cmp		dh, yBottomRight
	je		bottomright
	call 	setxy
	call	putc
	jmp 	right

bottomright:
	call	setxy
	mov		al, BOTTOM_RIGHT_CHAR
	call	putc

	mov		al, BOTTOM_CHAR
bottom:
	dec 	dl
	cmp		dl, xTopLeft
	je		bottomleft
	call	setxy
	call 	putc
	jmp		bottom

bottomleft:
	call	setxy
	mov		al, BOTTOM_LEFT_CHAR
	call	putc

	mov		al, LEFT_CHAR
left:
	dec		dh
	cmp 	dh, yTopLeft
	je		end_draw
	call	setxy
	call 	putc
	jmp		left

end_draw:
	ret
draw_frame endp
end