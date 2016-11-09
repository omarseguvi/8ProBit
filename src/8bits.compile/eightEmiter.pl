/*
EIF400 loriacarlos@gmail.com
*/

:-['eightParser']
.


testEmiter :-
    testParser(P),
	genCode(P)
.


genCodeToFile(File, P) :-
   open(File, write, Out),
   genCode(Out, P),
   close(Out)
.
genCode(P) :- genCode(user_output, P)
.
genCode(Out, eightProg(L)) :- !,
							format(Out,'.init: \n',[]),
                            format(Out,'\tMOV D, 232\n',[]),
                            format(Out,'\tJMP main\n',[]),
							genCodePrint(Out),
							genCodeList(Out, L)
.
/*
%cambio
genCode(Out, fun(N,F,B)) :- !,    (main,a,main_a: DB 0;)            (hello,b,hello_b: DB 0;)
    insert_funActual(N)),
    %format(Out, 'function ', []),
    genCode(Out, N),
	format(Out, ':', []),
	genCode(Out, F),
	genCode(Out, B)
.
genCode(Out, formals(L)) :- !,
     format(Out, '(', []),
     insert_value(L),
     genCodeList(Out, L, ', '),
	 format(Out, ')', [])
.
%cambio
genCode(Out, body(L)) :- !,
   format(Out, '\n', []),
   genCodeList(Out, L, ' ')
   %format(Out, '}', [])
.
genCode(Out, atom(N)) :- !, format(Out, '~a ', [N])
.
genCode(Out, id(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, num(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, oper(N)) :- !, genCode(Out, atom(N))
.*/

%ams instruction ---------------------------------------
genCode(Out,asmins(N)) :- !,format(Out, '\n\t~a ;', [N])
.

genCode(Out,asmins(N, P1)) :- !,format(Out, '\n\t~a ~a;', [N, P1])
.

genCode(Out,asmins(N, P1, P3)) :- !,format(Out, '\n\t~a ~a , ~a;', [N, P1, P3])
.

genCode(Out, tag(N)) :- !,format(Out, '\n~a:', [N])
.

genCode(Out, vardecla(N)) :- !,format(Out, '\n\t~a: DB 0;', [N])
.

%-------------------------------------------------------
/*
genCode(Out, operation(O, L, R)) :- !,
    genCodeList(Out, [L, O, R])

.
genCode(Out, empty) :- !,  format(Out, '; ', [])
.
genCode(Out, assign(I, E)) :-  !,
   genCode(Out, operation(oper('='), I, E))

.
%cambios
genCode(Out, amsList(L)) :-  !,
	 genCodeList(Out, L)

.
genCode(Out, return(E)) :- !, format(Out, 'return ', []),
                              genCode(Out, E)
.
*/
genCode(_, E ) :- throw(E).

genCodeList(Out, L) :- genCodeList(Out, L, ' ')
.
genCodeList(_, [], _).
genCodeList(Out, [C], _) :- genCode(Out, C).
genCodeList(Out, [X, Y | L], Sep) :- genCode(Out, X),
                                format(Out, '~a', [Sep]),
                                genCodeList(Out, [Y | L], Sep)
.


genCodePrint(Out) :- !,format(Out,'\n
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
                            \n', [])
.
