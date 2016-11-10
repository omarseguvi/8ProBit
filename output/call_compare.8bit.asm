.init: 
	MOV D, 232;
	JMP main;
	.UNDEF: DB 255;
  .true: DB "true"
	DB 0;
	.false: DB "false"
	DB 0;

compare_data: 
	compare_ra: DB 0; 
	compare_x: DB 0; 
	compare_y: DB 0; 
main_data: 
	main_ra: DB 0; 
	main_string0: DB "10>5="; 
	 DB 0; 
	main_string1: DB " 5>10="; 
	 DB 0; 
compare: 
	POP C; 
	POP A; 
	POP B; 
	PUSH [compare_y]; 
	PUSH [compare_x]; 
	PUSH [compare_ra]; 
	MOV [compare_ra] , C; 
	MOV [compare_y] , B; 
	MOV [compare_x] , A; 
if: 
	PUSH [compare_x]; 
	PUSH [compare_y]; 
	POP B; 
	POP A; 
	CMP A , B; 
	JBE out; 
	PUSH 1; 
	JMP return; 
out: 
	PUSH 0; 
return: 
	POP A; 
	MOV C , [compare_ra]; 
	POP B; 
	MOV [compare_ra] , B; 
	POP B; 
	MOV [compare_y] , B; 
	POP B; 
	MOV [compare_x] , B; 
	PUSH A; 
	PUSH C; 
	RET ; 
main: 
	PUSH main_string0; 
	CALL print_string; 
	POP A; 
	PUSH 10; 
	PUSH 5; 
	CALL compare; 
	CALL print_boolean; 
	POP A; 
	PUSH main_string1; 
	CALL print_string; 
	POP A; 
	PUSH 5; 
	PUSH 10; 
	CALL compare; 
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
                            
