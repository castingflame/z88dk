;
;       Z88dk Z88 Maths Library
;
;
;       $Id: stkequcmp.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $


		XLIB	stkequcmp

.stkequcmp
        pop     de      ;return address
        pop     bc      ;dump number..
        pop     bc
        pop     bc
        push    de      ;put it back
        ld      a,h
        or      l       ;sets nc
        ret     z       
        ld      hl,1
        scf
        ret
