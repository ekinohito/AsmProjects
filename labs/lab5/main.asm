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
	call    StrToInt64          ; вызов процедуры
    cmp     rbx, 0              ; сравнение кода возврата
    jne     StrToInt64.Error    ; обработка ошибки
    mov     %1, eax            
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
	start dq 0
	x dd 0
	len dd 0
	
	section .bss                 ;сегмент неинициализированных переменных
	
	InBuf resb 64                ; буфер для вводимой строки
	lenIn equ $ - InBuf
	
	OutBuf resb 10               ; буфер для вводимой строки
	
	matrix  resd    24          ; 4 * 6 = 24 => резервируем 24 элементов для матрицы
	
	section .text                ; сегмент кода
	
	global _start
_start:
	
	; =Вводим данные=
	write_string InputPrompt, lenInputPrompt ; выводит приглашение
	; ввод матрицы
	mov rcx, 0                   ; обнуляем счётчик внешнего цикла
cycle_read_matrix:
	push rcx                     ; помещаем rcx в стек
	
	sub rsp, 16                  ; выделяем память для буфера перевода строк в числа
	sub rsp, 64                  ; выделяем память для буфера ввода
	
	read_string rsp, 64
	
	mov rcx, 0                   ; rcx - индекс символа в строке, введенной пользователем
	mov rax, [rsp + 80]          ; поместим в rax номер текущей строки
	imul rax, 6                  ; вычислим индекс элемента массива для записи при сквозной нумерации
	mov [rsp + 70], ax           ; [rsp + 70] - индекс элемента массива для записи
	mov rax, 0                   ; rax - счётчик символов в буфере для перевода строк в числа
while:
	cmp byte [rsp + rcx], 32     ; сравниваем символ в строке с пробелом
	jne not_space                ; если не пробел, прыгаем на not_space
	jmp end_of_number            ; иначе прыгаем на end_of_number
not_space:
	cmp byte [rsp + rcx], 10     ; сравниваем символ в строке с enter
	jne not_enter                ; если не enter, прыгаем на not_enter
	jmp end_of_number            ; иначе прыгаем на end_of_number
not_enter:
	; запоминаем символ в буфере
	mov bl, [rsp + rcx]
	mov [rsp + 64 + rax], bl     ; перенос символа из исходной строки в буфер для перевода
	inc rax                      ; увеличиваем счётчик
	jmp continue                 ; прыгаем на continue
end_of_number:
	mov bl, 10
	mov [rsp + 64 + rax], bl     ; добавляем символ \n в буфер для перевода
	lea rsi, [rsp + 64]          ; помещаем в rsi адрес буфера для перевода
	mov rbx, 0                   ; чтобы StrToInt нормально работал
	push rcx                     ; помещаем rcx в стек, потому что регистров не хватает, создатели ассемблера не подумали
	mov rcx, [rsp + 78]          ; помещаем в rcx индекс элемента массива для записи
	str_to_int [matrix + rcx * 4]  ; преобразуем буфер в число и записываем в матрицу
	inc word [rsp + 78]          ; переходим к следующему элементу матрицы
	pop rcx                      ; вытаскиваем rcx из стека, потому что регистров не хватало и т.п....
	mov rax, 0                   ; обнуляем счётчик символов в буфере для перевода
	cmp byte [rsp + rcx], 10     ; сравниваем символ в строке с enter
	je break_while               ; если enter, то выходим из цикла
continue:
	inc rcx                      ; переходим к следующему символу в строке
	jmp while                    ; переходим к следующей итерации цикла
break_while:
	
	add rsp, 80                  ; вернем стек к изначальному состоянию
	pop rcx                      ; вытащим rcx из стека
	inc rcx                      ; увеличиваем счётчик строк на 1
	cmp rcx, 4                   ; если строка < 4 по счету, то переходим к следующей итерации
	jl cycle_read_matrix
	
	; =Производим вычисления=
	
	mov dword [i], 0 ; [i] - индекс начала столбца

cols:
	mov ecx, [i] ; ecx - индекс ячейки
	mov eax, 0 ; rax - текущая сумма

rows:
	add eax, dword [matrix + ecx] ; добавляем к текущей сумме содержимое ячейки
	add ecx, 24 ; переходим на следующую строку
	cmp ecx, 96 ; сравниваем, с 24
	jl rows
	
	mov [x], eax
	mov rbx, 0
	int_to_str [x], OutBuf
	mov rbx, rax
	write_string OutBuf, rbx
	
	mov edx, [i]
	add edx, 4
	mov [i], edx
	cmp edx, 24
	jl cols
	
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
