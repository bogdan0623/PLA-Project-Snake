.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;       Bogdan Turdean gr7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern free: proc
extern rand: proc
extern free: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Snake-Proiect",0
area_width EQU 640
area_height EQU 480
area DD 0



arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_size equ 10 ;dimensiunea desen
symbol_width EQU 10   ;dimensiune
symbol_height EQU 20  ;litere/cifre

include digits.inc
include letters.inc
include symbol.inc
include butoane.inc

;coordonate buton start
button_start_x equ 275
button_start_y equ 205
button_start_w equ 90
button_start_h equ 40

;contoare
score dd 0  ;tine scorul
counter DD 0 ; numara evenimentele de tip timer
button_start_count dd 0 ;numara de cate ori a fost apasat butonul
init_sarpe dd 0
snake_count dd 0
game_over dd 15

;coordonate butoane deplasare
buttons_area_x equ 500
buttons_area_y equ 150
buttons_size equ 30   ;dimensiunea laturii unui buton

;coordonate zona joc
game_area_size equ 440  ;latura zonei de joc
game_area_x equ 0
game_area_y equ 40

;coordonatele zonei de scor
score_area_x equ 440
score_area_y equ 40
score_area_height equ 440  ;dimensiunie
score_area_width equ 200   ;zonei de scor

;coordonate inceput sarpe
snake_init_head_x equ 35
snake_init_head_y equ 8
snake_actual_head_x dd 35
snake_actual_head_y dd 8
snake_init_size equ 2
snake_actual_size dd 2
snake_direction dd 3
snake_init_tail_x equ 35
snake_init_tail_y equ 7
snake_actual_tail_x dd 35
snake_actual_tail_y dd 7


;directii 
sus equ 0
jos equ 1
stanga equ 2
dreapta equ 3


;matrici

matrice_b db 4, 0, 4   ; butoane
		  db 2, 1, 3
		  
matrice_j db 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0   ;harta joc
		  db 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		  db 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0
		  db 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0

col equ 44		  
aux dd 0
ind dd 0
xij dd 0
yij dd 0
element dd 0
linii_b equ 2
coloane_b equ 3

nod struct 
	i dd 0
	j dd 0
	prev dd 0
	next dd 0
nod ends


cap nod {35, 8,offset coada,offset coada}
dim equ $-cap
coada nod {35,7,offset cap,offset cap}

patpat dd 44

food_x dd 0
food_y dd 0

mancat dd 0

head dd 0
tail dd 0

depl_i dd -1, 1, 0, 0
depl_j dd 0, 0, -1, 1

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0FF00h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp


; procedura make_symbol afiseaza desene la coordonatele date
; arg1 - simbolul de afisat (sarpe, ziduri etc)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_symbol proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 0
	jl make_space
	cmp eax, 1
	jg make_space
	lea esi, symbols
	jmp draw_text

make_space:	
	mov eax, 2
	lea esi, symbols
	
draw_text:
	mov ebx, symbol_size
	mul ebx
	mov ebx, symbol_size
	mul ebx
	add esi, eax
	mov ecx, symbol_size
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_size
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_size
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_negru
	cmp byte ptr [esi], 2
	je simbol_pixel_rosu
	mov dword ptr [edi], 0FF00h
	jmp simbol_pixel_next
simbol_pixel_negru:
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_rosu:
	mov dword ptr [edi], 0ff0000h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_symbol endp


; procedura make_buttons afiseaza butoane
; arg1 - simbolul de afisat (sageti, ziduri etc)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_buttons proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 0
	jl make_space
	cmp eax, 3
	jg make_space
	lea esi, butoane
	jmp draw_text
make_space:	
	mov eax, 4
	lea esi, butoane
	
draw_text:
	mov ebx, buttons_size
	mul ebx
	mov ebx, buttons_size
	mul ebx
	add esi, eax
	mov ecx, buttons_size
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, buttons_size
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, buttons_size
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_negru
	mov dword ptr [edi], 0FF00h ;verde
	jmp simbol_pixel_next
