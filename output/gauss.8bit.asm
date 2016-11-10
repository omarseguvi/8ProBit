.init: 
	MOV D, 232;
	JMP main;
	.UNDEF: DB 255;
  .true: DB "true"
	DB 0;
	.false: DB "false"
	DB 0;

gausWhile_data: 
	gausWhile_ra: DB 0; 
	gausWhile_n: DB 0; 
	gausWhile_s: DB 0; 
	gausWhile_i: DB 0; 
main_data: 
	main_ra: DB 0; 
	main_string0: DB "gauss(5)="; 
	 DB 0; 
gausWhile: 
	POP C; 
	POP A; 
	PUSH [gausWhile_n]; 
	PUSH [gausWhile_ra]; 
	MOV [gausWhile_ra] , C; 
	MOV [gausWhile_n] , A; 
	PUSH 0; 
	POP A; 
	MOV [gausWhile_s] , A; 
	PUSH [gausWhile_n]; 
	POP A; 
	MOV [gausWhile_i] , A; 
while: 
	PUSH [gausWhile_i]; 
	PUSH 0; 
	POP B; 
	POP A; 
	CMP A , B; 
	JNE out; 
	PUSH [gausWhile_s]; 
	PUSH [gausWhile_n]; 
	POP B; 
	POP A; 
	ADD A , B; 
	PUSH A; 
	POP A; 
	MOV [gausWhile_s] , A; 
	PUSH [gausWhile_i]; 
	PUSH 1; 
	POP B; 
	POP A; 
	SUB A , B; 
	PUSH A; 
	POP A; 
	MOV [gausWhile_i] , A; 
	JMP while; 
out: 
	PUSH [gausWhile_s]; 
	JMP epilogo; 
epilogo: 
	POP A; 
	MOV C , [gausWhile_ra]; 
	POP B; 
	MOV [gausWhile_ra] , B; 
	POP B; 
	MOV [gausWhile_n] , B; 
	PUSH A; 
	PUSH C; 
	RET ; 
main: 
	PUSH main_string0; 
	CALL print_string; 
	POP A; 
	PUSH 5; 
	CALL gausWhile; 
	CALL print_boolean; 
	POP A; 
	HLT ;

	print_string:
		POP C
		POP B
		PUSH C
	.print_string_loop_01:
		MOV C, [B]
		CMP C, 0
		JE .print_string_exit
		MOV [D], C
		INC D
		INC B
		JMP .print_string_loop_01
	.print_string_exit:
		POP C
		PUSH .UNDEF
		PUSH C
		RET
                            
