	section .data                ; сегмент инициализированных переменных
	A dd - 30
	B dd 21
	ExitMsg db "Press Enter to Exit", 10 ; выводимое сообщение
	lenExit equ $ - ExitMsg
	
	val1 db 255
	chart dw 256
	lue3 dw - 128
	v5 db 10h
	db 100101B
	beta db 23, 23h, 0ch
	sdk db "Hello", 10
	min dw - 32767
	ar dd 12345678h
	valar times 5 db 8
	
	section .bss                 ;сегмент неинициализированных переменных
	X resd 1
	InBuf resb 10                ; буфер для вводимой строки
	lenIn equ $ - InBuf

   alu     resw    10
   f1      resb    5

	section .text                ; сегмент кода
	global _start
_start:
	mov eax, [A]                 ; загрузить число A в регистр EAX
	add eax, 5                   ; сложить EAX и 5, результат в EAX
	sub eax, [B]                 ; вычесть число B, результат в EAX
	mov [X], eax                 ; сохранить результат в памяти
	; write
	mov rax, 1                   ; системная функция 1 (write)
	mov rdi, 1                   ; дескриптор файла stdout=1
	mov rsi, ExitMsg             ; адрес выводимой строки
	mov rdx, lenExit             ; длина строки
	syscall                      ; вызов системной функции
	; read
	mov rax, 0                   ; системная функция 0 (read)
	mov rdi, 0                   ; дескриптор файла stdin=0
	mov rsi, InBuf               ; адрес вводимой строки
	mov rdx, lenIn               ; длина строки
	syscall                      ; вызов системной функции
	; exit
	mov rax, 60                  ; системная функция 60 (exit)
	xor rdi, rdi                 ; return code 0
	syscall                      ; вызов системной функции
