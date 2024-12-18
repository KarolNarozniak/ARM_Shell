.section .data
prompt_msg:
    .asciz "ARM MASTER:\n"
user_input_buffer:
    .space 128                  @ Buffer for storing user input
fork_error_msg:
    .asciz "Fork failed!\n"
exec_error_msg:
    .asciz "Exec failed!\n"
argv:
    .space 64                   @ Space for argv pointers (up to 16 pointers)

.section .text
.global _start

_start:
main_loop:
    bl display_prompt           @ Display the prompt message
    bl read_user_input          @ Read user input
    bl parse_input              @ Parse user input into command and arguments
    bl fork_process             @ Fork and execute the command
    b main_loop                 @ Repeat the loop indefinitely

display_prompt:
    push {lr}
    ldr r0, =prompt_msg
    mov r1, r0
    mov r2, #12
    mov r7, #4
    mov r0, #1
    svc 0
    pop {lr}
    bx lr

read_user_input:
    push {lr}
    mov r0, #0
    ldr r1, =user_input_buffer
    mov r2, #128
    mov r7, #3
    svc 0
    ldr r1, =user_input_buffer
    add r1, r1, r0
    sub r1, r1, #1
    mov r2, #0
    strb r2, [r1]
    pop {lr}
    bx lr

parse_input:
    push {r4, r5, r6, lr}
    ldr r4, =user_input_buffer  @ r4 points to input
    ldr r5, =argv               @ r5 points to argv array
    mov r6, #0
    str r6, [r5]                @ argv[0] = NULL (clear argv)

parse_loop:
    @ Skip leading spaces
skip_spaces:
    ldrb r6, [r4]
    cmp r6, #32                 @ space?
    beq skip_one_space
    cmp r6, #0
    beq end_parse               @ end of string
    @ If not space and not 0, we have start of a token
    @ Store token start pointer
    str r4, [r5], #4
    cmp r6, #34                 @ quote?
    beq parse_quoted_string
    b parse_word

skip_one_space:
    add r4, r4, #1
    b skip_spaces

parse_word:
    @ Read until space or null terminator
    ldrb r6, [r4]
    cmp r6, #0
    beq end_token
    cmp r6, #32
    beq end_token
    add r4, r4, #1
    b parse_word

parse_quoted_string:
    @ Move past the opening quote
    add r4, r4, #1
quoted_loop:
    ldrb r6, [r4]
    cmp r6, #0
    beq end_token              @ Unexpected end of string, end token
    cmp r6, #34                @ closing quote?
    beq close_quote
    add r4, r4, #1
    b quoted_loop

close_quote:
    @ Replace closing quote with null terminator
    mov r6, #0
    strb r6, [r4]
    add r4, r4, #1             @ Move past the null terminator
    b parse_loop

end_token:
    @ We hit a space or null, place null terminator here if not placed
    ldrb r6, [r4]
    cmp r6, #0
    beq token_already_ended
    @ If space, replace it with null terminator
    mov r6, #0
    strb r6, [r4]

token_already_ended:
    add r4, r4, #1             @ Move past the terminator
    b parse_loop

end_parse:
    mov r6, #0
    str r6, [r5]               @ NULL terminate argv array
    pop {r4, r5, r6, lr}
    bx lr

fork_process:
    push {lr}
    mov r7, #2
    svc 0
    cmp r0, #0
    beq child_process
    bmi fork_error

    mov r7, #7
    mov r0, #-1
    mov r1, #0
    mov r2, #0
    svc 0
    pop {lr}
    bx lr

child_process:
    ldr r0, =user_input_buffer
    ldr r1, =argv
    mov r2, #0
    mov r7, #11
    svc 0

    ldr r0, =exec_error_msg
    mov r1, r0
    mov r2, #12
    mov r7, #4
    mov r0, #1
    svc 0
    mov r7, #1
    mov r0, #1
    svc 0

fork_error:
    ldr r0, =fork_error_msg
    mov r1, r0
    mov r2, #12
    mov r7, #4
    mov r0, #1
    svc 0
    mov r7, #1
    mov r0, #1
    svc 0
