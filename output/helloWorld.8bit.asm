.init: 
	MOV D, 232;
	JMP main;
	.UNDEF: DB 255;

main_data: 
	main_ra: DB 0; 
	main_x: DB 0; 
	main_y: DB 0; 
	main_string0: DB "Hello World!"; 
	 DB 0; 
add_data: 
	add_ra: DB 0; 
	add_x: DB 0; 
	add_b: DB 0; 
	add_string1: DB "caca"; 
	 DB 0; 
main: 
	PUSH main_string0; 
	CALL print_string; 
	POP A; 
	HLT ; 
add: 
	POP C; 
	POP A; 
	POP B; 
	PUSH [add_b]; 
	PUSH [add_x]; 
	PUSH [add_ra]; 
	MOV [add_ra] , C; 
	MOV [add_b] , B; 
	MOV [add_x] , A; 
	PUSH add_string1; 
	CALL print; 
	POP A; 
	MOV C , [add_ra]; 
	POP B; 
	MOV [add_ra] , B; 
	POP B; 
	MOV [add_b] , B; 
	POP B; 
	MOV [add_x] , B; 
	PUSH A; 
	PUSH C; 
	RET ;

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
                            
