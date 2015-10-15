
SECTION code_l

PUBLIC l_command_line_parse

EXTERN l_minu_bc_hl, asm_isspace, l_jpix

l_command_line_parse:
   
   ; * parse command line into words
   ; * copy words to stack
   ; * create argc, argv on the stack
   ; * return pointer to redirector string if '>' or '<' found
   ; * command line length capped at 128 chars
   ;
   ; enter : de = & command line
   ;         bc = number of chars in command line
   ;
   ; exit  : stack = int argc, char *argv[]
   ;         hl'   = & redirector in command line (0 if none)
   ;         bc'   = num chars remaining in redirector (0 if none)
   ;
   ; uses  : af, bc, de, hl, bc', hl', ix

   pop ix                      ; ix = return address

   ld hl,128
   call l_minu_bc_hl
   
   ld c,l
   ld b,h                      ; bc = min(128,command_line_len)

   ; initialize redirector pointers
   
   xor a
   
   exx
   
   ld l,a
   ld h,a                      ; hl'= & redirector in command line
   ld c,a
   ld b,a                      ; bc'= chars remaining in command line
   
   push hl                     ; command line on stack is zero terminated
   
   exx

   ex de,hl

   ; find end of command line
   
   ; hl = & command line
   ; bc = num chars remaining in command line <= 128
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; ix = return address

   ld e,b
   
   ld a,c
   or a
   jr z, generate_argv         ; if there is no command line

find_end:

   ld a,(hl)
   
   cp '>'
   jr z, redirector
   
   cp '<'
   jr nz, find_cont

redirector:

   push bc
   push hl
   
   exx
   
   pop hl                      ; hl'= & redirector
   pop bc                      ; bc'= num chars remaining in redirector
   
   exx
   
   jr found_end

find_cont:

   inc e
   
   cpi                         ; hl++, bc--
   jp pe, find_end

found_end:

   dec hl
   ld c,e
   
   ; hl = & last char in command line
   ; bc = number of chars in command line <= 128
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; ix = return address

   ; working command line backwards copy words to stack

   ld e,b                      ; e = word_count = 0

skip_trailing_ws:

   ld a,(hl)
   call asm_isspace
   jr c, copy_word             ; not space, end of word found
   
word_loop:

   cpd                         ; hl--, bc--
   jp pe, skip_trailing_ws
   
   jr generate_argv            ; if reached beginning of command line

copy_word:

   inc e                       ; word_count++
   
   ld d,e
   ld e,a                      ; e = char
   ld a,d                      ; a = word_count
   ld d,b                      ; d = '\0'
   
   push de                     ; zero terminate and push last char of word
   ld e,a                      ; e = word_count
   
copy_word_loop:

   cpd                         ; hl--, bc--
   jp po, generate_argv        ; if reached beginning of command line

   ld a,(hl)
   call asm_isspace
   jr nc, word_loop            ; if next char is space, word ends
   
   push af
   inc sp                      ; copy char to stack
   
   jr copy_word_loop

generate_argv:

   ld c,e

   ; bc = argc = word count
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; ix = return address

   ld l,b
   ld h,b                      ; hl = 0
   
   ld a,c
   or a
   jr z, push_argc_argv        ; if argc == 0
   
   add hl,sp

   ld e,l
   ld d,h                      ; de = & first word
   
   sbc hl,bc
   sbc hl,bc                   ; hl = char **argv
   
   ld sp,hl                    ; make space for char **argv
   
push_argc_argv:

   IF __SDCC | __SDCC_IX | __SDCC_IY
   
      push hl                  ; char *argv[]
      push bc                  ; int argc
   
   ELSE
   
      push bc                  ; int argc
      push hl                  ; char *argv[]
   
   ENDIF
   
   jp z, l_jpix                ; return if argc == 0

   ; fill in char *argv[]

   ; bc = argc
   ; hl = char *argv[]
   ; de = & first_word
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; ix = return address

store_argv:

   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   dec c
   jp z, l_jpix                ; return if no more words
   
next_word_loop:

   ld a,(de)
   inc de
   
   or a
   jr nz, next_word_loop
   
   jr store_argv