simbol_pixel_negru:
	mov dword ptr [edi], 0
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_buttons endp

;arg1 x
;arg2 y
;afla indicele din matrice pentru x si y
element_matrice proc
	push ebp
	mov ebp, esp
	pusha
	
	mov esi, [ebp+arg1]
	mov edi, [ebp+arg2]
	mov eax, esi
	mov ebx, col
	mul ebx
	add eax, edi
	mov element, eax
	
	
	popa
	mov esp, ebp
	pop ebp
	ret
element_matrice endp

element_matrice_macro macro x, y
	push y
	push x
	call element_matrice
	add esp ,8
endm

; afiseaza matricea jocului
afis_matrice_macro macro
local for_i, for_j
	pusha
	;matrice joc
	mov esi, 0
	mov edi, 0
for_i:
	mov edi, 0
for_j:
	mov eax, edi
	mov ebx, symbol_size
	mul ebx
	add eax, game_area_x
	mov xij, eax
	
	mov eax, esi
	mov ebx, symbol_size
	mul ebx
	add eax, game_area_y
	mov yij, eax
	
	mov eax, esi
	mov ebx, col
	mul ebx
	add eax, edi
	mov ebx, 0
	mov bl, matrice_j[eax]
	
	make_symbol_macro ebx, area, xij, yij
	
	inc edi
	cmp edi, col
jl for_j
	inc esi
	cmp esi, col
jl for_i
popa
endm

; un macro ca sa apelam mai usor desenarea simbolulu(litere/cifre)
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

; un macro ca sa apelam mai usor desenarea simbolurilor(desen)
make_symbol_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_symbol
	add esp, 16
endm

; un macro ca sa apelam mai usor desenarea butoanelor(desen)
make_buttons_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_buttons
	add esp, 16
endm


;macro desenare linie orizontale
line_horizontal macro x, y, len, color
local bucla_linie
	mov eax, y ;eax=y
	mov ebx, area_width
	mul ebx ;eax=y*area_width
	add eax, x ; eax=y*area_width+x
	shl eax, 2 ; eax=pozitia unde s-a dat click
	add eax, area
	
	mov ecx, len
bucla_linie:
	mov dword ptr[eax], color
	add eax, 4	
loop bucla_linie	
endm


;macro desenare linie verticala
line_vertical macro x, y, len, color
local bucla_linie
	mov eax, y ;eax=y
	mov ebx, area_width
	mul ebx ;eax=y*area_width
	add eax, x ; eax=y*area_width+x
	shl eax, 2 ; eax=pozitia unde s-a dat click
	add eax, area
	mov ecx, len
bucla_linie:
	mov dword ptr[eax], color
	add eax, area_width * 4
loop bucla_linie	
endm

; un macro care realizeaza deplasarea sarpelui cand acesta NU mananca
misca macro directie
local stg, drt, su, jos, final, go
	mov ebx, head
	mov edx, tail
	mov ecx, directie
	
	mov eax, [ebx+nod.j]
	add eax, [depl_j+ecx*4]
	cmp eax, 44
	je go
	cmp eax, 0
	jl go
	mov [edx+nod.j], eax
	
	mov eax, [ebx+nod.i]
	add eax, [depl_i+ecx*4]
	cmp eax, 44
	je go
	cmp eax, 0
	jl go
	mov [edx+nod.i], eax
	mov edx, [edx+nod.next]
	mov ebx, [ebx+nod.next]
	jmp final
	; mov aux, edx
	; cmp directie, 3
	; je drt
	; cmp directie, 2
	; je stg
	; cmp directie, 1
	; je jos
	; jl su 
