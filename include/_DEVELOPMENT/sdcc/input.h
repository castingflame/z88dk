


#ifndef _INPUT_H
#define _INPUT_H

#include <stdint.h>

/////////////////////////////////
// CROSS-PLATFORM INPUT FUNCTIONS
/////////////////////////////////

///////////
// keyboard
///////////

extern int in_inkey(void);


extern int in_key_pressed(uint16_t scancode);
extern int in_key_pressed_fastcall(uint16_t scancode) __z88dk_fastcall;
#define in_key_pressed(a) in_key_pressed_fastcall(a)


extern uint16_t in_key_scancode(int c);
extern uint16_t in_key_scancode_fastcall(int c) __z88dk_fastcall;
#define in_key_scancode(a) in_key_scancode_fastcall(a)



extern uint16_t in_pause(uint16_t dur_ms);
extern uint16_t in_pause_fastcall(uint16_t dur_ms) __z88dk_fastcall;
#define in_pause(a) in_pause_fastcall(a)


extern int in_test_key(void);


extern void in_wait_key(void);


extern void in_wait_nokey(void);



////////////
// joysticks
////////////

// user defined keys structure for simulated joystick

typedef struct udk_s
{

   uint16_t fire;      // scancode
   uint16_t right;     // scancode
   uint16_t left;      // scancode
   uint16_t down;      // scancode
   uint16_t up;        // scancode
   
} udk_t;

// masks for return values from joystick functions

#define IN_STICK_FIRE    0x80
#define IN_STICK_FIRE_1  0x80
#define IN_STICK_FIRE_2  0x40

#define IN_STICK_UP      0x01
#define IN_STICK_DOWN    0x02
#define IN_STICK_LEFT    0x04
#define IN_STICK_RIGHT   0x08

extern uint16_t in_stick_keyboard(udk_t *u);
extern uint16_t in_stick_keyboard_fastcall(udk_t *u) __z88dk_fastcall;
#define in_stick_keyboard(a) in_stick_keyboard_fastcall(a)



////////
// mouse
////////

// masks for return values from mouse functions

#define IN_MOUSE_BUTTON_LEFT    0x01
#define IN_MOUSE_BUTTON_RIGHT   0x02
#define IN_MOUSE_BUTTON_MIDDLE  0x04

#define IN_MOUSE_BUTTON_1       0x01
#define IN_MOUSE_BUTTON_2       0x02
#define IN_MOUSE_BUTTON_3       0x04

////////////////////////////////////
// PLATFORM SPECIFIC INPUT FUNCTIONS
////////////////////////////////////

#ifdef __SPECTRUM
#include <input/input_zx.h>
#endif

#endif