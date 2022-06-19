```bnf
<statement> ::= <assignment> | <while> // выражение

<assignment> ::= <var> "=" <expression> ";" // присваивание

<expression> ::= <var> | <integer> // выражение

<integer> ::= <natural> | "-" <natural> // целое число

<natural> ::= <digit> | <digit> <natural> // натуральное число

<while> ::= "while (" <var> ")" <statement> // цикл while

<var> ::= <letter> <var_tail> // имя переменной (должно начинаться с буквы)

<var_tail> ::= "" | <alphanumeric> <var_tail> // конец имени переменной (может содержать буквы и цифры)

<alphanumeric> ::= <digit> | <letter> // буква или цифра

<digit> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" // цифра

<letter> ::= "a" | "A" | "b" | "B" | "c" | "C" | "d" | "D" | "e" | "E" | "f" | "F" | "g" | "G" | "h" | "H" | "i" | "I" | "j" | "J" | "k" | "K" | "l" | "L" | "m" | "M" | "n" | "N" | "o" | "O" | "p" | "P" | "q" | "Q" | "r" | "R" | "s" | "S" | "t" | "T" | "u" | "U" | "v" | "V" | "w" | "W" | "x" | "X" | "y" | "Y" | "z" | "Z" // буква
```