; drt:
	; mov ecx, [edx+nod.next]
	; mov eax, [ebx+nod.j]
	; add eax, 1
	; cmp eax, 44
	; je go
	; mov [edx+nod.j], eax
	; mov eax, [ebx+nod.i]
	; mov [edx+nod.i], eax
	; mov edx, [edx+nod.next]
	; mov ebx, [ebx+nod.next]
	; jmp final
; stg:
	; mov ecx, [edx+nod.next]
	; mov eax, [ebx+nod.j]
	; sub eax, 1
	; cmp eax, 0
	; jl go
	; mov [edx+nod.j], eax
	; mov eax, [ebx+nod.i]
	; mov [edx+nod.i], eax
	; mov edx, [edx+nod.next]
	; mov ebx, [ebx+nod.next]
	; jmp final
; jos:
	; mov ecx, [edx+nod.next]
	; mov eax, [ebx+nod.i]
	; add eax, 1
	; cmp eax, 44 
	; je go
	; mov [edx+nod.i], eax
	; mov eax, [ebx+nod.j]
	; mov [edx+nod.j], eax
	; mov edx, [edx+nod.next]
	; mov ebx, [ebx+nod.next]
	; jmp final
; su:
	; mov ecx, [edx+nod.next]
	; mov eax, [ebx+nod.i]
	; sub eax, 1
	; cmp eax, 0
	; jl go
	; mov [edx+nod.i], eax
	; mov eax, [ebx+nod.j]
	; mov [edx+nod.j], eax
	; mov edx, [edx+nod.next]
	; mov ebx, [ebx+nod.next]
	; jmp final
go:
	mov game_over, -1
final:
mov head, ebx
mov tail, edx
endm

; un macro care realizeaza deplasarea sarpelui cand acesta mananca
misca_manca macro directie
local stg, drt, su, jos, final
	mov ebx, head
	mov edx, tail
	cmp directie, 3
	je drt
	cmp directie, 2
	je stg
	cmp directie, 1
	je jos
	jl su
drt:
	mov ecx, [ebx+nod.i]
	mov [eax+nod.i], ecx
	mov ecx, [ebx+nod.j]
	inc ecx
	mov [eax+nod.j], ecx
	mov [eax+nod.prev], ebx
	mov [eax+nod.next], edx
	mov [edx+nod.prev], eax
	mov [ebx+nod.next], eax
	mov eax, [eax+nod.prev]
	mov ebx, [eax+nod.next]
	jmp final
stg:
	mov ecx, [ebx+nod.i]
	mov [eax+nod.i], ecx
	mov ecx, [ebx+nod.j]
	dec ecx
	mov [eax+nod.j], ecx
	mov [eax+nod.prev], ebx
	mov [eax+nod.next], edx
	mov [edx+nod.prev], eax
	mov [ebx+nod.next], eax
	mov eax, [eax+nod.prev]
	mov ebx, [ebx+nod.next]
	jmp final
jos:
	mov ecx, [ebx+nod.i]
	inc ecx
	mov [eax+nod.i], ecx
	mov ecx, [ebx+nod.j]
	mov [eax+nod.j], ecx
	mov [eax+nod.prev], ebx
	mov [eax+nod.next], edx
	mov [edx+nod.prev], eax
	mov [ebx+nod.next], eax
	mov eax, [eax+nod.prev]
	mov ebx, [ebx+nod.next]
	jmp final
su:
	mov ecx, [ebx+nod.i]
	dec ecx
	mov [eax+nod.i], ecx
	mov ecx, [ebx+nod.j]
	mov [eax+nod.j], ecx
	mov [eax+nod.prev], ebx
	mov [eax+nod.next], edx
	mov [edx+nod.prev], eax
	mov [ebx+nod.next], eax
	mov eax, [eax+nod.prev]
	mov ebx, [ebx+nod.next]
	jmp final

final:
mov head, ebx
mov tail, edx
endm

; mcaro care apeleaza functia malloc
aloca macro dim
	mov eax, dim
	push eax
	call malloc
	add esp, 4
endm

