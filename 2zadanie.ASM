format PE console
include 'win32ax.inc'

; ������� 2:
; ��������� ��� ����� � ����������.
; ������� ���� �� �����, ������� ��� ����� �� �� ��������� ��������.

.data
    file_size DD 0                          ; ������ �����
    buffer_length DD 0                      ; ����� ��� ����� �����
    user_input DD 0                         ; ���������� ��� ����������������� �����
    temp_input DD 0                         ; ��������� ���������� �����
    file_char DB ' ', 0                     ; ����� ��� ������� �� �����
    file_handle DD ?                        ; ���������� �����
    file_name DB ' ', 0                     ; ����� ��� ����� �����
    greeting_msg db ' ', 0                  ; ������ �����������
    error_msg db 'Error with the file.', 0  ; ��������� �� ������
    temp_msg db ' ', 0                      ; ������ ������ ��� �������

    num_0 db ' ���� ', 0                    ; ��������� �������� ����� 0
    num_1 db ' ���� ', 0
    num_2 db ' ��� ', 0
    num_3 db ' ��� ', 0
    num_4 db ' ������ ', 0
    num_5 db ' ���� ', 0
    num_6 db ' ����� ', 0
    num_7 db ' ���� ', 0
    num_8 db ' ������ ', 0
    num_9 db ' ������ ', 0

.code    
start:

    ; ��������� ����� ����� � ����������
    push STD_INPUT_HANDLE
    call [GetStdHandle]
    push 0
    push buffer_length
    push 256
    push file_name
    push eax
    call [ReadConsole]

    ; �������� �������� �������� ������
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
    ; �������� �����
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

    ; ��������� ������� �����
    push 0 
    push [file_handle] 
    call [GetFileSize] 
    mov [file_size], eax 
    xor ecx, ecx 
    push ecx

    ; ��������, ���� �� ����
    cmp [file_size], 0
    jne readstring
    ; ���� ����, ������� ��������� � ���������
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
    ; ������ � ��������� ����� ���������
    push NULL 
    push buffer_length 
    push 1 
    push file_char 
    push [file_handle] 
    call [ReadFile]
    test eax, eax
    jz close_file

    ; ��������� ��������
    mov al, [file_char]
    cmp al, '0'
    jb write_char
    cmp al, '9'
    jbe change
    jmp write_char

change:
    ; ������ ���� �� ��������� ��������
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
    ; ����� ��������� ��������
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
    ; ���������� ������
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
    ; ��������� ������ �������� �����
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

