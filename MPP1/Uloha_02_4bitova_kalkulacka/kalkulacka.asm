	list	p=PIC16F873A
	;__config 0b 0010 1111 0000 1011
	__config 0x2F0B
	#include "p16f873a.inc"
;----------------------------------------------------
p1	equ	0x20

	org	0
	goto	Start
;   
	org	0x04
	retfie
Start:
        clrf	p1
        banksel	trisc
	bcf	trisc,4
	bcf	trisc,5
	bcf	trisc,6
	bcf	trisc,7 
Main:
	banksel	portc
	clrf	w
	bsf	portc,7		;ledka je vypnuta pri 1 
	bsf	portc,6
	bsf	portc,5
	bsf	portc,4
	
	movf	portc
	goto	Zobrazeni
	movwf	p1
;  
        banksel portb
        ; tady to neco udela kdyz se zmackne tlacitko
	btfss	portb,0
		goto Druhe_cislo
	goto Main    
            
Druhe_cislo:
	banksel portc
	clrf	w
	bsf	portc,7     ;ledka je vypnuta pri 1 
	bsf	portc,6
	bsf	portc,5
	bsf	portc,4
	
	movf	portc
	goto	Zobrazeni
	
	banksel portb
        ; tady to neco udela kdyz se zmackne tlacitko
	btfss	portb,0
		goto Soucet
	goto Druhe_cislo
	
Soucet:
	banksel portc
	addwf	p1
	bsf	portc,7     ;ledka je vypnuta pri 1 
	bsf	portc,6
	bsf	portc,5
	bsf	portc,4
	goto	Zobrazeni
	
Cekani:
	banksel portb
        ; tady to neco udela kdyz se zmackne tlacitko
	btfss	portb,0
		goto Main
	goto Cekani
	
; =================================================================

Zobrazeni: 
	btfsc	w,0
		bcf	portc,7	
	btfsc	w,1
		bcf	portc,6
	btfsc	w,2
		bcf	portc,5
	btfsc	w,3
		bcf	portc,4
	return
	
	