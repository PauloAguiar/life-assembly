.model small
.stack 100h
.data
	game_title		db	'LIFE!!','$'
	author			db	'PAULO HENRIQUE AGUIAR','$'
	xEditor			db  12
	yEditor			db  5
	flag			db	0
	lifeMatrix		db	289 dup(0)
	cellPointer		dw	18
	bufferMatrix 	db  289 dup(0)

	; Código de Teclas
	DRAW_KEY_ASCII	equ 99		; letra 'e'
	ERASE_KEY_ASCII	equ 32		; barra de espaço
	EXIT_KEY_CODE	equ 1 		; sair ao apertar ESC
	UP_CODE			equ 72		; codigo das setas
	RIGHT_CODE		equ 77
	DOWN_CODE		equ 80
	LEFT_CODE		equ 75
	EVO_CODE		equ 'e'

	; Códigos de Caracteres
	DRAW_ASCII		equ 1
	BLANK_ASCII		equ 0

.code
	; utils.asm
	extrn 	set_mode_40:proc, set_mode_80:proc
	extrn	putc:proc, puts:proc
	extrn	setxy:proc
	extrn	get_keystroke:proc
	; framer.asm
	extrn	draw_frame:proc

begin:
	mov		ax, @data		; Inicia segmento de dados
	mov 	ds, ax

	call 	set_mode_40

; Desenhar Molduras
	mov 	al, 9
	mov 	ah, 2
	mov 	bl, 29
	mov 	bh, 22
	call 	draw_frame

	mov 	al, 10
	mov 	ah, 3
	mov 	bl, 28
	mov 	bh, 21
	call 	draw_frame

	mov 	dl, 17
	mov 	dh, 3
	call 	setxy
	mov 	dx, offset game_title
	call	puts					; Desenha titulo

	mov 	dl, 9
	mov 	dh, 23
	call 	setxy
	mov 	dx, offset author
	call	puts					; Desenha autor

	mov 	al, 11
	mov 	ah, 4
	mov 	bl, 27
	mov 	bh, 20
	call 	draw_frame

mainloop:
	call 	editor
	cmp		flag, 1
	je 		close
	call	automato
	call	show
	jmp 	mainloop

close:
	call 	set_mode_80
	mov 	ah, 4ch
	int 	21h

; SUBROTINAS
; Subrotinas de evolução
automato:
	mov		si, 18
	mov		dh, 5
automato_loop1:
	mov		dl, 12
automato_loop2:
	call	count_neighbors
	mov		al, lifeMatrix[si]
	mov		bufferMatrix[si], 1
	cmp		al, 1
	je 		cell_alive
cell_dead:
	cmp		cl, 3
	je 		cell_keep_alive
	jmp		cell_die
cell_alive:
	cmp		cl, 2
	je 		cell_keep_alive
	cmp		cl, 3
	je 		cell_keep_alive
	jmp		cell_die
cell_die:
	mov		bufferMatrix[si], 0
cell_keep_alive:
	inc 	si
	inc		dl
	cmp		dl, 27
	jne		automato_loop2
	add		si, 2
	inc 	dh
	cmp		dh, 20
	jne		automato_loop1
	ret

count_neighbors:
	mov		cl, 0
	mov		bx, si
	sub 	bx, 18
	call	check_cell
	mov		bx, si
	sub 	bx, 17
	call	check_cell
	mov		bx, si
	sub 	bx, 16
	call	check_cell
	mov		bx, si
	sub 	bx, 1
	call	check_cell
	mov		bx, si
	add 	bx, 1
	call	check_cell
	mov		bx, si
	add 	bx, 16
	call	check_cell
	mov		bx, si
	add 	bx, 17
	call	check_cell
	mov		bx, si
	add 	bx, 18
	call	check_cell
	ret

check_cell:
	cmp		lifeMatrix[bx], 1
	jne 	check_cell_leave
	inc 	cl
check_cell_leave:
	ret

; Subrotina para redesenhar a tela ao evoluir o automato
show:
	call	copy_matrix		; Copia do buffer para a matriz principal
	mov		si, 18
	mov		dh, 5
show2:
	mov		dl, 12
show1:
	call	setxy
	mov		al, lifeMatrix[si]
	cmp		al, 1 			; Caso seja 1, temos uma celula ocupada
	jne		clear
	mov		al, DRAW_ASCII
	call	putc
	jmp 	advance
clear:
	cmp		al, 0
	call	putc
advance:
	inc 	si
	inc		dl
	cmp		dl, 27
	jne		show1
	add		si, 2
	inc 	dh
	cmp		dh, 20
	jne		show2
	ret

; Subrotina do editor
editor:
	mov		dl, xEditor		; Restaura a posição do cursor em modo Editor
	mov		dh, yEditor

editor_loop:
	call 	setxy
	call 	get_keystroke

	cmp 	ah, UP_CODE
	jne 	left

	cmp 	dh, 5
	je 		editor_loop
	sub 	cellPointer, 17
	dec 	dh
	jmp 	editor_loop

left:
	cmp 	ah, LEFT_CODE
	jne 	right

	cmp 	dl, 12
	je 		editor_loop
	dec 	cellPointer
	dec 	dl
	jmp 	editor_loop

right:
	cmp 	ah, RIGHT_CODE
	jne 	down

	cmp 	dl, 26
	je 		editor_loop
	inc 	cellPointer
	inc 	dl
	jmp 	editor_loop

down:
	cmp 	ah, DOWN_CODE
	jne 	draw

	cmp 	dh, 19
	je 		editor_loop
	add		cellPointer, 17
	inc 	dh
	jmp 	editor_loop

draw:
	cmp 	al, DRAW_KEY_ASCII
	jne 	erase

	mov 	al, DRAW_ASCII
	mov		si, cellPointer
	mov		lifeMatrix[si], 1
	call 	putc
	jmp 	editor_loop

erase:
	cmp 	al, ERASE_KEY_ASCII
	jne 	evo

	mov 	al, BLANK_ASCII
	mov		si, cellPointer
	mov		lifeMatrix[si], 0
	call 	putc
	jmp 	editor_loop

evo:
	cmp		al, EVO_CODE
	jne		exit
	jmp 	leave_evo

exit:
	cmp		ah, EXIT_KEY_CODE
	je		leave_exit
	jmp		editor_loop

leave_exit:
	mov		flag, 1
	ret

leave_evo:
	mov		xEditor, dl
	mov		yEditor, dh
	ret

; Subrotina para copiar a matriz life para o buffer
copy_matrix:
	mov		si, 1
copy_loop:
	mov		al, bufferMatrix[si]
	mov		lifeMatrix[si], al
	inc		si
	cmp		si, 289
	jne		copy_loop
	ret

end