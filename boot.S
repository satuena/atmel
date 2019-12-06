/* **** FILE: boot.S
----------------------------------------------------------------------
This is the assembly support code.
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
	;; CODE.......................................................
	.text

	;; Interrupt service routine table.  Undefined service
	;; routines are defined, by default, to jump to the beginning
	;; of the program.
vector:	
	jmp begin		  ; reset
	.balign 4
	jmp __vector_int0	  ; int0
	.balign 4
	jmp __vector_int1	  ; int1
	.balign 4
	jmp __vector_pcint0	  ; pcint0
	.balign 4
	jmp __vector_pcint1	  ; pcint1
	.balign 4
	jmp __vector_pcint2	  ; pcint2
	.balign 4
	jmp __vector_wdt	  ; wdt
	.balign 4
	jmp __vector_timer2_compa ; timer2_compa
	.balign 4
	jmp __vector_timer2_compb ; timer2_compb
	.balign 4
	jmp __vector_timer2_ovf	  ; timer2_ovf
	.balign 4
	jmp __vector_timer1_capt  ; timer1_capt
	.balign 4
	jmp __vector_timer1_compa ; timer1_compa
	.balign 4
	jmp __vector_timer1_compb ; timer1_compb
	.balign 4
	jmp __vector_timer1_ovf	  ; timer1_ovf
	.balign 4
	jmp __vector_timer0_compa ; timer0_compa
	.balign 4
	jmp __vector_timer0_compb ; timer0_compb
	.balign 4
	jmp __vector_timer0_ovf	  ; timer0_ovf
	.balign 4
	jmp __vector_spi_stc	  ; spi_stc
	.balign 4
	jmp __vector_usart_rx	  ; usart_rx
	.balign 4
	jmp __vector_usart_udre	  ; usart_udre
	.balign 4
	jmp __vector_usart_tx	  ; usart_tx
	.balign 4
	jmp __vector_adc	  ; adc
	.balign 4
	jmp __vector_ee_ready	  ; ee_ready
	.balign 4
	jmp __vector_analog_comp  ; analog_comp
	.balign 4
	jmp __vector_twi	  ; twi
	.balign 4
	jmp __vector_spm_ready	  ; spm_ready
	.balign 4
	
	;; Beginning of the program.
begin:
	eor r1, r1		; for sake of the way GCC encodes zero.
	sei			; enable global interrupts.
	call atmega328p_init
	call cmain

	;; Make sure that we do not run off of the end of the program.
1:	
	rjmp 1b  

	;; Default interrupt vector handlers.
	.weak __vector_int0
	.weak __vector_int1
	.weak __vector_pcint0
	.weak __vector_pcint1
	.weak __vector_pcint2
	.weak __vector_wdt
	.weak __vector_timer2_compa
	.weak __vector_timer2_compb
	.weak __vector_timer2_ovf
	.weak __vector_timer1_capt
	.weak __vector_timer1_compa
	.weak __vector_timer1_compb
	.weak __vector_timer1_ovf
	.weak __vector_timer0_compa
	.weak __vector_timer0_compb
	.weak __vector_timer0_ovf
	.weak __vector_spi_stc
	.weak __vector_usart_rx
	.weak __vector_usart_udre
	.weak __vector_usart_tx
	.weak __vector_adc
	.weak __vector_ee_ready
	.weak __vector_analog_comp
	.weak __vector_twi
	.weak __vector_spm_ready

__vector_int0:	
__vector_int1:	
__vector_pcint0:	
__vector_pcint1:	
__vector_pcint2:	
__vector_wdt:	
__vector_timer2_compa:	
__vector_timer2_compb:	
__vector_timer2_ovf:	
__vector_timer1_capt:	
__vector_timer1_compa:	
__vector_timer1_compb:	
__vector_timer1_ovf:	
__vector_timer0_compa:	
__vector_timer0_compb:	
__vector_timer0_ovf:	
__vector_spi_stc:	
__vector_usart_rx:	
__vector_usart_udre:	
__vector_usart_tx:	
__vector_adc:	
__vector_ee_ready:
__vector_analog_comp:	
__vector_twi:	
__vector_spm_ready:
	sei
	reti
	

	
