    list    p=PIC16F873A
    ;__config 0b 0010 1111 0000 1011
    __config 0x2F0B
    #include "p16f873a.inc"
    ;---------------------------------
p1  equ 0x20

    org	    0
    goto    Start
;   
    org	    0x04
    retfie
Start:
        clrf p1
        banksel trisc
        bcf trisc,4
        bcf trisc,5
        bcf trisc,6
        bcf trisc,7
        banksel portc
 
Main: 
        movf portc,w
        movwf p1
        bsf portc,7     ;ledka je vypnuta pri 1 
        bsf portc,6
        bsf portc,5
        bsf portc,4
        btfss p1,0
           bcf portc,7
        btfss p1,1
           bcf portc,6 
        btfss p1,2
           bcf portc,5 
        btfss p1,3
           bcf portc,4 
;  
        banksel portb
        ; tady to neco udela kdyz se zmackne tlacitko
        btfss portb,0
            goto Tlacitko
        goto Main    
            
Tlacitko:            
        bcf portc,7
        bcf portc,6
        bcf portc,5
        bcf portc,4
        goto Main 
        
        
        
       
    
    
    
    
    
    
    end
