/* **** FILE: main.c
----------------------------------------------------------------------
This is an atmega328p program.
----------------------------------------------------------------------
 *
 * Copyright (C) 2019 Robin Miyagi ...................................
 *
 *    web:     https://www.linuxprogramming.ca/
 *
 *    email:   r.miyagi@linuxprogramming.ca
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

void cmain (void);
__attribute__((interrupt)) void __vector_timer2_ovf   (void);
__attribute__((interrupt)) void __vector_timer2_compa (void);
__attribute__((interrupt)) void __vector_timer2_compb (void);

/*
 * System includes....................................................
 */
#include <iopin.h>

/*
 * Module variables...................................................
 */

/*
 * Module functions...................................................
 */

/*
 * Implementation.....................................................
 */
void
cmain
(void)
{
  /*
   * Set fast P.W.M. mode for 8 bit timer 2.
   */
  *((volatile unsigned char*) 0xb0) = (1 << 7) | (1 << 5) | 3;
  *((volatile unsigned char*) 0xb1) = (1 << 2);

  /*
   * Enable the interrupt flags.
   */
  *((volatile unsigned char*) 0x70) = 7;
  
  /*
   * Set compare A and compare B.
   */
  *((volatile unsigned char*) 0xb3) = 0;
  *((volatile unsigned char*) 0xb4) = 0xff;
}
__attribute__((interrupt))
void
__vector_timer2_ovf
(void)
{
  ++(*((volatile unsigned char*) 0xb3));
  --(*((volatile unsigned char*) 0xb4));
}
__attribute__((interrupt))
void
__vector_timer2_compa
(void)
{
  
}
__attribute__((interrupt))
void
__vector_timer2_compb
(void)
{
  
}
