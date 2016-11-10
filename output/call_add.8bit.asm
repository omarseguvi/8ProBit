.init: 
	MOV D, 232;
	JMP main;
	.UNDEF: DB 255;

add_data: 
	add_ra: DB 0; 
	add_x: DB 0; 
	add_y: DB 0; 
main_data: 
	main_ra: DB 0; 
	main_String0: DB "10+56="; 
	 DB 0; 
add: 
	POP C; 
	POP A; 
	POP B; 
	PUSH add_y; 
	PUSH add_x; 
	PUSH add_ra; 
	MOV add_ra , C; 
	MOV add_y , B; 
	MOV add_x , A; 
	PUSH add_x; 
	PUSH add_y; 
	POP B; 
	POP A; 
	ADD A , B; 
	PUSH A; 
	POP A; 
	MOV C , add_ra; 
	POP B; 
	MOV add_ra , B; 
	POP B; 
	MOV add_y , B; 
	POP B; 
	MOV add_x , B; 
	PUSH A; 
	PUSH C; 
	RET ; 
main: 
	PUSH main_String0; 
	CALL print_string; 
	POP A; 
	PUSH 10; 
	PUSH 56; 
	CALL add; 
	CALL print_number; 
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
                            
