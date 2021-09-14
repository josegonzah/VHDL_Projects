;--------------------------------------stack1 2000 y stack2 2000--------------------------
	.ORIG	x0000
LOOP1	 
	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0	
	AND R3, R3, #0
	AND R4, R4, #0	;DIR STACK
	AND R5, R5, #0	;DIR STACH
	AND R6, R6, #0
	AND R7, R7, #0	
MENU	LEA	R0, MENU1	;Despliega el menu
	JSR	PUTSMSG1
	LEA	R0, MENU2
	JSR 	PUTSMSG1
	LEA	R0, MENU3
	JSR	PUTSMSG1
	LEA	R0, MENU4
	JSR	PUTSMSG1
	JSR 	GETL	
	LDI R1,N_MENU
OP_1	ADD R2,R1,#-1
	BRNP OP_2
	JSR GETDATOS 	;saltamos al GETDATOS 
OP_2    ADD R2,R1,#-2
	BRNP OP_3
	JSR PRINTLIST
OP_3	ADD R2,R1,#-3
	BRNP OP_4
	JSR OPERADORES
OP_4	ADD R2,R1,#-4
	BRNP OP_5
	JSR LIMPIAR 
OP_5    BRNZP	LOOP1

MENU1	.STRINGZ "Ingrese la funcionalidad que desea: \n 1)Insertar datos al stack"
MENU2	.STRINGZ "\n 2)Ver los valores en el stack"
MENU3 	.STRINGZ "\n 3)Realizar las operaciones "
MENU4 	.STRINGZ "\n 4)Limpiar el stack \n"
N_MENU		.FILL L
N1_2		.FILL N1
N2_2		.FILL N2
;-------------------------------------LIMPIAR--------------------

LIMPIAR		AND R0,R0,#0
		STI R0,N1_2
		STI R0,N2_2
		BR LOOP1


;-------------------------------------NEW FUNCTIONS-------------------	
;---------------------------------
PUTCHAR1	ST R0,PCR01 	;se almacena el caracter
PUTCHAR21	LDI R0,DSR1	;R0=dato no direccion
		BRZP PUTCHAR21
		LD R0,PCR01
		STI R0,DDR1
		RET		
;---------------------------------
PCR01		.FILL 0
;---------------------------------
PUTSMSG1     ST  R0,PMR01 	
	    LDR R0,R0,#0 	
	    BRz PUTSMSGE1 	
	    ST R7,PMR71 		
	    JSR PUTCHAR1		
	    LD R7,PMR71		
	    LD R0,PMR01		
	    ADD R0,R0,#1	
	    BRnzp PUTSMSG1 	
PUTSMSGE1    RET 
	
;---------------------------------
PMR01		.FILL 0
PMR71		.FILL 0
KBRS1		.FILL XFE00
KBDR1		.FILL XFE02
DSR1		.FILL XFE04
DDR1		.FILL XFE06

;Subroutine NEWLN*************************************************************
;Advances the console cursor to the start of a new line
NEWLN	
	ST R7, NEW7	;Save working registers
	ST R0, NEW0
	LD R0, NL		;Output a newline character
	JSR OUT_CHAR
	LD R0, NEW0	;Restore working registers
	LD R7, NEW7
	RET			;Return
;Data
NL		.FILL	x000A	;Newline character x0A
NEW0		.BLKW	1	;Save area - R0
NEW7		.BLKW	1	;Save area - R7

