
:-['eightParser']
.



visit(eightProg(FL), eightProg(P)) :- !, visitList(FL, Data, Code) 
									   , append(Data, Code, P)
.

							
visit(fun(I, F, _), Data, Code) :- 	!, visit(funid, I, Code1)
									,visit(funData, I, Data1)
									,visit(F, Data2, _)
									%,visit(B, Data3, Code2)
									,append([Data1,Data2 ],Data)
									,append(Code1,[],Code) 
.

visit(funData, id(X), Data) :- !, concat(X,'_data', Z)
							   ,Data = [tag(Z)] 
.

visit(funid, id(X), Code) :- !, Code = [tag(X)] 
.

visit(formals(L), Data, _ ) :- !, maplist(visitformal, L , Data)
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


