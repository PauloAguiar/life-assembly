.model small
.data
.code

;	Subrotina para imprimir um caractere na posição atual do cursor
;	Entrada:
;		al = código do caractére a ser colocado na tela
;

public putc
putc	proc
	mov		ah, 10
	mov 	bh, 0
	mov 	cx, 1
	int 	10h
	ret
putc	endp

;	Subrotina para imprimir uma string na posição atual do cursor
;	Entrada:
;		dx = endereço da string a ser escrita
;

public puts
puts	proc
	mov		ah, 9
	int 	21h
	ret
puts	endp
;	Subrotina para alterar a posição do cursor
;	Entrada:
;		dh = linha para o cursor deve ir
;		dl = coluna para o cursor deve ir

public setxy
setxy	proc
	mov 	ah, 2
	mov 	bh, 00h
	int 	10H
	ret
setxy	endp

;
;	Muda o modo de video para 40 colunas
;

public set_mode_40
set_mode_40	proc
	mov		ah, 0
	mov		al, 1
	int		10h
	ret
set_mode_40 endp

;
;	Muda o modo de video para 80 colunas
;

public set_mode_80
set_mode_80	proc
	mov		ah, 0
	mov		al, 3
	int		10h
	ret
set_mode_80 endp

;	Ler teclas a partir de uma interrupção da bios(int 16h/ ah 00h)
;	Retorna:
;		ah = BIOS scan code
;		al = ASCII character
;
;	Altera: ah, al

public get_keystroke
get_keystroke proc
	mov		ah, 00h
	int 	16h
	ret
get_keystroke endp
end