;--------------------------------------------------------------------------------
;PRINT IMPRIME EL NUMERO EN LA BASE DADA POR R1, EL NUMERO ALMACENADO EN R0
PRINT
	ST	R7, PRT7	
	ST	R6, PRT6	
	ST	R5, PRT5	
	ST	R4, PRT4	
	ST	R3, PRT3	
	ST	R2, PRT2	
	AND R7 R7 0 	
	AND R6 R6 0 	 
	AND R5 R5 0 	 
	AND R4 R4 0 	 
	AND R3 R3 0 	 
	AND R2 R2 0 	 
	; GUARDO EL VALOR DE R0
	ST R0 CURRENT 	
	
	;checker for decimal 
	LEA R6 STORE	
	LEA R7 ASCI 	
	LDR R4 R7 0  
	ADD R2 R2 -15 
	ADD R2 R2 -1 	
	ADD R2 R1 R2 	
	AND R2 R2 0 	
	BRNZP 3			
	AND R5 R5 0 	
	ADD R5 R5 R2	 
	BRZ DISPLAY 		;MOSTRAR
	JSR DIVIDE		;SE SALTA A LA DIVISION
	ADD R3 R3 R4 	
	STR R3 R6 0		
	ADD R6 R6 1 	
	ADD R0 R2 0 	;
	BRNZP -9		; VUELVE A INICIAR EL PROGRAMA CON EL OTRO DIGITO

DISPLAY
	AND R7 R7 0
	AND R5 R5 0
	ADD R6 R6 -1
	LDR R5 R6 0 	
	ADD R7 R5 0 	
	BRZ 4  			
	ADD R0 R5 0 	
	JSR OUT_CHAR 	
	ADD R6 R6 -1 	
	BRNZP -7 		
END	
	AND R0 R0 0 	
	LD R0 CURRENT 	
	LD	R7, PRT7
	LD	R6, PRT6
	LD	R5, PRT5
	LD	R4, PRT4
	LD	R3, PRT3
	LD	R2, PRT2
	RET		
CURRENT 	.FILL x0000
PRT7	.BLKW	1	
PRT6	.BLKW	1	
PRT5	.BLKW	1	
PRT4	.BLKW	1	
PRT3	.BLKW	1	
PRT2	.BLKW	1	
ASCI 	.FILL 	x0030	
DIGITS	.STRINGZ "0123456789ABCDEF"
BUFFER	.FILL	x0000	
STORE	.BLKW	18

 
;---------------------DIVIDIR---------------
;R0 - NUMERADOR,  R1 - DIVISOR
;: R2 - COCIENTE,   R3 - RESIDUO
DIVIDE	
	ST	R7, DIV7	
	ST	R6, DIV6	
	ST	R5, DIV5	
	ST	R4, DIV4		
	AND R7 R7 0 	
	AND R6 R6 0 	
	AND R5 R5 0 	
	AND R4 R4 0 	
	AND R3 R3 0 	
	AND R2 R2 0 
	ADD R3 R0 0	
	ADD R5 R1 0 	 
	NOT R5 R5 		
	ADD R5 R5 1 	
	ADD R6 R3 R5 	  ;DIVISONES SUSCESIVAS
	BRN 3 			; SALIR
	ADD R2 R2 1 	; CONTADOR
	ADD R3 R3 R5 	; RESTO LO DEL RESIDUO
	BRNZP -5 		; SALTO AL INICIO DE LA DIVISION
	LD R7, DIV7 	
	LD R6, DIV6 	
	LD R5, DIV5 	
	LD R4, DIV4 	
	RET		
DIV7 	.BLKW 	1 	
DIV6 	.BLKW 	1 	
DIV5 	.BLKW 	1 	
DIV4 	.BLKW 	1 
	
;----------------------------------------------------------------------
PRINTLIST 	LD R4,N1 		; | R4=NUMERO DE DATOS 
		LD R2 NUMVECT
ASCEN		AND R3,R3,#0
		ADD R3,R3,#1	
PRINTNUMBER									
		ADD R4, R4, #0		
		BRZ FINISH1				
		LDR R0, R2, #0
		BRn PRINTMENOS
		BRzp PRINTNORM1
PRINTMENOS	ST R0, CARGAR0
		LD R0, SIGNOM1
		JSR OUT_CHAR
		LD R0, CARGAR0
		NOT R0, R0
		ADD R0, R0, #1
PRINTNORM1	AND R1, R1, #0		;R1=0
		ADD R1, R1, #10		;R1=10
		ST R3,R3_TEMP
		JSR PRINT		;SALTOOOOO
		JSR NEWLN		;SALTOOOOO
		LD R3,R3_TEMP
		ADD R4, R4, #-1
		ADD R2, R2, R3
		BRNZP PRINTNUMBER
