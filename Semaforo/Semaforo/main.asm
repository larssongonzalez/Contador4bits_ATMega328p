//******************************************************************
// Universidad del Valle de Guatemala
// IE2023: Programación de micrcontroladores
// Semaforo.asm
// Autor : Larsson González
// Proyecto: Ejemplos
// Hardware: ATMega328P 
// Creado: 30/1/2024 08:57:57
// Última modificación: 
//******************************************************************
// CONFIGURACION GENERAL
//******************************************************************
.include "M328PDEF.inc"
.CSEG
.ORG 0x0000

//******************************************************************
// STACK POINTER
//******************************************************************
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R17, HIGH(RAMEND)
OUT SPH, R16

//******************************************************************
// DEFINICION DE REGISTROS Y CONSTANTES
//******************************************************************
;Definicion de constantes para el antirebote
.equ TIEMPO_REBOTE = 200

//******************************************************************
// CONFIGURACION DE PUERTOS DE I/O
//******************************************************************
	;Salida en PB0, PB1, PB2, PB3
	LDI R16, 0b00001111
	OUT DDRB, R16	;Configura Puerto B como Salida

	;Salida en PC0, PC1, PC2, PC3
	LDI R17, 0b00001111
	OUT DDRC, R17	;Configura Puerto C como Salida

	;Entrada en PD2, PD3, PD4, PD5
	LDI R16, 0b00111100
	OUT PORTD, R16	;Configura Puerto D0 como Entrada
	CBI DDRD, 0b00000000


//******************************************************************
// PROGRAMA PRINCIPAL
//******************************************************************
INICIO:
	;Lee el estado de los botones del puerto D
	IN R16, PIND	;Obtiene los valores logicos aplicado al puerto D

	;Verifica si el boton de incremento esta presionado PD2
	SBRS R16, PD2	;Salta si el bit de PD0 esta en 1 
	CALL ANTI_REBOTE_INCREMENTO

	;Verifica si el boton de decremento esta presionado PD3
	SBRS R16, PD3
	CALL ANTI_REBOTE_DECREMENTO
	
	;Verifica si el boton de incremento esta presionado PD4
	SBRS R16, PD4
	CALL ANTI_REBOTE_INCREMENTO2

	;Verifica si el boton de decremento esta presionado PD5
	SBRS R16, PD5
	CALL ANTI_REBOTE_DECREMENTO2

	RJMP INICIO	

//******************************************************************
// SUB RUTINAS
//******************************************************************
ANTI_REBOTE_INCREMENTO:
	LDI R17, TIEMPO_REBOTE
	
DELAY_INCREMENTO:
	DEC R17
	BRNE DELAY_INCREMENTO

	;Verifica nuevamente el estado del boton
	IN R16, PIND
	SBRS R16, PD2
	RJMP ANTI_REBOTE_INCREMENTO
	CALL INCREMENTAR_CONTADOR

	RET

INCREMENTAR_CONTADOR:
	LDI R17, 200

	;Incrementa el contador
	INC R18

	;Enciende el LED correspondiente al valor del contador 
	OUT PORTB, R18

ANTI_REBOTE_DECREMENTO:
	LDI R17, TIEMPO_REBOTE

DELAY_DECREMENTO:
	DEC R17
	BRNE DELAY_DECREMENTO

	;Verifica nuevamente el estado del boton
	IN R16, PIND
	SBRS R16, PD3
	RJMP ANTI_REBOTE_DECREMENTO
	CALL DECREMENTAR_CONTADOR

	RET

DECREMENTAR_CONTADOR:
	LDI R17, 100

	;Decrementa el contador
	DEC R19

	;Enciende el LED correspondiente al valor del contador
	OUT PORTB, R19

	RET
	
ANTI_REBOTE_INCREMENTO2:
	LDI R17, TIEMPO_REBOTE
	
DELAY_INCREMENTO2:
	DEC R17
	BRNE DELAY_INCREMENTO2

	;Verifica nuevamente el estado del boton
	IN R16, PIND
	SBRS R16, PD4
	RJMP ANTI_REBOTE_INCREMENTO2
	CALL INCREMENTAR_CONTADOR2

	RET

INCREMENTAR_CONTADOR2:
	LDI R17, 200

	;Incrementa el contador
	INC R20

	;Enciende el LED correspondiente al valor del contador 
	OUT PORTC, R20

ANTI_REBOTE_DECREMENTO2:
	LDI R17, TIEMPO_REBOTE

DELAY_DECREMENTO2:
	DEC R17
	BRNE DELAY_DECREMENTO2

	;Verifica nuevamente el estado del boton
	IN R16, PIND
	SBRS R16, PD5
	RJMP ANTI_REBOTE_DECREMENTO
	CALL DECREMENTAR_CONTADOR

	RET

DECREMENTAR_CONTADOR2:
	LDI R17, 100

	;Decrementa el contador
	DEC R21

	;Enciende el LED correspondiente al valor del contador
	OUT PORTC, R21

	RET