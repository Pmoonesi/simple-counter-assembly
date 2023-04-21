PIOA_PER EQU 0x400E0E00
PIOB_PER EQU 0x400E1000
PIOA_OER EQU 0x400E0E10
PIOB_OER EQU 0x400E1010
PIOB_ODR EQU 0x400E1014
PIOA_SODR EQU 0x400E0E30
PIOA_CODR EQU 0x400E0E34
PIOA_ODSR EQU 0x400E0E38
PIOA_PDSR EQU 0x400E0E3C
PIOB_PDSR EQU 0x400E103C
RTT_MR	  EQU 0x400E1430
RTT_SR	  EQU 0x400E143C
SYS_GPBR  EQU 0x400E1490
ONOFF	  EQU 0x00000040
STPRSM	  EQU 0x00000020
RST		  EQU 0x00000010
	
	AREA myCode, CODE, READONLY
	EXPORT __main
	entry
	
__main	
	
	BL config
	MOV r8, #10
	MOV r9, #0
	
loop
	BL pls
	BL pls2
	BL pls3

	ADD r9, #1
	CMP r9, #60
	BNE	inside
	MOV r9, #0

inside
	
	UDIV r2, r9, r8
	MUL r0, r2, r8
	SUB r1, r9, r0
	
	LDR r4, =0x001FFFFF
	LDR r5, =PIOA_CODR
	STR r4, [r5]
	
	LDR r3, =OUR_FIXED_DATA
	LDRB r4, [r3, r2]
	LDRB r5, [r3, r1]
	LSL r4, #14
	LSL r5, #3
	ORR r4, r4, r5
	
	LDR r5, =PIOA_SODR
	STR r4, [r5]
	
	BL timer

	B loop		

here B here

config
	LDR r4, =0x001FFFFD
	LDR r5, =PIOA_PER
	STR r4, [r5]
	
	LDR r4, =0x001FFFFD
	LDR r5, =PIOA_OER
	STR r4, [r5]
	
	MOV r4, #0xFF	
	LDR r5, =PIOB_PER
	STR r4, [r5]
	
	BX lr

timer
	MOV r3, #0
	LDR r2, =0x00030000
inl
	ADD r3, r3, #1
	CMP r2, r3
	BNE inl
	BX lr
	
pls
	LDR r6, =ONOFF
	LDR r5, =PIOB_PDSR
	LDR r4, [r5]
	AND r4, r4, r6
	CMP r4, r6
	BNE dow
	BX lr
dow	
	MOV r9, #0
	LDR r4, =0x001FFFFD
	LDR r5, =PIOA_CODR
	STR r4, [r5]
	
	MOV r3, #0
	LDR r2, =0x00004000
loo	
	CMP r2, r3
	BNE mid
	MOV r3, #0
	LDR r5, =PIOB_PDSR
	LDR r4, [r5]
	AND r4, r4, r6
	CMP r4, r6
	BNE mid
	BX lr
mid	
	ADD r3, #1
	B loo

pls2
	LDR r6, =STPRSM
	LDR r5, =PIOB_PDSR
	LDR r4, [r5]
	AND r4, r4, r6
	CMP r4, r6
	BEQ dow2
	BX lr
dow2
	
	MOV r3, #0
	LDR r2, =0x00004000
loo2	
	CMP r2, r3
	BNE mid2
	MOV r3, #0
	LDR r5, =PIOB_PDSR
	LDR r4, [r5]
	AND r4, r4, r6
	CMP r4, r6
	BEQ mid2
	BX lr
mid2	
	ADD r3, #1
	B loo2
	
pls3
	LDR r6, =RST
	LDR r5, =PIOB_PDSR
	LDR r4, [r5]
	AND r4, r4, r6
	CMP r4, r6
	BEQ dow3
	BX lr
dow3

	LDR r4, =0x001FFFFD
	LDR r5, =PIOA_CODR
	STR r4, [r5]
	MOV r9, #0
	
	LDR r3, =OUR_FIXED_DATA
	LDRB r4, [r3, #0]
	LDRB r5, [r3, #0]
	LSL r4, #14
	LSL r5, #3
	ORR r4, r4, r5
	
	LDR r5, =PIOA_SODR
	STR r4, [r5]
	MOV r3, #0
	LDR r2, =0x00004000
loo3	
	CMP r2, r3
	BNE mid3
	MOV r3, #0
	LDR r5, =PIOB_PDSR
	LDR r4, [r5]
	AND r4, r4, r6
	CMP r4, r6
	BEQ mid3
	BX lr
mid3	
	ADD r3, #1
	B loo3



OUR_FIXED_DATA
	DCB   0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70, 0x7F, 0x7B	
	END

	