FINISH1 	LD R0 INITL
		JMP R0;
R3_TEMP		.FILL #0
SIGNOM1 	.FILL x002D
CARGAR0 	.BLKW 1
INITL		.FILL MENU
L		.FILL #0
L1 		.FILL x0003
RETORNO_OPER	.FILL #0
MSG_STX		.STRINGZ "\Error de sintaxis \n"
;-----------------------------------------Operaciones-------------------
OPERACIONES	ST R7,RETORNO_OPER
		LD R0,STACK_OPER	;R0=Dir del stack de los operadaores 
		LD R1,NUMVECT		;R1=Dir del stack de los numeros 
		ADD R1,R1,#-1		
NEXT_OPERACION 	LD R3,N1
		ADD R5,R3,R1		;apuntador al ultimo numero ;R5=N1+(NUMVECT)
		ADD R4,R5,#-1		;apuntador
		ADD R3,R3,#-1		;Verificar si hay mas de dos datos
		BRNZ VERI_OPER
		LD R2,N2
		BRNZ RESULTADO
		LDR R6,R4,#0		;Cargamas los datos
		LDR R7,R5,#0
		ADD R5,R5,#-1
		LD R2,N1
		ADD R2,R2,#-1
		ST R2,N1	
		LDR R2,R0,#0		;R2=dato(Operador) 	
		ADD R0,R0,#1
		LD R3,N2
		ADD R3,R3,#-1
		ST R3,N2
		LD R3,MAS
		ADD R3,R3,R2
		BRZ SUMAR
		LD R3,MENOS
		ADD R3,R3,R2
		BRZ RESTAR
		LD R3,MULT
		ADD R3,R3,R2
		BRZ MULTIPLICAR
		LD R3,DIV
		ADD R3,R3,R2
		BRZ DIVIDIR
		LD R3,MOD
		ADD R3,R3,R2
		BRZ MODULO
		BR RESULTADO		
VERI_OPER	LD R2,N2
		BRP ERROR_STX
		BR RESULTADO
ERROR_STX	LEA R0,MSG_STX
		JSR PUTSMSG1
		AND R0,R0,#0
		ST R0,N2
		LD R7,RETORNO_OPER
		RET					
			
SUMAR 		ADD R3,R6,R7
		STR R3,R4,#0
		BR NEXT_OPERACION		
RESTAR		NOT R6,R6
		ADD R6,R6,#1
		ADD R3,R6,R7
		STR R3,R4,#0
		BR NEXT_OPERACION

MULTIPLICAR	LD R2,DIR_MULT_A
		LD R3,DIR_MULT_B
		STR R7,R2,#0
		STR R6,R3,#0
WAIT_MULT	LDI R2,ESTADO_MULT
		BRZP WAIT_MULT
		LDI R2,RESULT_MENOR
		LDI R3,RESULT_MAYOR
		STR R2,R4,#0		;QUE HACER CON EL OTRO DATO ??????
		BR NEXT_OPERACION

DIVIDIR		LD R2,DIR_MULT_A
		LD R3,DIR_DIV_B
		STR R7,R2,#0
		STR R6,R3,#0
WAIT_DIV	LDI R2,ESTADO_DIV
		BRZP WAIT_DIV
		LDI R3,RESIDUO
		LDI R2,COCIENTE
		STR R2,R4,#0		;QUE HACER CON EL OTRO DATO ??????
		BR NEXT_OPERACION

MODULO		BR DIVIDIR
		BR NEXT_OPERACION
RESULTADO	
		LDR R0,R5,#0 
		AND R1,R1,#0
		ADD R1,R1,#10
		JSR PRINT		
		JSR NEWLN
		AND R0,R0,#0
		ST R0,N2
		LD R7,RETORNO_OPER
		RET
;-----------------------
DIR_MULT_A	.FILL xFE03
DIR_MULT_B	.FILL xFE05
ESTADO_MULT	.FILL xFE01


DIR_DIV_B	.FILL xFE0C
ESTADO_DIV	.FILL xFE09
RESULT_MAYOR	.FILL xFE07	;COCIENTE
RESULT_MENOR	.FILL xFE08	;RESIDUO
COCIENTE	.FILL xFE0A
RESIDUO		.FILL XFE0B
				
