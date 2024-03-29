<style>
    img {
        background-color: white;
        padding: 10px;
        border-radius: 20px;
        transition: all 0.5s;
    }
    img:hover {
        border-radius: 10px;
        transition: all 0.5s;
    }
</style>

# Лабораторная работа №2

## Выполнил Гурьянов Евгений

---

$$\text{Вариант 2.7}$$

# Задача

**Цель работы:**  
изучение форматов машинных команд, команд целочисленной арифметики ассемблера и программирование целочисленных вычислений.


**Задача:**  
Вычислить целочисленное выражение:

$$ s = \frac{a * b}{2} - k + \frac{a}{3} - b $$

# Основная часть

## Исходный код программы:

```asm
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
	mov ax, [%1]                 ; получение числа из памяти
	cwde
	call IntToStr64              ; вызов процедуры
	cmp rbx, 0                   ; сравнение кода возврата
	jne StrToInt64.Error         ; обработка ошибки
	%endmacro
	
	section .data                ; сегмент инициализированных переменных
	
	InputPrompt db "Enter integer values", 10
	lenInputPrompt equ $ - InputPrompt
	
	InputPromptA db "a: "
	lenInputPromptA equ $ - InputPromptA
	
	InputPromptB db "b: "
	lenInputPromptB equ $ - InputPromptB
	
	InputPromptK db "k: "
	lenInputPromptK equ $ - InputPromptK

	ResultMsg db "Result: s = "
	lenResult equ $ - ResultMsg
	
	ExitMsg db "Press Enter to Exit", 10 ; выводимое сообщение
	lenExit equ $ - ExitMsg
	
	section .bss                 ;сегмент неинициализированных переменных
	
	InBuf resb 10                ; буфер для вводимой строки
	lenIn equ $ - InBuf

	OutBuf resb 10                ; буфер для вводимой строки

	a resw 1
	b resw 1
	k resw 1
	result resw 1
	
	section .text                ; сегмент кода
	
	global _start
_start:

	; =Вводим данные=
	write_string InputPrompt, lenInputPrompt ; выводит приглашение

	write_string InputPromptA, lenInputPromptA ; выводит a =
	read_string InBuf, lenIn
	str_to_int a

	write_string InputPromptB, lenInputPromptB ; выводит b =
	read_string InBuf, lenIn
	str_to_int b

	write_string InputPromptK, lenInputPromptK ; выводит k =
	read_string InBuf, lenIn
	str_to_int k

	; =Производим вычисления=
	mov ax, [a]
	imul word [b]
	sar ax, 1
	mov bx, ax
	mov ax, [a]
	mov cx, 3
	idiv cx
	add ax, bx
	sub ax, [k]
	sub ax, [b]
	mov [result], ax

	; =Выводим результат=
	write_string ResultMsg, lenResult
	mov rbx, 0
	int_to_str result, OutBuf
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

```

## Пример работы программы

![](imgs/2.png)

## Проверка результатов работы программы

### Скрипт для проверки
```js
function s(a, b, k) {
    return Math.floor(a * b / 2) - k + Math.floor(a / 3 |0) - b 
} 
```

| a  | b | k  | Ожидание | Реальность |
|----|---|----|----------|------------|
| 1  | 2 | 3  | -4       | -4         |
| 0  | 0 | 0  | 0        | 0          |
| 1  | 1 | 1  | -2       | -2         |
| -3 | 5 | 4  | -18      | -18        |
| -1 | 2 | -1 | -2       | -2         |


**Вывод:**  

В результате выполнения лабораторной работы была разработана программа, осуществляющая вычисление целочисленого выражения