;macro care modifica maricea jocului 
deseneaza macro el, simbol
	pusha
	
	mov ebx, el
	mov esi, [ebx+nod.i]
	mov ecx, [ebx+nod.j]
	element_matrice_macro esi, ecx
	mov eax, element
	mov matrice_j[eax], simbol
	
	popa
endm


; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic

;mai jos e codul care intializeaza fereastra cu pixeli negri
init_pixeli:
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 0
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_click:
	cmp button_start_count, 0
	jg verifica_butoane
	
	mov eax, [ebp+arg2]
	cmp eax, button_start_x
	jl button_fail_start
	cmp eax, button_start_x + button_start_w
	jg button_fail_start
	mov eax, [ebp+arg3]
	cmp eax, button_start_y
	jl button_fail_start
	cmp eax, button_start_y + button_start_h
	jg button_fail_start
	; click in buton START
	inc button_start_count
	cmp button_start_count, 1
	jge joc
	jmp afisare_litere
	
verifica_butoane:
	mov eax, [ebp+arg2]
	cmp eax, buttons_area_x
	jl joc
	cmp eax, buttons_area_x + coloane_b*buttons_size
	jg joc
	mov eax, [ebp+arg3]
	cmp eax, buttons_area_y
	jl joc
	cmp eax, buttons_area_y + linii_b*buttons_size
	jg joc
	
	;interiorul matricii
	mov eax, [ebp+arg2]
	sub eax, buttons_area_x
	mov edx, 0
	mov ebx, buttons_size
	div ebx
	mov esi, eax ;j
	
	mov eax, [ebp+arg3]
	sub eax, buttons_area_y
	mov edx, 0
	mov ebx, buttons_size
	div ebx
	mov edi, eax ;i
	
	cmp edi, 0
	je linia1
	jmp linia2
linia1:
	cmp esi, 1
	jne joc
	;sus
	cmp snake_direction, jos
	je joc
	mov snake_direction, sus
	jmp joc
linia2:
	cmp esi, 0
	je left
	cmp esi, 1
	je down
	jg right
left:
	cmp snake_direction, dreapta
	je joc
	mov snake_direction, stanga
	jmp joc
right:
	cmp snake_direction, stanga
	je joc
	mov snake_direction, dreapta
	jmp joc
down:
	cmp snake_direction, sus
	je joc
	mov snake_direction, jos
	jmp joc
	
	
	jmp afisare_litere
button_fail_start:
	cmp button_start_count, 0	
	je afisare_litere
	jmp joc
	
evt_timer:
	inc counter
	inc game_over
	cmp button_start_count, 1
	jl afisare_litere
	inc snake_count
	jmp joc
	
afisare_litere:
	cmp game_over, 15
	jge yay
	make_text_macro 'G', area, 510, score_area_y + 300
	make_text_macro 'A', area, 520, score_area_y + 300
	make_text_macro 'M', area, 530, score_area_y + 300
	make_text_macro 'E', area, 540, score_area_y + 300
	make_text_macro ' ', area, 550, score_area_y + 300
	make_text_macro 'O', area, 560, score_area_y + 300
	make_text_macro 'V', area, 570, score_area_y + 300
	make_text_macro 'E', area, 580, score_area_y + 300
	make_text_macro 'R', area, 590, score_area_y + 300
	jmp final_draw

yay:
	make_text_macro ' ', area, 510, score_area_y + 300
	make_text_macro ' ', area, 520, score_area_y + 300
	make_text_macro ' ', area, 530, score_area_y + 300
	make_text_macro ' ', area, 540, score_area_y + 300
	make_text_macro ' ', area, 550, score_area_y + 300
	make_text_macro ' ', area, 560, score_area_y + 300
	make_text_macro ' ', area, 570, score_area_y + 300
	make_text_macro ' ', area, 580, score_area_y + 300
	make_text_macro ' ', area, 590, score_area_y + 300
;facem matricea neagra
	mov esi, 0
	mov edi, 0
