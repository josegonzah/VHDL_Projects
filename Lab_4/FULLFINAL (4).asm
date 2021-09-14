	.ORIG	x3000
LOOP1	 
	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0	
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0
	JSR	GETDATOS
	JSR     ORDENAR 	
MENU	LEA	R0, MENU1	;Despliega el menu
	TRAP	x22
	LEA	R0, MENU2
	TRAP 	x22
	LEA	R0, MENU3
	TRAP 	x22
	LEA	R0, MENU4
	TRAP 	x22
	LEA	R0, MENU5
	TRAP 	x22
	LEA	R0, MENU6
	TRAP 	x22
	LEA	R0, MENU7
	TRAP 	x22
	LEA	R0, MENU8
	TRAP 	x22
	JSR 	GETL
	
	LDI R1,N_MENU
OP_1	ADD R2,R1,#-1
	BRNP OP_2
	JSR OPCION1_2
OP_2    ADD R2,R1,#-2
	BRNP OP_3
	JSR OPCION1_2
OP_3	ADD R2,R1,#-3
	BRNP OP_4
	JSR PRINTLIST
OP_4	ADD R2,R1,#-4
	BRNP OP_5
	JSR PRINTLIST
OP_5	ADD R2,R1,#-8
	BRZP OP_6
	JSR MULTIPL
OP_6    BRNZP	LOOP1

	;ADD	R4, R4, #-2	;Salto de funcionalidad
	;BRNZ 	ORDENAR		;Salto a ordenar si la opcion es ordenar o conocer el mayor
	;BRP	MULTIPL		;Salto a encontrar multiplos

MENU1	.STRINGZ "Ingrese la funcionalidad que desea: \n 1)Buscar el mayor"
MENU2	.STRINGZ "\n 2)Buscar el menor"
MENU3 	.STRINGZ "\n 3)Ordenar Ascendentemente"
MENU4 	.STRINGZ "\n 4)Ordenar Decendentemente"
MENU5 	.STRINGZ "\n 5)Multiplos de 2"
MENU6 	.STRINGZ "\n 6)Multiplos de 4"
MENU7 	.STRINGZ "\n 7)Multiplos de 8"
MENU8 	.STRINGZ "\n 8)Ingresar los datos \n"

;Subroutine NEWLN*************************************************************
;Advances the console cursor to the start of a new line
NEWLN	
	ST R7, NEW7	;Save working registers
	ST R0, NEW0
	LD R0, NL		;Output a newline character
	TRAP	x21
	LD R0, NEW0	;Restore working registers
	LD R7, NEW7
	RET			;Return
;Data
NL		.FILL	x000A	;Newline character x0A
NEW0		.BLKW	1	;Save area - R0
NEW7		.BLKW	1	;Save area - R7
RETORNO2 	.FILL #0
N_MENU		.FILL L
N1_2		.FILL N1
;-------------------------Para ordenar se utilizo el metodo de borbuja----------------
ORDENAR	    	ST R7,RETORNO2
		AND R1,R1,#0;
		ADD R1,R1,#1		;CONTADOR PRIMER CICLO