N1		.BLKW 1	
N2		.FILL #0	 	
;--------------------------------------------------------------
GETL 		ST R7,RETORNO
GETL2		BRNZP RECIBIR
GETL3		AND R4, R4, #0
		ADD R3,R0,#-10
		BRZ ENTERR ;Verificamos si es un enter
		JSR OUT_CHAR
		JSR MULT_10		
		ADD R3,R4,#-1
		BRN ERROR2 ;Si el nimero es menor que 1
		ADD R3,R4,#-4
		BRP ERROR2;Si el numero es mayor que 4
		ST R4,L
		AND R3,R3,#0
		BR GETL2
ENTERR		JSR SALTO_LINE
		LD R7,RETORNO
		RET
;----------------------capturar el dato-----------------------------		  	
OUT_CHAR	ST R0,PCR0 	;se almacena el caracter
OUT_CHAR2	LDI R0,DSR	;R0=dato no direccion
		BRZP OUT_CHAR2
		LD R0,PCR0
		STI R0,DDR
		JMP R7		;RET  
PCR0		.FILL 0
DSR		.FILL XFE04
DDR		.FILL XFE06
COMA		.FILL #-44
SELEC_STACK	.FILL #0	; 0=stack numeros , 1 stack signos
RETORNO2	.FILL #0
STORE_R1	.FILL #0
;----------------------------------OPERADORES-----------------------------
OPERADORES	ST R7,RETORNO2
		ST R1,STORE_R1
		AND R0,R0,#0
		ADD R0,R0,#1
		ST R0,SELEC_STACK
		JSR GETDATOS
		JSR OPERACIONES	;----------
		LD R1,STORE_R1
		LD R7,RETORNO2
		RET
;--------------------------------------------------
MAS		.FILL #-43
MENOS		.FILL #-45
MULT		.FILL #-42
DIV		.FILL #-47
MOD		.FILL #-37		
;--------------------------------------------------------
GETDATOS  	ST R7,RETORNO
		AND R2,R2,#0
		AND R4,R4,#0
		ST R4,BANDERA
RECIBIR 	JSR GETCHAR2
		ADD R1,R0,#-10
		BRZ ENTER		;Verificamos si es un enter (FALTA RUTINA)
		LD R1,COMA
		ADD R1,R1,R0		
		BRZ DIRECCION        	;Verificamos si hay una coma 
		LD R1,SELEC_STACK
		BRZ RECIBIR2		; capturar numeros o signos
;-------------------signos-------------------------------
		LD R1,MAS
		ADD R1,R1,R0
		BRZ DIRECCION
		LD R1,MENOS
		ADD R1,R1,R0
		BRZ DIRECCION
		LD R1,MULT
		ADD R1,R1,R0
		BRZ DIRECCION
		LD R1,DIV
		ADD R1,R1,R0
		BRZ DIRECCION
		LD R1,MOD
		ADD R1,R1,R0
		BRZ DIRECCION
		BRNZP RECIBIR	
;----------------------numeros-------------------------------------			
RECIBIR2	JSR NORMALIZAR	
		ADD R1,R1,#-9
		BRZ DIRECCION
		ADD R1,R1,#9
		ADD R1,R1,#-8
		BRZ DIRECCION
		ADD R1,R1,#8
		ADD R1,R1,#-7
		BRZ DIRECCION
		ADD R1,R1,#7
		ADD R1,R1,#-6
		BRZ DIRECCION
		ADD R1,R1,#6
		ADD R1,R1,#-5
		BRZ DIRECCION
		ADD R1,R1,#5
		ADD R1,R1,#-4
		BRZ DIRECCION
		ADD R1,R1,#4
		ADD R1,R1,#-3
		BRZ DIRECCION
		ADD R1,R1,#3
		ADD R1,R1,#-2
		BRZ DIRECCION
		ADD R1,R1,#2
		ADD R1,R1,#-1
		BRZ DIRECCION
		ADD R1,R1,#1
		ADD R1,R1,#-0
		BRZ DIRECCION
		ADD R1,R1,#3 ;Verificamos si es el signo(-)
		BRZ DIRECCION
		BRNP RECIBIR;