for_iJ:
	mov edi, 0
for_jJ:
	mov eax, edi
	mov ebx, symbol_size
	mul ebx
	add eax, game_area_x
	mov xij, eax
	
	mov eax, esi
	mov ebx, symbol_size
	mul ebx
	add eax, game_area_y
	mov yij, eax
	
	mov eax, esi
	mov ebx, col
	mul ebx
	add eax, edi
	mov ebx, 0
	mov bl, matrice_j[eax]
	
	make_symbol_macro ' ', area, xij, yij
	
	inc edi
	cmp edi, col
jl for_jJ
	inc esi
	cmp esi, col
jl for_iJ
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 620, 450
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 610, 450
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 600, 450
	
	;initializam scor
	
	mov score, 0
	
	;scriem un mesaj
	make_text_macro 'S', area, 295, 10
	make_text_macro 'N', area, 305, 10
	make_text_macro 'A', area, 315, 10
	make_text_macro 'K', area, 325, 10
	make_text_macro 'E', area, 335, 10
	
	;delimitare titlu
	line_horizontal 0, game_area_y-1, area_width, 0ff00h
	
	;Contur buton start
	line_horizontal button_start_x, button_start_y, button_start_w, 0ff00h
	line_horizontal button_start_x, button_start_y + button_start_h, button_start_w, 0ff00h
	line_vertical button_start_x, button_start_y, button_start_h, 0ff00h
	line_vertical button_start_x + button_start_w, button_start_y, button_start_h, 0ff00h
	
	;"start" scris in buton
	make_text_macro 'S', area, 295, 215
	make_text_macro 'T', area, 305, 215
	make_text_macro 'A', area, 315, 215
	make_text_macro 'R', area, 325, 215
	make_text_macro 'T', area, 335, 215
	
	;initializare sarpe
	mov snake_actual_size, snake_init_size
	mov snake_actual_head_x, snake_init_head_x
	mov snake_actual_head_y, snake_init_head_y
	mov snake_direction, dreapta
	mov snake_actual_tail_x, snake_init_tail_x
	mov snake_actual_tail_y, snake_init_tail_y
	
	mov cap.i, snake_init_head_x
	mov cap.j, snake_init_head_y
	mov coada.i, snake_init_tail_x
	mov coada.j, snake_init_tail_y
	mov eax, offset cap
	mov [coada.next], eax
	mov [coada.prev], eax
	mov eax, offset coada
	mov [cap.prev], eax
	mov [cap.next], eax
	; aloca nod
	; mov ebx, eax
	; lea ebx, cap
	; aloca nod
	; mov edx, eax
	; lea edx, coada
	; mov auxebx, ebx
	; mov auxedx, edx
	
	mov head, offset cap
	mov tail, offset coada
	
	
	
	;stergem valoarea scorului(unitati, zeci, sute)
	mov ebx, 10
	mov eax, score
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro ' ', area, score_area_x + 90, score_area_y + 50
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro ' ', area, score_area_x + 100, score_area_y + 50
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro ' ', area, score_area_x + 110, score_area_y + 50
	
	;sterg delimitare scor
	
	line_vertical game_area_size , game_area_y , game_area_size, 0
	
	;stergem un mesaj
	make_text_macro ' ', area, 520, score_area_y + 10
	make_text_macro ' ', area, 530, score_area_y + 10
	make_text_macro ' ', area, 540, score_area_y + 10
	make_text_macro ' ', area, 550, score_area_y + 10
	make_text_macro ' ', area, 560, score_area_y + 10
	
	
	;sterg butoane
	mov esi, 0
	mov edi, 0
for_iB:
	mov edi, 0
for_jB:
	mov eax, edi
	mov ebx, buttons_size
	mul ebx
	add eax, buttons_area_x
	mov xij, eax
	
	mov eax, esi
	mov ebx, buttons_size
	mul ebx
	add eax, buttons_area_y
	mov yij, eax
	
	mov eax, esi
	mov ebx, coloane_b
	mul ebx
	add eax, edi
	mov ebx, 0
	mov bl, matrice_b[eax]
	
	make_buttons_macro ' ', area, xij, yij
	
	inc edi
	cmp edi, coloane_b