LOOP_1		LDI R0,N1_2		NOT R0,R0
		ADD R0,R0,#1
	        ADD R3,R1,R0		;RESTAMOS N
		BRZ SORTED
		;---LOOP2
		AND R2,R2,#0		; CONTADOR SEGUNDO CICLO
		LOOP2 	LDI R0,N1_2
			ADD R7,R1,#0
			NOT R7,R7
			ADD R7,R7,#1
			ADD R0,R0,R7
			ADD R4,R2,#0
			NOT R4,R4
			ADD R4,R4,#1;
			ADD R4,R4,R0
			BRZ AUMENTAR
			LEA R4,NUMVECT	;CARGAMOS LA DIRECCION
			ADD R4,R4,R2
			LDR R5,R4,#0
			BRP VER_P
			BRN VER_N
			LDR R6,R4,#1
			ADD R7,R5,R6
			BRN CAMBIAR1
			ADD R2,R2,#1
			BRNZP LOOP2						
		CAMBIAR1 	STR R6,R4,#0
				STR R5,R4,#1
				ADD R2,R2,#1
				BRNZP LOOP2
		VER_P   LDR R6,R4,#1
			BRP CASO1
			BRNZP CAMBIAR1
		VER_N   LDR R6,R4,#1
			BRN CASO1
			;NO HAY QUE CAMBIAR 
			ADD R2,R2,#1
			BRNZP LOOP2
		CASO1   ADD R7,R6,#0
			NOT R7,R7
			ADD R7,R7,#1
			ADD R0,R5,R7
			BRP CAMBIAR1
			ADD R2,R2,#1
			BRNZP LOOP2
		AUMENTAR	ADD R1,R1,#1
				BRNZP LOOP_1		
	SORTED 		AND R0, R0, #0
			AND R1, R1, #0
			AND R2, R2, #0	
			AND R3, R3, #0
			AND R4, R4, #0
			AND R5, R5, #0
			AND R6, R6, #0
			LD R7,RETORNO2
			RET
;------------------------------------------------------------------------------------
OPCION1_2	LEA R2, NUMVECT
		LDI R1,N_MENU
		ADD R1,R1,#-2
		BRZ MENOR	;Verificamos si la opcion 1 0 2
		LD R1,N1
		ADD R1,R1,#-1
		ADD R2,R2,R1	;Cargamos el ULTIMO numero de la lista oredenada	
MENOR		LDR R0,R2,#0	;Cargamos el PRIMER numero de la lista ordenada	
		AND R1, R1, 0
		ADD R1, R1, #10
		ADD R0, R0, #0
		BRN NEG2
		BRZP NORMALITO
NEG2		ST R0, GUARDR0
		LD R0, SIGNMEN
		OUT
		LD R0, GUARDR0
		NOT R0, R0
		ADD R0, R0, #1
NORMALITO 	JSR PRINT	
		JSR NEWLN
	LD R0, INITL2
	JMP R0
GUARDR0 .BLKW 1
AUX1 	.FILL #0
;---------------------------------------MULTIPLOS----------------------

MULTIPL 	AND R0,R0,#0
		LD R4,N1
		LEA R2 NUMVECT
		LDI R1,N_MENU		;N_MENU=L
		ADD R1,R1,#-6
		BRP OCHO		;L=7
		BRZ CUATRO		;L=6
		BRN DOS 		;L=5
OCHO 		ADD R0,R0,#7
		BRNZP PRINTMUL_2
CUATRO		ADD R0,R0,#3
		BRNZP PRINTMUL_2
DOS		ADD R0,R0,#1 		
PRINTMUL_2	ST R0,AUX1

PRINTMUL	LD R0,AUX1
		AND R5, R5, #0
		ADD R5, R5, R0		;R5=7,3,1
		ADD R4, R4, #0
		BRZ FINISH2				
		LDR R0, R2, #0
		AND R1, R1, #0
		ADD R1, R1, #10
		AND R6, R5, R0
		BRZ PRINTM1
		BRNP SALTO1 
PRINTM1		ADD R0, R0, #0
		BRn NEGATIVE
		BRzp NORMIX
NEGATIVE	ST R0 SAVER0
		LD R0 SIGNMEN
		OUT
		LD R0 SAVER0
		NOT R0, R0
		ADD R0, R0, #1

NORMIX		JSR PRINT
		JSR NEWLN
SALTO1		ADD R4, R4, #-1
		ADD R2, R2, #1
		BRNZP PRINTMUL
FINISH2 	LD R0 INITL2
		JMP R0;
SIGNMEN .FILL x002D
SAVER0	.BLKW 1
AGAIN 	LD R0 INITL2
	JMP R0		
INITL2 .FILL MENU

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
	TRAP x21 	
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
NUMVECT		.BLKW 20; 
 
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

