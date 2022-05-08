	%include "../lib64.asm"
	
	%macro write_string 2
	; вывод
	mov rax, 1                   ; системная функция 1 (write)
	mov rdi, 1                   ; дескриптор файла stdout=1
	mov rsi, %1                  ; адрес выводимой строки
	mov rdx, %2                  ; длина строки
	syscall                      ; вызов системной функции
	%endmacro
	
	%macro read_string 2
	; ввод
	mov rax, 0                   ; системная функция 0 (read)
	mov rdi, 0                   ; дескриптор файла stdin=0
	mov rsi, %1                  ; адрес вводимой строки
	mov rdx, %2                  ; длина строки
	syscall                      ; вызов системной функции
	%endmacro
	
	%macro str_to_int 1
	; перевод string в integer
	call StrToInt64              ; вызов процедуры
	cmp rbx, 0                   ; сравнение кода возврата
	jne StrToInt64.Error         ; обработка ошибки
	mov [%1], ax
	%endmacro
	
	%macro int_to_str 2
	; перевод integer в string
	mov rsi, %2
	mov ax, %1                   ; получение числа из памяти
	cwde
	call IntToStr64              ; вызов процедуры
	cmp rbx, 0                   ; сравнение кода возврата
	jne StrToInt64.Error         ; обработка ошибки
	%endmacro
	
	section .data                ; сегмент инициализированных переменных
	
	InputPrompt db "Enter matrix row by row", 10
	lenInputPrompt equ $ - InputPrompt
	
	InputPromptRow db " row: "
	lenInputPromptRow equ $ - InputPromptRow

	ResultMsg db "Result: s = "
	lenResult equ $ - ResultMsg
	
	ExitMsg db "Press Enter to Exit", 10 ; выводимое сообщение
	lenExit equ $ - ExitMsg

	i dd 0
	j dd 0
	start dd 0
	x dd 0
	len dd 0
	
	section .bss                 ;сегмент неинициализированных переменных
	
	InBuf resb 64                ; буфер для вводимой строки
	lenIn equ $ - InBuf

	OutBuf resb 10                ; буфер для вводимой строки

	mat resd 24
	mat_ptr resq 1
	
	section .text                ; сегмент кода
	
	global _start
_start:

	; =Вводим данные=
	write_string InputPrompt, lenInputPrompt ; выводит приглашение
	mov qword [mat_ptr], mat
inputLoop:
	inc dword [i]

	; =Вводим строку=
	xor ebx, ebx
	int_to_str [i], OutBuf
	dec rax
	mov rbx, rax
	write_string OutBuf, rbx ; выводит номер строки

	write_string InputPromptRow, lenInputPromptRow ; выводит row =
	read_string InBuf, lenIn

	; используем rcx для итерации по символам строки

	

	cmp dword [i], 4
	jl inputLoop

	; =Производим вычисления=
	

	; =Выводим результат=
	write_string ResultMsg, lenResult
	mov rbx, 0
	;int_to_str [result], OutBuf
	mov rbx, rax
	write_string OutBuf, rbx
	
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
