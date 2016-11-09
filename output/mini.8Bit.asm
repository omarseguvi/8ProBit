.init: 
	MOV D, 232;
	JMP main;
	.UNDEF: DB 255;

main_data: 
	main_ra: DB 0; 
	main_x: DB 0; 
	main_y: DB 0; 
	main_a: DB 0; 
	main_String0: DB "asdas"; 
	 DB 0; 
main: 
	PUSH 4; 
	POP A; 
	MOV a , A; 
	PUSH main_String0; 
	CALL print_string;

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
                            