N		.FILL X0000
N1		.BLKW 1
;----------------------------------------------------------------------
PRINTLIST 	LD R4, N1;		;R4=NUMERO DE DATOS 
		LEA R2 NUMVECT
		LD R1,L			;L=N_MENU
		ADD R1,R1,#-3
		BRZ ASCEN
		LD R3,N1		
		ADD R3,R3,#-1		;R3=NUMERO DE DATOS-1
		ADD R2,R2,R3		;R2=NUMVECT+NUMERO DE DATOS-1
		AND R3,R3,#0
		ADD R3,R3,#-1
		BRNZP PRINTNUMBER
ASCEN		AND R3,R3,#0
		ADD R3,R3,#1		;R3=1		
PRINTNUMBER									
		ADD R4, R4, #0		
		BRZ FINISH1				
		LDR R0, R2, #0
		BRn PRINTMENOS
		BRzp PRINTNORM1
		

PRINTMENOS	ST R0, CARGAR0
		LD R0, SIGNOM1
		OUT
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
;--------------------------------------------------------------
GETL 		ST R7,RETORNO
GETL2		BRNZP RECIBIR
GETL3		AND R4, R4, #0
		ADD R3,R0,#-10
		BRZ GETL2 ;Verificamos si es un enter
		OUT
		JSR MULT_10		
		ADD R3,R4,#-1
		BRN ERROR2 ;Si el nimero es menor que 1
		ADD R3,R4,#-8
		BRP ERROR2;Si el numero es mayor que 8
		JSR ENTER
		ST R4,L
		AND R3,R3,#0
		;ST R3,BANDERA		;Reiniciamos bandera para poder ingresar datos nuevamente 
		LD R7,RETORNO
		RET
;----------------------capturar el dato-----------------------------		  	
GETDATOS  	ST R7,RETORNO
GETDATOS_2	AND R2,R2,#0
		AND R4,R4,#0 
		AND R5,R5,#0
		ST R5,BANDERA
		LEA      R0,MSG_N
       		PUTS                    ;; Prints the null-terminated string
RECIBIR 	GETC  
		ADD R1,R0,#-10
		BRZ DIRECCION 		;Verificamos si es un enter             
		JSR NORMALIZAR	
;----------------------numeros-------------------------------------
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
;-----------------------------------DIRECCIONAMIENTO----------------------
;BANDERA: =0 Captura N, =1 Captura los datos , =2 Captura el Menu
DIRECCION	LD R3,BANDERA
		ADD R3,R3,#-2
		BRZ GETL3 		;SALTAOS A GETL
		ADD R3,R3,#2
		ADD R3,R3,#-1
		BRZ DATOS 		; Verificamos si esta capturando el numero N o los datos 
		ADD R1,R0,#-10	
		BRZ SALTO_DATOS		;Verificamos si ingreso un enter
		ADD R3,R2,#-2
		BRN ALMACENAR_NUM	;Verificamos si ingreso dos digitos
		BRNZP RECIBIR

;------------------PASSAR A OTRO ESTADO---TENER EN CUENTA,REINICIAR LOS REGISTROS R2,R4--------
ALMACENAR_NUM	OUT
		JSR MULT_10		;Acumulamos eL digito en R4
		ADD R2,R2,#1
		BR RECIBIR				
SALTO_DATOS	ADD R3,R4,-10
		BRN ERROR 		;Si el nimero es menor que 10
		ADD R3,R4,-15
		ADD R3,R3,-5
		BRP ERROR		;Si el numero es mayor que 20
		JSR ESPACIO
		JSR ENTER
		LEA R0, MSG_DA		;-->>MSG: INGRESE LOS DATOS 
		PUTS
		ST R4,N
		ST R4, N1
		AND R2,R2,#0
		AND R4,R4,#0	
		AND R0,R0,#0		 ;Reiniciamos los registros
		ADD R0,R0,#1
		ST R0,BANDERA
		BRNZP RECIBIR			
