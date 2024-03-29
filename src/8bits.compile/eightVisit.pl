dynamic simbol/3.
dynamic fun_actual/1.
dynamic prt/1.

:-['eightParser']
.

:- discontiguous visit/3.

delete_all:- retractall(fun_actual(_)), retractall(simbol(_,_,_)).

insert_funActual(N):-  retractall(fun_actual(_)), assert(fun_actual(N)).

insert_simbol(F,V,R):- assert(simbol(F,V,R)).

insert_value(V):- fun_actual(F), atom_concat(F,'_',R),
								  atom_concat(R,V,R1),
								  insert_simbol(F,V,R1)
.


insert_prints(X) :- retractall(prt(X)), assert(prt(X))
.
/*get_id(V+,X-)*/
get_id(V,X):- fun_actual(F), simbol(F,V,X).
/*Es solo de prueba */
show_data :- findall(E,simbol(_,_,E),L), forall((member(X,L)),(write(X),nl)).

/*aquie se coloca una varialbe global para llevar conteo de strings. sc-> string counter*/
/*Ideas para hacerlo menos cochino se aceptan....*/
visit(eightProg(FL), eightProg(P)) :- !,
																			nb_setval(sc, 0),
																			delete_all,
																			visitList(FL, Data, Code1),
																			findall(E,prt(E),L),
																			append(Code1,L,Code),
																			append(Data, Code, P)
.
/*visit de main*/
visit(fun(I, F, B), Data, Code) :-  visit(funid, I, Code1),
									visit(funData, I, Data1),
                                    atom_string(id(main)) = atom_string(I), %intentar pasarlo al metodo compare
                                    visit(F, Data2, _),
                                    visit(B, Data3, Code2),
                                    append([Data1,Data2 ,Data3],Data),
									Code3 = [asmins('HLT')],
                                    append([Code1,Code2,Code3],Code),
																		!
                                    %,compleFun(I, Code3, Code)
.
/* cuando no es main hacer prologo*/
visit(fun(I, F, B), Data, Code) :- 	!, visit(funid, I, Code1)
									,visit(funData, I, Data1)
									,visit(F, Data2, _)
									,visit(B, Data3, Code3)
									,epilogo(Data2,Code4)
									,prologo(Data2,Code2)
									,append([Data1,Data2,Data3],Data),
									Code5 = [asmins('RET')]
									,append([Code1,Code2,Code3,Code4,Code5],Code)
									%,compleFun(I, Code3, Code)
.

%compare(atom_string(V),atom_string(V)).

prologo([vardecla(P)],[asmins('POP','C'),asmins('PUSH',P),asmins('MOV',P,'C')]).

prologo([vardecla(P),vardecla(S)],[asmins('POP','C'),asmins('POP','A'),asmins('PUSH',S),asmins('PUSH',P),asmins('MOV',P,'C'),asmins('MOV',S,'A')]).

prologo([vardecla(P),vardecla(S),vardecla(T)],[asmins('POP','C'),asmins('POP','A'),asmins('POP','B'),asmins('PUSH',T),asmins('PUSH',S),asmins('PUSH',P),asmins('MOV',P,'C'),asmins('MOV',T,'B'),asmins('MOV',S,'A')]).

epilogo([vardecla(P)],[tag(epilogo),asmins('POP','A'),asmins('MOV','C',P),asmins('POP','B'),asmins('MOV',P,'B'),asmins('PUSH','A'),asmins('PUSH','C')]).

epilogo([vardecla(P)|L],Code) :-
								 R = [tag(epilogo),asmins('POP','A'),asmins('MOV','C',P), asmins('POP','B'),asmins('MOV',P,'B')],
								 reverse(L,L2),
								 maplist(get_inse, L2, L3),
								 append(L3,L4),
								 R1 = [asmins('PUSH','A'),asmins('PUSH','C')],
								 append([R,L4,R1],Code)
.

get_inse(vardecla(X),L) :- L = [asmins('POP', 'B'), asmins('MOV', X , 'B' )].


visit(funData, id(X), Data) :- !, concat(X,'_data', Z)
							   								 ,Data = [tag(Z)]
.

visit(funid, id(X), Code) :- !, Code = [tag(X)], insert_funActual(X)
.
/*Se agrega de una vez la variable de retorno de la funcion actual*/
visit(formals(L), Data, _ ) :- !,insert_value(ra)
																,get_id(ra,V)
																,Data1 = [vardecla(V)]
																,maplist(visitformal, L , Data2)
																,append(Data1,Data2,Data)
.

visit(body(X), Data, Code) :- !,  visitList(X, Data, Code)
.

visit(assign(L, R), Data, Code) :- !,visit(R, Data1, Code1)
													,visit(assing, L, Data2 ,Code2)
									                  ,append(Code1,Code2,Code)
									                  ,append(Data1,Data2,Data)
.

visit(let(S), Data, Code) :- !, visitList(S,Data,Code)
.