STACK_OPER	.FILL STACK_OPER2 
NUMVECT		.FILL NUMVECT2; 
;-----------------------------------DIRECCIONAMIENTO----------------------
;BANDERA: =1 Captura MENU, =0 Captura los operandos, =2 Captura los operadores(signos) 
DIRECCION	LD R3,BANDERA
		ADD R3,R3,#-1
		BRZ GETL3 		;SALTAOS A GETL(MENU)
		BRNP DATOS		;
;------------------PASSAR A OTRO ESTADO---TENER EN CUENTA,REINICIAR LOS REGISTROS R2,R4--------
MAXIMO		.FILL -5	;tamaño del stack

AGAIN2 		JSR GETCHAR2
		JSR PUTCHAR2 
END12		BR AGAIN2
;--------------------------------
GETCHAR2 	LDI R0,KBRS2		
		BRZP GETCHAR2
		LDI R0,KBDR2;	R0=dato no direccion
		RET
;---------------------------------
PUTCHAR2	ST R0,PCR02 	;se almacena el caracter
PUTCHAR22	LDI R0,DSR2	;R0=dato no direccion
		BRZP PUTCHAR22
		LD R0,PCR02
		STI R0,DDR2
		RET		;JMP R7
;---------------------------------
PCR02		.FILL 0
;---------------------------------
PUTSMSG2     ST  R0,PMR02 	
	    LDR R0,R0,#0 	
	    BRz PUTSMSGE2 	
	    ST R7,PMR72		
	    JSR PUTCHAR2		
	    LD R7,PMR72		
	    LD R0,PMR02		
	    ADD R0,R0,#1	
	    BRnzp PUTSMSG2 	
PUTSMSGE2    RET 	
;---------------------------------
PMR02		.FILL 0
PMR72		.FILL 0
KBRS2		.FILL XFE00
KBDR2		.FILL XFE02
DSR2		.FILL XFE04
DDR2		.FILL XFE06
;------------------------ENTERR------------------------
ENTER 		LD R3,BANDERA
		ADD R3,R3,#-1
		BRZ GETL3 
		AND R2,R2,#0 ;cantidad de digitos de los datos
		LD R4,CONTADOR
		BRNZP TERMINO

;---------------------------MULTIPLICACION X10------------------------						
MULT_10   	ADD R3,R4,R4  ; R3 ==  2*R4
        	ADD R3,R3,R3  ; R3 ==  4*R4
        	ADD R3,R3,R4  ; R3 ==  5*R4
        	ADD R3,R3,R3  ; R3 == 10*R4
		ADD R6,R7,#0
		JSR NORMALIZAR
		ADD R4,R3,R1  ; sumamos el digito ingresado
		ADD R7,R6,#0
		RET
;--------------------------------NORMALIZAMOS EL DATO-----------------------
NORMALIZAR      AND R1,R1,#0 ;Normalizamos el numero restando 48=>0
		ADD R1,R1,R0
		ADD R1,R1,#-15
		ADD R1,R1,#-15
		ADD R1,R1,#-15
		ADD R1,R1,#-3 ;
		RET
;--------------------------SIGNO------------------------------
SIGNO		LD R5,SIG
		BRP RECIBIR; Verificamos si estan el la pocision(0)
		ADD R2,R2,#0
		BRP RECIBIR
		JSR OUT_CHAR
		AND R5,R5,#0
		ADD R5,R5,#1
		ST R5,SIG
		;ADD R2,R2,#1; pasamos a capturar el primer digito
		BRNZP RECIBIR
;---------------------CONTRL DE CANTIDAD DE DATOS---------R2:CANTIDAD DE DIGITOS ---
DATOS		LD R1,COMA
		ADD R1,R1,R0		
		BRZ IN_ENTER        	;Verificamos si hay una coma
		LD R1 SELEC_STACK
		BRZ NUMEROS
		ADD R2,R2,#0
		BRP RECIBIR
		JSR OUT_CHAR
		ADD R4,R0,#0
		ADD R2,R2,#1	
		BRNZP RECIBIR