jl for_jB
	inc esi
	cmp esi, linii_b
jl for_iB	
	
	
	jmp final_draw
joc:	
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 620, 450
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 610, 450
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 600, 450
	
	;afisam valoarea scorului(unitati, zeci, sute)
	mov ebx, 10
	mov eax, score
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, score_area_x + 110, score_area_y + 50
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, score_area_x + 100, score_area_y + 50
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, score_area_x + 90, score_area_y + 50
	
	;scriem un mesaj
	make_text_macro 'S', area, 295, 10
	make_text_macro 'N', area, 305, 10
	make_text_macro 'A', area, 315, 10
	make_text_macro 'K', area, 325, 10
	make_text_macro 'E', area, 335, 10
	
	;delimitare titlu
	line_horizontal 0, game_area_y - 1, area_width, 0ff00h
	
	;Sterg contur buton start
	line_horizontal button_start_x, button_start_y, button_start_w, 0
	line_horizontal button_start_x, button_start_y + button_start_h, button_start_w, 0
	line_vertical button_start_x, button_start_y, button_start_h, 0
	line_vertical button_start_x + button_start_w, button_start_y, button_start_h, 0
	
	;Sterg scrisul in buton
	make_text_macro ' ', area, 295, 215
	make_text_macro ' ', area, 305, 215
	make_text_macro ' ', area, 315, 215
	make_text_macro ' ', area, 325, 215
	make_text_macro ' ', area, 335, 215
	
	;delimitare scor
	
	line_vertical game_area_size , game_area_y , game_area_size, 0ff00h
	
	;butoane
	mov esi, 0
	mov edi, 0
for_i1:
	mov edi, 0
for_j1:
	mov eax, edi
	mov ebx, buttons_size
	mul ebx
	add eax, buttons_area_x
	mov xij, eax
	
	mov eax, esi
	mov ebx, buttons_size
	mul ebx
	add eax, buttons_area_y
	mov yij, eax
	
	mov eax, esi
	mov ebx, coloane_b
	mul ebx
	add eax, edi
	mov ebx, 0
	mov bl, matrice_b[eax]
	
	make_buttons_macro ebx, area, xij, yij
	
	inc edi
	cmp edi, coloane_b
jl for_j1
	inc esi
	cmp esi, linii_b
jl for_i1
	
	
	;scriem un mesaj
	make_text_macro 'S', area, 520, score_area_y + 10
	make_text_macro 'C', area, 530, score_area_y + 10
	make_text_macro 'O', area, 540, score_area_y + 10
	make_text_macro 'R', area, 550, score_area_y + 10
	make_text_macro 'E', area, 560, score_area_y + 10

	;afis_matrice_macro
	
	cmp mancat, 0
	je coord_random
	jmp xfx
coord_random:
	call rand 
	mov edx, 0
	div patpat
	mov food_x, edx
	
	call rand 
	mov edx, 0
	div patpat
	mov food_y, edx
	
	mov esi, food_x
	mov edi, food_y
	
	mov eax, esi
	mov ebx, col
	mul ebx
	add eax, edi
	mov ebx, 0
	mov bl, matrice_j[eax]
	
	cmp ebx, 0
	je coord_random
	
	mov mancat, 1
xfx:
	;fa simbol
	mov esi, food_x
	mov edi, food_y
	element_matrice_macro esi, edi
	mov eax, element
	mov matrice_j[eax], 1
	cmp init_sarpe, 1
	je miscare