;------------------------------------multiplicacion X 10----------------------------------						
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
		OUT
		AND R5,R5,#0
		ADD R5,R5,#1
		ST R5,SIG
		;ADD R2,R2,#1; pasamos a capturar el primer digito
		BRNZP RECIBIR

;---------------------CONTRL DE CANTIDAD DE DATOS---------R2:CANTIDAD DE DIGITOS ---
DATOS		ADD R3,R0,#-10
		BRZ IN_ENTER		; Verificamos si es un enter
		JSR NORMALIZAR 
		ADD R3,R1,#3
		BRZ SIGNO		; Verificamos is es un signo
		ADD R3,R2,-5		
		BRZ RECIBIR		;Verificamos si ya ingreso los 5 digitos
		OUT 
		JSR MULT_10		;Acumulamos el digito en R4	
		ADD R2,R2,#1
		BRNZP RECIBIR
		
;---------------NUEVO DATO-----------REINICIAMOS LOS REGISTROS PARA UN NUEVO DATO--------
NEX_DATA	AND R2,R2,#0 ;cantidad de digitos de los datos del nuevo dato
		AND R4,R4,#0 
		ST R4,SIG
		JSR ESPACIO		
		LD R3,N
		ADD R3,R3,#-1
		ST R3,N		
		BRP RECIBIR ;SE VERIFICA SI TERMINA DE INGREAR LOS N DATOS
		JSR ENTER
		LEA R0,MSG_END
		PUTS
		JSR ENTER
		ST R2,CONTADOR;reiniciamos contador
		ADD R4,R4,#2
		ST R4,BANDERA;Pasamos al Menu
		AND R4,R4,#0
		LD R7,RETORNO		
		RET
		;JSR TERMINAR;----------------------CONECTAR CODIGO COMPAÑERO		
;-----------------------------------GUARDAMOS EL DATO SI SE  INGRESA UN ENTER-------------------------
IN_ENTER	ADD R3,R2,#0		;Verificamos si no se ingreso datos
		BRZ RECIBIR 
ALMACENAR	LD R0,SIG
		BRNZ GUARDAR1;Verificamos si es positivo o no
		NOT R4,R4
		ADD R4,R4,#1
GUARDAR1	LEA R0,NUMVECT;-----------------
		LD R3,CONTADOR
		ADD R5,R0,R3
		STR R4,R5,#0; Almacenamos el datos en la direccion NUMVECT+CONTADOR
		ADD R3,R3,#1
		ST R3,CONTADOR;Aumentamos contador+1 
		BRNZP NEX_DATA

ESPACIO		AND R0,R0,#0
		ADD R0,R0,#15
		ADD R0,R0,#15
		ADD R0,R0,#2
		ADD R6,R7,#0
		OUT 
		ADD R7,R6,#0
		RET
ENTER		AND R0,R0,#0
		ADD R0,R0,#13
		ADD R6,R7,#0
		OUT 
		ADD R7,R6,#0
		RET		

RETORNO		.FILL #0
BANDERA 	.FILL X0000
CONTADOR	.FILL #0; Contardor para sumar al NUMVECT
SIG   		.FILL x0000
ERROR   	JSR ENTER
		LEA R0,MSG_E
		PUTS
		JSR ENTER
		BRNZP GETDATOS_2
ERROR2 		LEA R0,MSG_E2
		PUTS
		BRNZP GETL2
MSG_E2		.STRINGZ "\nEsa opcion no esta en el Menu \n"
		
;-----------------------MENSAJES O MENU--------------------------------------
MSG_N   	 .STRINGZ "Ingrese el numero ENTERO entre 10 y 20: "   
       
MSG_DA    	.STRINGZ "Ingrese los Datos: "   

MSG_END		.STRINGZ "Sus datos fueron almacenados "
   
MSG_E    	.STRINGZ "Ingresó UN NUMERO INCORRECTO "   
        .END