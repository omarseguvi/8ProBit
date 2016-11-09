:-['eightParser']
.



visit(eightProg(FL), eightProg(P)) :- !, visitList(FL, Data, Code)
									   , append(Data, Code, P)
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

visit(funid, id(X), Code) :- !, Code = [tag(X)]
.

visit(formals(L), Data, _ ) :- !, maplist(visitformal, L , Data)
.

visit(body(X), Data, Code) :- !,  visitList(X, Data, Code)
.

visit(assign(L, R), Data, Code) :- !, visit(R, _, Code1)
									, visit(assing, L,  Code2)
									,append(Code1,Code2,Code)
.

visit(assing, id(X), Code) :-  Code = [asmins('POP', 'A'), asmins('MOV', X, 'A')]
.

visit(id(X), _, Code):- Code = [asmins('PUSH', X)]
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

visit(empty, _, _)
.


visit(C,_, Code):- concat('--->',C,Y), Code = [tag(Y)]
.

visitformal(id(X), vardecla(X))
.

visitList([], _, _).
visitList( [C], Data, Code) :- visit(C, Data, Code).
visitList( [X, Y | L], Data, Code) :- visit(X, Data1, Code1)
									  ,visitList([Y | L], Data2, Code2)
									  ,append(Data1, Data2, Data)
									  ,append(Code1, Code2, Code)
.