NUMEROS		JSR NORMALIZAR 
		ADD R3,R1,#3
		BRZ SIGNO		; Verificamos is es un signo
		ADD R3,R2,-5		
		BRZ RECIBIR		;Verificamos si ya ingreso los 5 digitos
		JSR OUT_CHAR
		JSR MULT_10		;Acumulamos el digito en R4	
		ADD R2,R2,#1
		BRNZP RECIBIR		
;---------------NUEVO DATO-----------REINICIAMOS LOS REGISTROS PARA UN NUEVO DATO--------
NEX_DATA
		AND R2,R2,#0 ;cantidad de digitos de los datos 
		ST R2,SIG
		JSR ESPACIO		
		LD R3,MAXIMO		;-----------SOLO PARA PRUEBA ESTA EN 5 DATOS
		LD R4,CONTADOR
		ADD R3,R3,R4
		BRZ TERMINO		;Verificamos si llega la borde del stack
		AND R4,R4,#0
		BRNZP RECIBIR
TERMINO		LD R0,SELEC_STACK
		BRP TERMINO2
		ST R4,N1		;Tambien es necesario almacena la cantidad de operadores?? ***********************************
TERMINO2	ADD R3,R2,#1
		ST R3,BANDERA;Pasamos al Menu
		AND R4,R4,#0
		ST R4,CONTADOR
		ST R4,SELEC_STACK		
		JSR SALTO_LINE
		LD R7,RETORNO		
		RET
	
;-----------------------------------GUARDAMOS EL DATO SI SE  INGRESA UNA COMA-------------------------
IN_ENTER	ADD R3,R2,#0		;Verificamos si no se ingreso datos
		BRZ RECIBIR 
ALMACENAR	LD R0,SIG
		BRNZ GUARDAR;Verificamos si es positivo o no
		NOT R4,R4
		ADD R4,R4,#1
GUARDAR		LD R0,SELEC_STACK
		BRZ STACK_NUM
		LD R0,STACK_OPER
		LD R3,N2
		BRNZP GUARDAR2
STACK_NUM	LD R0,NUMVECT;-----------------
		LD R3,N1		
GUARDAR2	ADD R5,R0,R3
		STR R4,R5,#0; Almacenamos el datos en la direccion (Numvect o stack_oper)+CONTADOR
		ADD R3,R3,#1
		ST R3,CONTADOR
		LD R0,SELEC_STACK
		BRP GUARDAR_OPER
		ST R3,N1 
		BRNZP NEX_DATA
GUARDAR_OPER	ST R3,N2		 
		BRNZP NEX_DATA
;		------------------
ERROR2 		LEA R0,MSG_E2
		JSR PUTSMSG2
		BRNZP GETL2
ESPACIO		AND R0,R0,#0
		ADD R0,R0,#15
		ADD R0,R0,#15
		ADD R0,R0,#2
		ADD R6,R7,#0
		JSR OUT_CHAR 
		ADD R7,R6,#0
		RET
SALTO_LINE	AND R0,R0,#0
		ADD R0,R0,#13
		ADD R6,R7,#0
		JSR OUT_CHAR
		ADD R7,R6,#0
		RET		
RETORNO		.FILL #0
BANDERA 	.FILL #1
CONTADOR	.FILL #0; Contardor para sumar al NUMVECT
SIG   		.FILL x0000


MSG_E2		.STRINGZ "\nEsa opcion no esta en el Menu \n"		
;-----------------------MENSAJES O MENU--------------------------------------
MSG_N   	 .STRINGZ "Ingrese el numero ENTERO entre 10 y 20: "   
       
MSG_DA    	.STRINGZ "Ingrese los Datos: "   

MSG_END		.STRINGZ "Sus datos fueron almacenados "
   
MSG_E    	.STRINGZ "Ingresó UN NUMERO INCORRECTO "  
       
NUMVECT2 	.BLKW #2000
STACK_OPER2	.BLKW #2000
.END