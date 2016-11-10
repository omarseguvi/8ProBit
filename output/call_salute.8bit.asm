.init: 
	MOV D, 232;
	JMP main;
	.UNDEF: DB 255;
  .true: DB "true"
	DB 0;
	.false: DB "false"
	DB 0;

salute_data: 
	salute_ra: DB 0; 
	salute_s: DB 0; 
main_data: 
	main_ra: DB 0; 
	main_string0: DB "Hello 666!"; 
	 DB 0; 
salute: 
	POP C; 
	POP A; 
	PUSH [salute_s]; 
	PUSH [salute_ra]; 
	MOV [salute_ra] , C; 
	MOV [salute_s] , A; 
	PUSH [salute_s]; 
	CALL print_string; 
epilogo: 
	POP A; 
	MOV C , [salute_ra]; 
	POP B; 
	MOV [salute_ra] , B; 
	POP B; 
	MOV [salute_s] , B; 
	PUSH A; 
	PUSH C; 
	RET ; 
main: 
	PUSH main_string0; 
	CALL salute; 
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
                            
