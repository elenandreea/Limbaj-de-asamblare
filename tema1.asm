%include "io.inc"

section .data
    %include "input.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    xor ecx,ecx
    mov ecx,0
   
code:
    xor eax,eax
    xor edx,edx
    cmp [nums],ecx      ;testeaza daca contorul a atins nr max de elemente
    jz print5
     
    NEWLINE
    mov eax, dword [nums_array + 4*ecx ]
    mov ebx, dword [base_array + 4*ecx ]
    
    cmp ebx,2           ;verificam daca baza se incadreaza intre 2 si 16
    jl eticheta1
    cmp ebx,16
    jle eticheta2
    
eticheta1:
    PRINT_STRING "Baza incorecta"
    jmp print4
    
eticheta2: 
    div ebx             ;in caz favorabil se executa impartirea
    push ecx            ;se pune pe stiva nr elementului curent
    xor ecx,ecx         
    inc ecx             ;se numara in ecx nr de pushuri
    push edx
    
divide:   
    cmp eax,0           ;se efectueaza impartiri pana cand restul stocat in eax devine 0
    je print1
    xor edx,edx
    div ebx
    push edx
    inc ecx
    jmp divide
  
print1:
    cmp ecx,0           ;cat timp ecx nu a ajuns la 0 se efectueaza popuri
    je print3
    pop edx
    cmp edx,10          
    jnl print2
    add edx,48          ;se transforma cifra in caracter
    PRINT_CHAR edx
    
print1.1:
    dec ecx
    jmp print1
    
print2:
    add edx,87          ;se transforma litera in caracter
    PRINT_CHAR edx
    jmp print1.1 
        
print3:
    pop ecx             ;se repune in ecx contorul 
        
print4:
    inc ecx             ;se incrementeaza contorul si se intoarce in cod
    jmp code
    
print5:
    xor eax, eax
    ret