initializare:
	mov ebx, head
	mov esi, [ebx]
	mov ecx, [ebx+4]
	element_matrice_macro esi, ecx
	mov eax, element
	mov matrice_j[eax], 0
	
	mov edx, tail
	mov esi, [edx]
	mov ecx, [edx+4]
	element_matrice_macro esi, ecx
	mov eax, element
	mov matrice_j[eax], 0
	
	mov ebx, head
	mov edx, tail

	afis_matrice_macro

	mov head, ebx
	mov tail, edx
	
	mov init_sarpe, 1
	cmp snake_count, 1
	jne final_draw
miscare:
 	mov ebx, head
	mov edx, tail
	
	;verific coliziuni
	cmp snake_direction, 0
	je vsu
	cmp snake_direction, 1
	je vj
	cmp snake_direction, 2
	je vst
	cmp snake_direction, 3
	je vd
vd:
	mov esi, [ebx]
	mov ecx, [ebx+4]
	inc ecx
	element_matrice_macro esi, ecx
	mov eax, element
	cmp matrice_j[eax], 0
	je restart
	cmp matrice_j[eax], 1
	jne nu_mananca
	jmp conn
vst:
	mov esi, [ebx]
	mov ecx, [ebx+4]
	dec ecx
	element_matrice_macro esi, ecx
	mov eax, element
	cmp matrice_j[eax], 0
	je restart
	cmp matrice_j[eax], 1
	jne nu_mananca
	jmp conn
vj:
	mov esi, [ebx]
	inc esi
	mov ecx, [ebx+4]
	element_matrice_macro esi, ecx
	mov eax, element
	cmp matrice_j[eax], 0
	je restart
	cmp matrice_j[eax], 1
	jne nu_mananca
	jmp conn
vsu:
	mov esi, [ebx]
	dec esi
	mov ecx, [ebx+4]
	element_matrice_macro esi, ecx
	mov eax, element
	cmp matrice_j[eax], 0
	je restart
	cmp matrice_j[eax], 1
	jne nu_mananca
	jmp conn
	
	
conn: ;mananca
	
	mov eax, tail
	mov ecx, snake_actual_size
	inc score
;aloca element nou
	mov eax, dim
	push eax
	call malloc
	add esp, 4
;deplaseaza sarpe
	misca_manca snake_direction
	inc snake_actual_size
;afiseaza sarpe
	mov eax, tail
	mov ecx, snake_actual_size
a:
	deseneaza eax, 2
	mov eax, [eax+nod.next]
loop a

	afis_matrice_macro
	
	mov mancat, 0
	mov head, ebx
	mov tail,edx
	
	jmp final_draw
nu_mananca:
;sterge sarpe
	mov eax, tail
	mov ecx, snake_actual_size
asdsa:
	deseneaza eax, 2
	mov eax, [eax+nod.next]
loop asdsa
	
	misca snake_direction
	
	cmp game_over, 0
	jl restart
	
;deseneaza sarpe

	mov eax, tail
	mov ecx, snake_actual_size
asds:
	deseneaza eax, 0
	mov eax, [eax+nod.next]
	loop asds
	
	afis_matrice_macro
	
	mov head, ebx
	mov tail,edx
	jmp final_draw
restart:
;sterge sarpe

	mov eax, tail
	mov ecx, snake_actual_size
asd:
	deseneaza eax, 2
	mov eax, [eax+12]
	loop asd
	
	; mov edx, tail
	; mov eax, [tail+nod.next]
	; mov ecx, snake_actual_size
; ffff:
	; push edx
	; call free
	; add esp, 4
	; mov edx, eax
	; mov eax, [eax+nod.next]
	; loop ffff
	
	
; sterge mancare
	mov esi, food_x
	mov edi, food_y
	element_matrice_macro esi, edi
	mov eax, element
	mov matrice_j[eax], 2
	
	mov game_over, 0
	mov button_start_count, 0
	mov score, 0
	mov init_sarpe, 0
	mov counter, 0
	mov mancat, 0
	mov snake_actual_size, 2
	mov head, offset cap
	mov tail, offset coada
	mov snake_direction, 2
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
