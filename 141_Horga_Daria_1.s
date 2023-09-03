.data
matrice: .space 40000
m1: .space 4
m2: .space 4
mres: .space 4
formatScanf: .asciz "%d"
formatPrintf: .asciz "%d"
linienoua: .asciz "\n"
cerinta: .space 4
N: .space 4
i: .space 4
j: .space 4
nrlegaturi: .space 400
e: .space 4
k: .space 4
sursa: .space 4
destinatia: .space 4

.text

matrix_mult:
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi
    movl 20(%ebp), %eax 
    subl $20,%esp
    movl $0,%ecx
    movl %ecx,-4(%ebp)  
    movl %eax,-8(%ebp)	
    movl $0, -16(%ebp)  

linie_loop:
    movl -4(%ebp),%ecx
    movl -8(%ebp),%eax
    cmp %ecx, %eax 
    je end_matrix_mult 
    movl $0,-16(%ebp)
   
coloana_loop:
    movl $0,-20(%ebp) 
    movl $0, -12(%ebp) 
    
k_loop:
    movl -20(%ebp), %edx
    cmp %edx, -8(%ebp)
    je coloana_loop_incr
    movl 8(%ebp), %esi  
    movl 12(%ebp), %edi
    
    movl -8(%ebp), %eax	
    movl $0,%edx		
    mull -4(%ebp)
    add -20(%ebp), %eax 
    movl (%esi, %eax, 4), %ecx
    
    
    movl -20(%ebp), %eax
    movl $0,%edx		
    mull -8(%ebp)
    add -16(%ebp), %eax
    movl (%edi, %eax, 4), %edx
    
    
    movl %edx, %eax	
    movl $0, %edx	
    mull %ecx
    add %eax,-12(%ebp)  
    addl $1 ,-20(%ebp)
    jmp k_loop

coloana_loop_incr:
    movl -8(%ebp), %eax
    movl $0,%edx
    mull -4(%ebp)
    addl -16(%ebp),%eax
    movl 16(%ebp), %esi
    movl -12(%ebp), %edx
    movl %edx ,(%esi, %eax, 4)    
    
    addl $1,-16(%ebp)
    movl -16(%ebp), %edx		
    cmp %edx, -8(%ebp)
    je linie_loop_incr
    jmp coloana_loop
    
linie_loop_incr:
    incl -4(%ebp)
    movl $0,-16(%ebp)
    jmp linie_loop
    
end_matrix_mult:
    addl $20, %esp
    popl %ebp
    popl %ebx
    popl %esi
    popl %edi
    ret
    
.global main

main:

    pushl $cerinta
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    pushl $N
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx


    movl $0, i

initializarematrice:
    movl i, %ecx
    cmp %ecx, N
    je citirenrlegaturi

    movl $0, j

init_matrice_loop:
    movl j, %ecx
    cmp %ecx, N
    je init_matrice_incr

    movl i, %eax
    mull N
    addl j, %eax
    lea matrice, %esi
    movl $0, (%esi,%eax,4)
    incl j
    jmp init_matrice_loop

init_matrice_incr:
    incl i
    jmp initializarematrice

citirenrlegaturi:
    movl $0, i
    movl N, %ebx
    lea nrlegaturi, %edi

citirenrleg:
    movl i, %edx
    cmp %edx, %ebx
    je citirelegaturi

    pushl $e
    pushl $formatScanf
    call scanf
    addl $8, %esp
   
    movl i,%edx
    movl e, %ecx
    movl %ecx, (%edi,%edx,4)
    
    incl i
    jmp citirenrleg

citirelegaturi:
    movl $0, i

citire:
    movl i, %edx
    movl $0, j
    movl N, %eax
    cmp %edx, %eax
    je citire_lungimedrum

    lea nrlegaturi, %edi
    movl (%edi, %edx, 4), %ebx

matt:
    movl j, %eax
    cmp %ebx, %eax
    je citire_incr
    pushl $e
    pushl $formatScanf
    call scanf
    addl $8, %esp
    movl e,%ecx
    
    movl i, %edx
    movl %edx, %eax
    movl $0,%edx
    mull N
    addl %ecx, %eax
    lea matrice, %esi
    movl $1, (%esi,%eax,4)
   
    incl j
    jmp matt

citire_incr:
    incl i
    jmp citire

   
citire_lungimedrum:
    pushl $k
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx
    
    pushl $sursa
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx
    
    pushl $destinatia
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx
    
   lea matrice,%esi
   movl %esi,m1
   lea matrice,%esi
   movl %esi,m2
   
 
 o:  
   movl $192,%eax    
    //mmap instruction code
   movl $0,%ebx 
    //address -- nu vreau sa imi aloce o adresa specifica    
   movl $40000,%ecx  
   //size
   movl $3,%edx   
    // protection -- PROT_WRITE | PROT_ WRITE
   movl $34,%esi    
   // flags -- MAP_PRIVATE | MAP_ANONYMOUS
   movl $0,%edi  
      // file descriptor ( este folosit doar cand vreau sa mappez un fisier)
   movl $0,%ebp      
   // offset (nu folosim fisier) 
   int $0x80
   movl %eax, mres
   movl $1,%eax
   
inmultire_:
   movl k,%ebx
   cmp %eax,%ebx
   je afisare_rezultat
   cmp $2,%eax
   jge mutare
   
procedura:
   pushl %eax
   pushl N
   pushl mres
   pushl m2
   pushl m1
   call matrix_mult
   popl %ebx
   popl %ebx
   popl %ebx
   popl %ebx
   popl %eax
   incl %eax
   jmp inmultire_
   
mutare:
     lea mres,%esi
     movl %esi,m2
     jmp procedura
    
afisare_rezultat:
 
    movl sursa,%eax
    movl destinatia,%ecx
    movl $0,%edx
    movl N,%ebx
    mull %ebx
    addl %ecx,%eax
    movl mres,%edi
    
    pushl (%edi,%eax,4)
    pushl $formatPrintf
    call printf
    addl $8, %esp
    
    push $0
    call fflush
    popl %ebx
    
exit:

    movl $91,%eax 
    // munmap instruction code
    movl mres,%ebx
    // adress
    movl $40000,%ecx 
    // size
    int $0x80
    
    movl $1, %eax
    xorl %ebx,%ebx
    int $0x80
