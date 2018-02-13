extern puts
extern printf
extern strlen

section .data
filename: db "./input.dat",0
inputlen: dd 2263
fmtstr: db "Key: %d",0xa,0

section .text
global main

; TODO: define functions and helper functions

 xor_strings:       
         push ebp
         mov ebp,esp
         
         mov esi,[ebp+8]    ;cuvantul
         mov edi,[ebp+12]   ;cheia
         
         xor eax,eax
         xor ebx,ebx
         
   eticheta:                ;xorul se face caracter cu caracter
         mov al,byte [esi]  
         test al,al         ;cat timp nu s a ajuns la final
         je iesire 
         mov bl,byte [edi]
         test bl,bl         ;cat timp nu s a ajuns la final
         je iesire 
         
         xor al,bl          ;xor intre caracterul din mesaj si cel din cheie
         mov byte[esi],al   ;stocare
         inc esi            ;se cresc pozitiile
         inc edi
         jmp eticheta
         
   iesire:              
         leave
         ret
         
rolling_xor:
        push ebp
        mov ebp,esp
        
        mov esi,[ebp+8]     ;mesajul
        
        xor eax,eax
        xor ebx,ebx
        
        mov al,byte [esi]   ;primul caracter al mesajului
        
    eticheta2:
        inc esi
        mov bl,byte [esi]
        test bl,bl          ;cat timp nu s a ajuns la null
        je iesire2
                
        xor al,bl           ;xor intre caracterul actual si cel precedent
        mov byte[esi],al    ;stocare
        mov al, bl
        jmp eticheta2     
        
    iesire2:  
        leave
        ret

conversie:
        push ebp
        mov ebp,esp
        mov esi,[ebp+8]     ;mesajul
        
        xor eax,eax
        xor ebx,ebx
        xor edx,edx
        mov edi,0
 
   eticheta3: 
        inc edi
        mov dl, byte [esi]
        
        test dl,dl          ;cat timp nu s a ajuns la final
        je iesire3          ;transformare 
        cmp dl,'a'
        jb nr1
    caracter1:
        sub dl,'a'
        add dl,10
        jmp next1
    nr1:
        sub dl,'0'
    
    next1:   
        inc esi
        
        mov bl, byte [esi]
        
        test bl,bl          ;cat timp nu s a ajuns la final
        je iesire3
        
        cmp bl,'a'          ;transformare 
        jb nr2
    caracter2:
        sub bl,'a'
        add bl,10
        jmp next2
    nr2:
        sub bl,'0'
            
    next2:                  ;criptarea efectiva
        shl dl, 4
        add dl,bl
        mov ebx, 2
        
        sub esi, edi
        mov byte [esi], dl
        add esi,edi

        inc esi
        jmp eticheta3
       
    iesire3:
        mov byte[esi],0x00
        leave
        ret

main:
        mov ebp, esp; for correct debugging
        push ebp
        mov ebp, esp
        sub esp, 2300
    
        ; fd = open("./input.dat", O_RDONLY);
        mov eax, 5
        mov ebx, filename
        xor ecx, ecx
        xor edx, edx
        int 0x80
    
        ; read(fd, ebp-2300, inputlen);
        mov ebx, eax
        mov eax, 3
        lea ecx, [ebp-2300]
        mov edx, [inputlen]
        int 0x80

        ; close(fd);
        mov eax, 6
        int 0x80

	; all input.dat contents are now in ecx (address on stack)

	; TASK 1: Simple XOR between two byte streams

        	; TODO: compute addresses on stack for str1 and str2
	; TODO: XOR them byte by byte
        
        push ecx        ;valoare initiala a sirului
        
        push ecx        ;gasesc terminator de cuv
        call strlen
        add esp,4
        
        pop ecx         
        mov ebx,ecx     ;valoarea initiala a sirului
        
        inc eax         ;lungimea sirului
        add ecx,eax     ;mesajul
        
        push ecx
        push ebx
        
        push ecx        
        push ebx
        call xor_strings
        add esp,8
        
        call puts
        add esp,4
        
        pop ecx

	; TASK 2: Rolling XOR
	; TODO: compute address on stack for str3
	; TODO: implement and apply rolling_xor function

        push ecx        ;valoare initiala a sirului
        
        push ecx        ;gasesc terminator de cuv
        call strlen
        add esp, 4
        
        pop ecx
        
        inc eax         ;lungimea sirului
        add ecx,eax     ;mesajul
        
        push ecx
        call rolling_xor
        add esp,4

        push ecx        ;salvez adresa sirului
        
        push ecx
        call puts
        add esp,4
        
        pop ecx
        
	
	; TASK 3: XORing strings represented as hex strings
	; TODO: compute addresses on stack for strings 4 and 5
	; TODO: implement and apply xor_hex_strings

        push ecx	         ;valoare initiala a sirului
        
        push ecx	         ;gasesc terminator de cuv
        call strlen
        add esp,4
        
        pop ecx		 ;restaurezi adresa sirului
         
        inc eax		 ;lungimea sirului
        add ecx,eax	 ;mesajul
        
        push ecx	
        call conversie	 ;conversie mesaj
        add esp,4
                                
        push ecx	         ;salvez adresa sirului
        
        push ecx
        
        push ecx 
        call strlen	 ;gasesc urmatorul sir
        add esp,4
        
        pop ecx		 ;restaurez adresa sirului
        
        inc eax
        add ecx, eax	 ;cheia
                        
        push ecx
        call conversie	 ;conversie cheie
        add esp,4
        
        pop ebx		 
        
        push ecx          ;salvez sirurile
        push ebx
        
        push ecx
        push ebx
        call xor_strings  ;functia creata la taskul1
        add esp, 8
        
        call puts         ;afisare
        add esp, 4
        
        pop ecx
        pop ecx
        
	; TASK 4: decoding a base32-encoded string
	; TODO: compute address on stack for string 6
	; TODO: implement and apply base32decode
	;push addr_str6
	;call base32decode
	;add esp, 4

	; Print the fourth string
	;push addr_str6
	;call puts
	;add esp, 4

	; TASK 5: Find the single-byte key used in a XOR encoding
	; TODO: determine address on stack for string 7
	; TODO: implement and apply bruteforce_singlebyte_xor
	;push key_addr
	;push addr_str7
	;call bruteforce_singlebyte_xor
	;add esp, 8

	; Print the fifth string and the found key value
	;push addr_str7
	;call puts
	;add esp, 4

	;push keyvalue
	;push fmtstr
	;call printf
	;add esp, 8

	; TASK 6: Break substitution cipher
	; TODO: determine address on stack for string 8
	; TODO: implement break_substitution
	;push substitution_table_addr
	;push addr_str8
	;call break_substitution
	;add esp, 8

	; Print final solution (after some trial and error)
	;push addr_str8
	;call puts
	;add esp, 4

	; Print substitution table
	;push substitution_table_addr
	;call puts
	;add esp, 4

	; Phew, finally done
    xor eax, eax
    leave
    ret