visit(id(X), _, Code):- get_id(X,V),Code = [asmins('PUSH', V)]
.
visit(id(true), _, Code):- Code = [asmins('PUSH', 1)]
.
visit(id(false), _, Code):- Code = [asmins('PUSH', 0)]
.

visit(str(X), Data, Code):- stringCounter(C)
							, fun_actual(FA)
							,concat(FA, '_string', N)
							,concat(N, C, Z)
							, Data = [stringdecla(Z, X)]
							, Code = [asmins('PUSH',Z)]
.

visit(cll, id(X), Code):- fun_actual(R), R = main,
						  forall(member(X, ['print_number','print_string','print_boolean']),insert_prints(X)),
						  Code = [asmins('CALL', X),asmins('POP','A')]
.
visit(cll, id(X), Code):- forall(member(X, ['print_string','print_number','print_boolean']), insert_prints(X)),
 						  Code = [asmins('CALL', X)]
.

visit(cll(I, A), Data, Code) :- visitList(A, Data, Code1)
							 ,visit(cll, I, Code2)
							 ,append(Code1, Code2, Code)
.

visit(if(C,ifbody(B)),_,Code) :- Code1 = [tag(if)], visit(C,_,Code2),
																						visit(B,_,Code3),
																						Code4 = [asmins('JMP','return'),tag(out)],
																						append([Code1,Code2,Code4,Code3,[tag(return)]],Code)
.

visit(if(C,ifbody(B),else(E)),_,Code) :- Code1 = [tag(if)], visit(C,_,Code2),
																						visit(B,_,Code3),
																						Code4 = [asmins('JMP','return'),tag(out)],
																						visit(E,_,Code5),
																						append([Code1,Code2,Code3,Code4,Code5,[tag(return)]],Code)
.
/*hay que ver porque solo agarra dos id*/
visit(comp(X,Y,cmp(C)),_,Code):-    getVarName(X,X1),
                                    getVarName(Y, Y1),
                                    hash_comp(C,C1),
                                    Code = [asmins('PUSH',X1),asmins('PUSH',Y1)
                                            ,asmins('POP','B'),asmins('POP','A')
                                            ,asmins('CMP','A','B'),asmins(C1,'out')]
.
getVarName(X, Y) :- atom_number(X, _) -> Y = X; get_id(X,Y)
.

visit(scll, id(X), Code):- Code = [asmins('CALL', X)]
.

visit(scll(I, A), Data, Code) :- visitList(A, Data, Code1)
							 ,visit(scll, I, Code2)
							 ,append(Code1, Code2, Code)
.

visit(num(X), _, Code):- Code = [asmins('PUSH', X)]
.


visit(return(L), Data, Code) :- !,visit(L, Data, Code1), Code2 = [asmins('JMP',epilogo)],
																												 append(Code1,Code2,Code)
.


visit(operation(O, L, R) ,_,Code) :- !, visit(L, _, Code1)
									  , visit(R, _, Code2)
									  , visit(O, _, Code3)
									  , append([Code1, Code2, Code3], Code)
.



visit(oper(X), _, Code) :- !, Code1 = [asmins('POP','B'),asmins('POP','A')]
							, visit(X, _, Code2)
							, append(Code1,Code2,Code)
.

visit(+, _, Code) :- Code = [asmins('ADD','A','B'),asmins('PUSH','A')]
.

visit(*, _, Code) :- Code = [asmins('MUL','B'),asmins('PUSH','A')]
.


visit(-, _, Code) :- Code = [asmins('SUB','A','B'),asmins('PUSH','A')]
.

visit('/', _, Code) :- Code = [asmins('DIV','B'),asmins('PUSH','A')]
.

visit(while(C, B), _,Code ) :- Code1 = [tag('while')]
							  ,visit(C, _, Code2)
							  ,visit(B, _, Code3)
							  ,Code4 = [asmins('JMP', 'while'),tag('out')]
							  ,append([Code1, Code2,Code3,  Code4], Code)
.

visit(empty, _, _)
.
visit(C,_, Code):- concat('--->',C,Y), Code = [tag(Y)]
.

visitformal(id(X), vardecla(Z)) :- insert_value(X), get_id(X,Z)
.

visitList([], _, _).
visitList( [C], Data, Code) :- visit(C, Data, Code).
visitList( [X, Y | L], Data, Code) :- visit(X, Data1, Code1)
									  ,visitList([Y | L], Data2, Code2)
									  ,append(Data1, Data2, Data)
									  ,append(Code1, Code2, Code)
.

visit(assing, id(X), Data, Code) :- insert_value(X),
																		get_id(X,V),
																		Data = [vardecla(V)],
														        Code = [asmins('POP', 'A'), asmins('MOV', V, 'A')]
.

stringCounter(Z) :-  nb_getval(sc, Z)
					, Z1 is Z + 1
					, nb_setval(sc,Z1)
.


hash_comp('>','JBE').
hash_comp('>=','JB').
hash_comp('<','JAE').
hash_comp('<=','JA').
hash_comp('==','JE').
hash_comp('!=','JNE').
