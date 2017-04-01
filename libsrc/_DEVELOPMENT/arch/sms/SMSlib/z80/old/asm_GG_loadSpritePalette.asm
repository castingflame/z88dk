; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_GG_loadSpritePalette

include "../SMSlib_private.inc"

asm_GG_loadSpritePalette:

   ; void GG_loadSpritePalette (void *palette)
   ;
   ; enter : hl = void *palette
   ;
   ; uses  : af, bc, hl
   
   di 
   
   ld a,#(SMS_CRAMAddress+0x20)&0xff
   out (VDPControlPort),a
   
   ld a,#(SMS_CRAMAddress+0x20)/256
   out (VDPControlPort),a
   
   ei
   
   ld bc,0x2000 + VDPControlPort

loop:

   outi
   jr nz, loop
   
   ret
