dynamic simbol/3.
dynamic simbolS/3.
/*SimbolS --> Simnbols de String*/
dynamic cont/1.
dynamic fun_actual/1.

:-['eightParser']
.

delete_all:- retractall(fun_actual(_)), retractall(simbol(_,_,_)),retractall(simbolS(_,_,_)).

insert_funActual(N):-  retractall(fun_actual(_)), assert(fun_actual(N)).

insert_simbol(F,V,R):- assert(simbol(F,V,R)).

insert_simbolS(F,V,R):- assert(simbol(F,V,R)).

insert_value(V):- fun_actual(F), atom_concat(F,'_',R),
								  atom_concat(R,V,R1),
								  atom_concat(R1,':',R2),
								  atom_concat(R2,' DB 0;',R3),
								  insert_simbol(F,V,R3).

insert_string(V):- fun_actual(F), atom_concat(F,'_',R),
								  atom_concat(R,'string1',R1),
								  atom_concat(R1,':',R2),
                  atom_concat(R2,'DB ',R3),
                  atom_concat(R3,V,R4),
								  atom_concat(R4,' DB 0;',R5),
								  insert_simbolS(F,V,R5).

get_id(V,X):- fun_actual(F), simbol(F,V,X).
get_id(V,X):- fun_actual(F), simbolS(F,V,X).

/*Es solo de prueba */

show_data :- findall(E,simbol(_,_,E),L), forall((member(X,L)),(write(X),nl)).

visit(eightProg(FL), eightProg(P)) :- !,delete_all ,visitList(FL, Data, Code)
									   , show_data, append(Data, Code, P)
.


visit(fun(I, F, B), Data, Code) :- 	!, visit(funid, I, Code1)
									,visit(funData, I, Data1)
									,visit(F, Data2, _)
									,visit(B, Data3, Code2)
									,append([Data1,Data2 ,Data3],Data)
									,append(Code1,Code2,Code)
.

visit(funData, id(X), Data) :- !, concat(X,'_data', Z)
							   ,Data = [tag(Z)]
.

visit(funid, id(X), Code) :- !, Code = [tag(X)], insert_funActual(X)
.

visit(formals(L), Data, _ ) :- !, maplist(visitformal, L , Data)
.

visit(body(X), Data, Code) :- !,  visitList(X, Data, Code)
.

visit(assign(L, R), Data, Code) :- !, visit(R, _, Code1)
									, visit(assing, L,  Code2)
									,append(Code1,Code2,Code)
.

visit(cll(I,L) ,Data, Code) :- !, visitList(L,Data,Code1), write(Code1),
                                 visit(cll,I,Code2), write(Code2),
                                 append(Code1,Code2,Code)
.

visit(cll,id(X),Code):- Code = [asmins('CALL', X)]
.
visit(assing, id(X), Code) :-  Code = [asmins('POP', 'A'), asmins('MOV', X, 'A')]
.

visit(id(X), _, Code):- get_id(X,R), Code = [asmins('PUSH', R)]
.

visit(num(X), _, Code):- Code = [asmins('PUSH', X)]
.


visit(return(L), _, Code) :- !, visit(L, _, Code)
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

visit(*, _, Code) :- Code = [asmins('MUL','A'),asmins('PUSH','A')]
.

visit(-, _, Code) :- Code = [asmins('SUB','A','B'),asmins('PUSH','A')]
.

visit('/', _, Code) :- Code = [asmins('DIV','A'),asmins('PUSH','A')]
.

visit(empty, _, _)
.


visit(C,_, Code):- concat('--->',C,Y), Code = [tag(Y)]
.

visitformal(id(X), vardecla(X)) :- insert_value(X)
.

visitList([], _, _).
visitList( [C], Data, Code) :- visit(C, Data, Code).
visitList( [X, Y | L], Data, Code) :- visit(X, Data1, Code1)
									  ,visitList([Y | L], Data2, Code2)
									  ,append(Data1, Data2, Data)
									  ,append(Code1, Code2, Code)
.
