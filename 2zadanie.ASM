format PE console
include 'win32ax.inc'

; Задание 2:
; Запросить имя файла с клавиатуры.
; Вывести файл на экран, заменяя все цифры на их буквенные значения.

.data
    file_size DD 0                          ; Размер файла
    buffer_length DD 0                      ; Буфер для длины ввода
    user_input DD 0                         ; Переменная для пользовательского ввода
    temp_input DD 0                         ; Временная переменная ввода
    file_char DB ' ', 0                     ; Буфер для символа из файла
    file_handle DD ?                        ; Дескриптор файла
    file_name DB ' ', 0                     ; Буфер для имени файла
    greeting_msg db ' ', 0                  ; Строка приветствия
    error_msg db 'Error with the file.', 0  ; Сообщение об ошибке
    temp_msg db ' ', 0                      ; Пустая строка для консоли

    num_0 db ' ноль ', 0                    ; Буквенное значение цифры 0
    num_1 db ' один ', 0
    num_2 db ' два ', 0
    num_3 db ' три ', 0
    num_4 db ' четыре ', 0
    num_5 db ' пять ', 0
    num_6 db ' шесть ', 0
    num_7 db ' семь ', 0
    num_8 db ' восемь ', 0
    num_9 db ' девять ', 0

.code    
start:

    ; Получение имени файла с клавиатуры
    push STD_INPUT_HANDLE
    call [GetStdHandle]
    push 0
    push buffer_length
    push 256
    push file_name
    push eax
    call [ReadConsole]

    ; Удаление символов перевода строки
    mov esi, file_name
find_end:
    cmp byte [esi], 0
    je open_file
    cmp byte [esi], 13
    je zero_terminate
    cmp byte [esi], 10
    je zero_terminate
    inc esi
    jmp find_end
zero_terminate:
    mov byte [esi], 0

open_file:
    ; Открытие файла
    invoke SetConsoleOutputCP, 1251
    push NULL
    push FILE_ATTRIBUTE_NORMAL
    push OPEN_EXISTING
    push NULL
    push 0
    push GENERIC_READ
    push file_name
    call [CreateFile]

    cmp eax, INVALID_HANDLE_VALUE
    je file_error
    mov [file_handle], eax

    ; Получение размера файла
    push 0 
    push [file_handle] 
    call [GetFileSize] 
    mov [file_size], eax 
    xor ecx, ecx 
    push ecx

    ; Проверка, пуст ли файл
    cmp [file_size], 0
    jne readstring
    ; Если пуст, вывести сообщение и завершить
    push STD_OUTPUT_HANDLE
    call [GetStdHandle]
    push 0
    push buffer_length
    push 18
    push error_msg
    push eax
    call [WriteConsole]
    jmp close_file

readstring:
    ; Чтение и обработка файла построчно
    push NULL 
    push buffer_length 
    push 1 
    push file_char 
    push [file_handle] 
    call [ReadFile]
    test eax, eax
    jz close_file

    ; Обработка символов
    mov al, [file_char]
    cmp al, '0'
    jb write_char
    cmp al, '9'
    jbe change
    jmp write_char

change:
    ; Замена цифр на буквенные значения
    cmp al, '0'
    je zero
    cmp al, '1'
    je one
    cmp al, '2'
    je two
    cmp al, '3'
    je tree
    cmp al, '4'
    je four
    cmp al, '5'
    je five
    cmp al, '6'
    je six
    cmp al, '7'
    je seven
    cmp al, '8'
    je eight
    cmp al, '9'
    je nine
    jmp write_char

zero:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 6 
    push num_0 
    push eax  
    call [WriteConsole]
    jmp dont_write_char

one:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 7 
    push num_1 
    push eax
    call [WriteConsole]
    jmp dont_write_char

two:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 6 
    push num_2 
    push eax
    call [WriteConsole]
    jmp dont_write_char

tree:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 6
    push num_3 
    push eax
    call [WriteConsole]
    jmp dont_write_char

four:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 9 
    push num_4 
    push eax
    call [WriteConsole]
    jmp dont_write_char

five:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 7 
    push num_5 
    push eax
    call [WriteConsole]
    jmp dont_write_char

six:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 8 
    push num_6 
    push eax
    call [WriteConsole]
    jmp dont_write_char

seven:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 7 
    push num_7 
    push eax
    call [WriteConsole]
    jmp dont_write_char

eight:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 9 
    push num_8 
    push eax
    call [WriteConsole]
    jmp dont_write_char

nine:
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 9 
    push num_9 
    push eax
    call [WriteConsole]
    jmp dont_write_char

write_char:
    ; Вывод остальных символов
    push STD_OUTPUT_HANDLE 
    call [GetStdHandle] 
    push 0 
    push buffer_length 
    push 1 
    push file_char 
    push eax
    call [WriteConsole]

dont_write_char:
    pop ecx 
    inc ecx 
    push ecx 
    cmp ecx, [file_size] 
    jne readstring

close_file:
    ; Завершение работы
    push STD_INPUT_HANDLE
    call [GetStdHandle]
    push 0
    push user_input
    push 3
    push greeting_msg
    push eax
    call [ReadConsole]

    push [file_handle]
    call [CloseHandle]

    push 0
    call [ExitProcess]

file_error:
    ; Обработка ошибки открытия файла
    push STD_OUTPUT_HANDLE
    call [GetStdHandle]
    push 0
    push buffer_length
    push 20
    push error_msg
    push eax
    call [WriteConsole]
    jmp close_file


.end start

