    #312253719 shir kempinski

.section	.rodata
    stringformat:       .string "%s\n"
    intformat:          .string "%d\n"

.text
    .globl      main
    .type       main, @function

main:
    movq    %rsp, %rbp			    # opening new frame in stack
    pushq   %rbp                            
    movq    %rsp, %rbp

    subq    $4, %rsp                        # create space for four bytes (int)
    movq    %rsp, %rsi                      # rsi holds stack
    movq    $intformat, %rdi                # rdi holds intformat
    movq    $0, %rax
    call    scanf
    movzbq  (%rsp), %r10                    # saving the 1-byte number we recieved to r10
    leaq    4(%rsp), %rsp                   # delete the 4-byte int we saved
    
    subq    %r10, %rsp                      # save enough space for coming string
    leaq    -1(%rsp), %rsp                  # and for '/0'
    movq    %rsp, %rsi                      # rsi holds the stack pointer to the coming string
    movq    $stringformat, %rdi             # rdi holds stringformat
    movq    $0, %rax   
    call    scanf
    
    leaq    -1(%rsp), %rsp                  # create space for the one-byte number
    movb    %r10b, (%rsp)                   # insert the number to the head of pstring
    movq    %rsp, %r15                      # %r15 holds the first pstring

    subq    $4, %rsp                        # create space for four bytes (int)
    movq    %rsp, %rsi                      # rsi holds stack
    movq    $intformat, %rdi                # rdi holds intformat
    movq    $0, %rax
    call    scanf
    movzbq  (%rsp), %r10                    # saving the 1-byte number we recieved to r10
    leaq    4(%rsp), %rsp                   # delete the 4-byte int we saved
    
    subq    %r10, %rsp                      # save enough space for coming string
    leaq    -1(%rsp), %rsp                  # and for '/0'
    movq    %rsp, %rsi                      # rsi holds the stack pointer to the coming string
    movq    $stringformat, %rdi             # rdi holds stringformat
    movq    $0, %rax   
    call    scanf
    
    leaq    -1(%rsp), %rsp                  # create space for the one-byte number
    movb    %r10b, (%rsp)                   # insert the number to the head of pstring
    movq    %rsp, %r12                      # r12 holds the second pstring
    
    leaq    -4(%rsp), %rsp                  # create space for 4 bytes (int)    
    movq    %rsp, %rsi                      # rsi holds the stack pointer
    movq    $intformat, %rdi                # rdi holds formatint
    movq    $0, %rax
    call    scanf                           # get the case number
    movq    $0, %r13
    movb    (%rsp), %r13b                   # r13 holds the case number
  
    movq    %r13, %rdi                      # rdi holds the case number
    movq    %r15, %rsi                      # rsi holds the first pstring
    movq    %r12, %rdx                      # r12 holds the second pstring
    movq    $0, %rax
    call    run_func                        # goto the switch function

    movq    $0, %rax                        # return 0
    movq    %rbp, %rsp                      # close the frame stack
    popq    %rbp
    ret
