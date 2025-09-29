	list    p=PIC16F877A
	__config 0x2F09
	#include "p16f877a.inc"
;---------------------------------
work	equ	0x20	; zaloha pracovniho registru
stat	equ	0x21	; zaloha status
	
i	equ	0x22	; kolik preruseni probehlo
on	equ	0x23	; jak dlouho ma dioda svitit
off	equ	0x26	; jak dlouho ma byt zhasnuta
celkem	equ	0x25	; kolik cyklu ma probehnout
led	equ	0x24	; ma dioda svitit?

	org	0
	goto	Start
   
	org	0x04
	movwf	work
	swapf	status,w
	clrf	status
	movwf	stat
	
	bcf	intcon,tmr0if
	movlw	0xCC
	movwf	tmr0
	
	incf	i,f
	movf	celkem, w
	subwf	i, w		; i-celkem
	btfsc	status,z	; z=1 <=> i=celkem
		goto Zmena	

Pokracovani:	
	movf	on, w
	subwf	i, w		; i-on
	btfsc	status,z	; z=1 <=> i=on
		goto Zhasni
	banksel portc
	bsf	portc,2
	goto Konec
	
Zmena:
	clrf	i
	bcf	led,0
	decfsz	on,f
		goto Konec
	movlw	d'49'
	movwf	on
	
	goto Konec
	
Zhasni:
	bsf led,0
	banksel portc
	bcf	portc,2



Konec:
	swapf	stat, w
	movwf	status
	swapf	work, f
	swapf	work, w
	retfie
Start:
	banksel option_reg
	
	bsf	intcon, 5	; TMR0IE
	bcf	option_reg, 3	; prescaler pripojen k TMR0

	bcf	option_reg, 2	; nasledujci 3 instrukce nastavi hodnotu prescaleru
	bcf	option_reg, 1
	bsf	option_reg, 0
	
	bcf	option_reg, 5
	
	banksel tmr0
	movlw	0xCC
	movwf	tmr0
	
	
	banksel trisc
	bcf	trisc, 1	; nastaveni bargrafu na vystup	
	clrf	trisd
	bcf	trisc,2		
	banksel	portc		
	bcf	portc, 1	; logicka 0 aktivuje bargraf
	movlw	0xff		; same 1 v portd = vypnu diody v bargrafu	
	movwf	portd
	clrf	i		; kolik cyklu probehlo
	movlw	d'49'
	movwf	on		; jak dlouho ma dioda svitit
	movlw	0x01
	movwf	off		; jak dlouho ma byt zhasnuta
	movlw	d'50'
	movwf	celkem		; kolik cyklu ma probehnout
	
	bsf intcon,gie
	
Main:
	btfsc	led,0	;	
		goto Sviti
Nesviti: 
	banksel portd
	movlw	0xff		; same 1 v portd = vypnu diody v bargrafu	
	movwf	portd
	goto Main

Sviti: 
	banksel	portd
	clrf	portd		;rozsvitim bargraf	
	goto Main

	
	
	end	
	
	

	
	
	

	


	

