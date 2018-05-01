    #312253719 shir kempinski

.section	.rodata
    invalidinput:    .string "invalid input!\n"

.text
    .globl      pstrlen
    .globl      replaceChar
    .globl      pstrijcpy
    .globl      swapCase
    
pstrlen:
    movzbq    (%rdi), %rax                  # take the first byte of the pstring
    ret
    
replaceChar:
    movzbq  (%rdi), %r9                     # save the string's length in r9
    movq    %rdi, %r10                      # save the pstring's adress in r10

    movq    $1, %r8                         # initialize i
    leaq    (%rdi, %r8), %r10               # promote the pstring adress to be the string adress + i
    cmpq    %r9, %r8                        # if the string is shorter than 1, get out and do nothing
    jg      .endReplaceCharLoop
    
    .replaceCharLoop:                       # start of the for loop 
        cmpb    %sil, (%r10)                # if it's not the old char, skip the change
        jne     .notOldChar
        movb    %dl, (%r10)                 # swap the old char with the new one
        .notOldChar:
        leaq    1(%r8), %r8                 # i++
        leaq    (%rdi, %r8), %r10           # promote the string adress to be the pstrint adress + i
        cmpq    %r9, %r8
        jle     .replaceCharLoop
    
    .endReplaceCharLoop:
    movq    %rdi, %rax                      # return the changed pstring 
    ret

pstrijcpy:
    pushq   %rbp                            # open new frame in stack
    movq    %rsp, %rbp
    
    # check if i is invalid
    cmpb    $0, %dl                         # check if i < 0
    jl      .invalidBounds
    cmpb    %dl, (%rdi)                     # check if i > first pstring length
    jl      .invalidBounds
    cmpb    %dl, (%rsi)                     # check if i > second pstring length
    jl      .invalidBounds
    cmpq    %rcx, %rdx                      # check if i < j
    jg      .invalidBounds

    # check if j is invalid
    cmpb    $0, %cl                         # check if j < 0
    jl      .invalidBounds
    cmpb    %cl, (%rdi)                     # check if j > first pstring length    
    jl      .invalidBounds
    cmpb    %cl, (%rsi)                     # check if j > second pstring length
    jl      .invalidBounds

    movq    %rdx, %r8                       # k = i
    leaq    1(%r8), %r8                     # adjasting i and j to start from 1 to length
    leaq    1(%rcx), %rcx                   # (instead of from 0 to length-1)
    cmpq    %rcx, %r8                       # if i = j, swap only dest[i] with src[i]
    je      .iEqualsJ
        
    .cpyLoop:                               # start of for loop
        movzbq  (%r8, %rsi), %r9            # r9 holds the src[k]
        movb    %r9b, (%r8, %rdi)           # destination pstring[k] holds src[k]
        leaq    1(%r8), %r8                 # k++
        cmpq    %rcx, %r8                   # continue while k <= j
        jle     .cpyLoop
        jmp     .finishPstrijcpy

.iEqualsJ:
    movzbq  (%r8, %rsi), %r9                # r9 holds the src[i]
    movb    %r9b, (%r8, %rdi)               # destination pstring[i] holds src[i]
    
.finishPstrijcpy:                           # finish the function
    movq    %rdi, %rax                      # rax holds the destination string 
    movq    %rbp, %rsp                      # close the frame stack
    popq    %rbp
    ret
    
.invalidBounds:
    pushq   %r15                            # backup colee saved %r15
    movq    %rdi, %r15                      # backup the destination pstring
    movq    $invalidinput, %rdi             # rdi holds the invalid message string
    movq    $0, %rax
    call    printf                          # print the invalid message
    movq    %r15, %rdi                      # restore the first given pstring
    popq    %r15                            # restore colee saved r15
    jmp     .finishPstrijcpy                # goto finish

swapCase:
# print pstring for debug

    movq    $0, %r8                         # initialize i
    cmpb    (%rdi), %r8b                    # if i > pstring's length, don't swap anything 
    jg      .endSwapLoop
    .swapLoop:                              # start the for loop
        movq    $0, %r9                     
        movb    (%r8, %rdi), %r9b           # r9 holds pstring[i]
        cmpb    $65, %r9b                   # if the number < 65, it's not a letter
        jl      .nextIterSwapLoop
        cmpb    $90, %r9b                   # if the number > 90, it might be a small letter
        jg      .smallToBig
        leaq    32(%r9), %r9                # otherwise it's big and needs to be changed to small
        movb    %r9b, (%r8, %rdi)
        jmp     .nextIterSwapLoop
        
    .smallToBig:
        cmpq    $97, %r9                    # now if the number < 97 it's not a letter
        jl      .nextIterSwapLoop           
        cmpq    $122, %r9                   # if the number > 122 it's not a letter
        jg      .nextIterSwapLoop
        leaq    -32(%r9), %r9               # otherwise it's a small letter and needs to be changed to big
        movb    %r9b, (%r8, %rdi)
        
    .nextIterSwapLoop:                      
        leaq    1(%r8), %r8                 # i++
        cmpb    (%rdi), %r8b                # continue while i <= the pstring's length
        jle     .swapLoop
    
.endSwapLoop:
    movq    %rdi, %rax                      # rax holds the pstring
    ret
