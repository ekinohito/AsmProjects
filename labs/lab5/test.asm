global _Z16add_char_wrapperc
extern _Z8add_charc

    section .data           ; сегмент инициализированных переменных
    section .bss            ; сегмент неинициализированных переменных
    section .text
    _Z16add_char_wrapperc:
        ; пролог
        push rbp            ; сохраняем содержимое rbp в стек
        mov rbp, rsp        ; смещаем базу стека

        sub rsp, 8          ; по конвенции стек должен быть выровнен по 16 байт
        push rdi            ; помещаем адрес начала текста в стек

        call _Z8add_charc  ; вызываем процедуру

        ; эпилог
        mov rsp, rbp        ; очищаем локальные переменные
        pop rbp             ; восстанавливаем базу стека
        ret