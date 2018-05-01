    #312253719 shir kempinski
    
.section	.rodata
    charformat:         .string " %c"
    intformat:          .string "%d\n"
    case50print:        .string "first pstring length: %d, second pstring length: %d\n"
    case51print:        .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
    pstringdataprint:   .string "length: %d, string: %s\n"
    invalidcase:        .string "invalid option!\n"
    .align 8
    .switch:
        .quad .case_50
        .quad .case_51
        .quad .case_52
        .quad .case_53
        .quad .default
        .quad .done

.text
    .global run_func

run_func:
    pushq   %rbp                            #open new frame in stack
    movq    %rsp,%rbp

    movq    %rdi, %r8                       # compute x
    subq    $50, %r8                        # if x < 0, goto default
    cmpq    $0, %r8
    js      .default
    cmpq    $2147483647, %r8                # if x > the maximum value of signed int, it means it's negative. goto default
    jg      .default
    cmpb    $3, %r8b                        # if x > 3, goto default
    jg      .default

    pushq   %r12                            # backup colee saved registers
    pushq   %r15
    
    movq    %rsi, %r15                      # r15 holds first pstring
    movq    %rdx, %r12                      # r12 holds second pstring
    jmp     *.switch(,%r8,8)                # goto the jump table [x]
    
.case_50:
    movq    %r15, %rdi                      # r15 holds the first pstring
    movq    $0, %rax
    call    pstrlen                         # compute first pstring length
    pushq   %r13                            # backup colee saved r13
    movq    %rax, %r13                      # r13 holds first pstring length
    
    movq    %r12, %rdi                      # r12 holds second pstring
    movq    $0, %rax
    call    pstrlen                         # comupte second pstring length
    pushq   %r14                            # backup colee saved r14
    movq    %rax, %r14                      # r14 holds second pstring length
 
    movq    $case50print, %rdi              # rdi holds this case's print format
    movq    %r13, %rsi                      # r13 holds first pstring length
    movq    %r14, %rdx                      # r14 holds second pstring length
    movq    $0, %rax
    call    printf                          # print the pstrings lengths
    popq    %r14                            # restore colee saved r13 and r14
    popq    %r13    
    jmp     .done

.case_51:
    pushq   %r13                            # backup r13
    pushq   %r14                            # backup r14

    leaq    -1(%rsp), %rsp                  # make space for 1 char
    movq    %rsp, %rsi                      # rsi will get oldChar
    movq    $charformat, %rdi               # rdi holds charformat
    movq    $0, %rax   
    call    scanf
    movzbq  (%rsp), %r13                    # r13 holds oldChar

    leaq    -1(%rsp), %rsp                  # make space for 1 char
    movq    %rsp, %rsi                      # rsi will get newChar
    movq    $charformat, %rdi               # rdi holds charformat
    movq    $0, %rax   
    call    scanf
    movzbq  (%rsp), %r14                    # r14 holds newChar 

    movq    %r15, %rdi                      # r15 holds irst pstring
    movq    %r13, %rsi                      # r13 holds oldChar
    movq    %r14, %rdx                      # r14 holds newCahr
    movq    $0, %rax
    call    replaceChar                     # replace the first pstring
    leaq    1(%rax), %rax
    movq    %rax, %r15                      # r15 holds the replaced first string
    
    movq    %r12, %rdi                      # r12 holds the second pstring
    movq    %r13, %rsi                      # r13 holds oldChar
    movq    %r14, %rdx                      # r14 holds newCahr
    movq    $0, %rax
    call    replaceChar                     #replace the second pstring
    leaq    1(%rax), %rax                   
    movq    %rax, %r12                      #r12 holds the replaced second string
    
    movq    $case51print, %rdi              # rdi holds this case's print format
    movq    %r13, %rsi                      # r13 holds oldChar
    movq    %r14, %rdx                      # r14 holds newCahr
    movq    %r15, %rcx                      # r15 holds the replaced first string
    movq    %r12, %r8                       #r12 holds the replaced second string
    movq    $0, %rax
    call    printf                          # print the new strings
    popq    %r14                            # restore colee saved %r13, %r14
    popq    %r13
    jmp     .done

.case_52:
    pushq   %r13                            # backup colee saved r13
    pushq   %r14                            # backup colee savedr14 

    leaq    -4(%rsp), %rsp                  # create space for 4 bytes (int i)    
    movq    %rsp, %rsi                      # rsi holds the stack
    movq    $intformat, %rdi                # rdi holds formatint
    movq    $0, %rax
    call    scanf                           # get i
    movq    $0, %r13
    movb    (%rsp), %r13b                   # r13 holds i    

    leaq    -4(%rsp), %rsp                  # create space for 4 bytes (int j)    
    movq    %rsp, %rsi                      # rsi holds the stack
    movq    $intformat, %rdi                # rdi holds formatint
    movq    $0, %rax
    call    scanf  
    movq    $0, %r14
    movb    (%rsp), %r14b                   # r14 holds j
   
    movq    %r15, %rdi                      # rdi holds the first pstring
    movq    %r12, %rsi                      # rsi holds the second pstring
    movq    %r13, %rdx                      # rdx holds i
    movq    %r14, %rcx                      # rcx holds j
    movq    $0, %rax
    call    pstrijcpy                       # copy by i,j
    movq    %rax, %r15                      # r15 holds the changed first string
    
    movq    $pstringdataprint, %rdi         # rdi holds this case's print format
    movzbq  (%r15), %rsi                    # rsi holds the first pstring's length
    leaq    1(%r15), %rdx                   # rdx holds the first pstring' string
    movq    $0, %rax
    call    printf                          # print the first pstring data
    
    movq    $pstringdataprint, %rdi         # rdi holds this case's print format
    movzbq  (%r12), %rsi                    # rsi holds the second pstring's length
    leaq    1(%r12), %rdx                   # rdx holds the second pstring' string
    movq    $0, %rax
    call    printf                          # print the second pstring data

    popq    %r13                            # reload colee saved %r13, %r14
    popq    %r14
    jmp     .done

.case_53:
    movq    %r15, %rdi                      # rdi holds the first pstring
    movq    $0, %rax
    call    swapCase                        # swap the letters of first pstring
    movq    %rax, %r15                      # r15 holds the changed first string
    
    movq    $pstringdataprint, %rdi         # rdi holds this case's print format
    movzbq  (%r15), %rsi                    # rsi holds the first pstring's length                     
    movq    %r15, %rdx                      # rdx holds the first pstring's adress
    leaq    1(%rdx), %rdx                   # rdx holds the first string's adress
    movq    $0, %rax
    call    printf                          # print the first pstring data
    
    movq    %r12, %rdi                      # rdi holds the second pstring
    movq    $0, %rax
    call    swapCase                        # swap the letters of second pstring
    movq    %rax, %r12                      # r12 holds the chaged second string
    
    movq    $pstringdataprint, %rdi         # rdi holds this case's print format
    movzbq  (%r12), %rsi                    # rsi holds the second pstring's length
    movq    %r12, %rdx                      # rdx holds the second pstring's adress
    leaq    1(%rdx), %rdx                   # rdx holds the second string's adress
    movq    $0, %rax
    call    printf                          # print the second pstring data, and finish
    jmp     .done

.default:
    movq    $invalidcase, %rdi              # rdi holds the invalid case message format 
    movq    $0, %rax
    call    printf                          # print invalid case message
    jmp     .done

.done:
    popq    %r15                            #restore the backuped registers
    popq    %r12
    movq    $0, %rax                        # return 0
    movq    %rbp, %rsp                      # close the frame stack
    popq    %rbp
    ret

