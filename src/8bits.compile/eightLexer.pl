/*
EIF400 loriacarlos@gmail.com
*/

getTokens(Input, Tokens) :- extractTokens(Input, ExTokens), 
                            delete(ExTokens, [], Tokens)
.
extractTokens([], []) :- !.
extractTokens(Input, [Token | Tokens]) :-       skipWhiteSpace(Input, InputNWS),
                                                startOneToken(InputNWS, Token, Rest),
											    extractTokens(Rest, Tokens)
.
% Skip White Space
skipWhiteSpace([C | Input], Output) :- isWhiteSpace(C), !, 
                                       skipWhiteSpace(Input, Output)
.
skipWhiteSpace(Input, Input)
.
% START LEXING TOKEN
startOneToken(Input, Token, Rest) :- startOneToken(Input, [], Token, Rest)
.
startOneToken([], P, P, []).
startOneToken([C | Input], Partial, Token, Rest) :- isDigit(C), !,
                                                    finishNumber(Input, [ C | Partial], Token, Rest)
.

startOneToken([C | Input], Partial, Token, Rest) :- isLetter(C), !,
                                                    finishId(Input, [ C | Partial], Token, Rest)
.

startOneToken([C | Input], Partial, Token, Rest) :- isOper(C), !,
                                                    finishOper(Input, [ C | Partial], Token, Rest)
.
startOneToken([C | Input], Partial, Token, Rest) :- isQuote(C), !,
                                                    finishQuote(Input, [ C | Partial], Token, Rest)
.
startOneToken([C | _] , _, _, _) :- atom_codes(AC, [34, C, 34]), 
                                    atom_concat(AC, ' :invalid symbol found', Msg), 
									throw(Msg)
.
% NUMBER
finishNumber(Input, Partial, Token, Rest) :- finishToken(Input, isDigit, Partial, Token, Rest)
.
finishId(Input, Partial, Token, Rest) :- finishToken(Input, isLetter, Partial, Token, Rest)
.
% QUOTE
finishQuote([C | Input], Partial, Token, Input) :- isQuote(C), !,
                                                   convertToAtom([C | Partial], Token) 
.
finishQuote([C | Input], Partial, Token, Rest) :- finishQuote(Input, [C |Partial], Token, Rest)
.
finishQuote([] , _Partial, _Token, _Input) :- throw('opened and not closed string') 
.
% OPER
finishOper([C | Input], [PC | Partial], Token, Input) :- doubleOper(PC, C), !, 
                                                         convertToAtom([C, PC | Partial], Token) 
.
finishOper(Input, Partial, Token, Input) :- convertToAtom(Partial, Token) 
.
% TOKEN
finishToken([C | Input], Continue, Partial, Token, Rest) :- call(Continue, C), !, 
                                                            finishToken(Input, Continue, [ C | Partial], Token, Rest)
.

finishToken(Input, _, Partial, Token, Input) :- convertToAtom(Partial, Token) 
.



% CHARACTER CLASSES
isWhiteSpace(C) :- member(C, [9, 10, 13, 32])
.
isDigit(D)   :- D >= 48, D =< 57. % 0..9
isLetter(95) :- !. % _
isLetter(D)  :- D >=97, D =< 122, !. % a .. z
isLetter(D)  :- D >= 65, D =< 90.    % A .. Z

isQuote(34).
isOper(O)    :- O >= 40, O =< 46, !.              % ( ) * + , - . /
isOper(O)    :- member(O, [123, 124, 125, 33, 59, 61]), !. % { } ! ;

doubleOper(33, 61). % !=
doubleOper(61, 61). % ==
doubleOper(60, 61). % <=
doubleOper(62, 61). % >=

convertToAtom(Partial, Token) :- reverse(Partial, TokenCodes), 
                                 atom_codes(Token, TokenCodes)
.

tokenize(File, Tokens) :- open(File, read, Stream),
                          read_stream_to_codes(Stream, Input),
				          close(Stream),
                          getTokens(Input, Tokens)
.

testLexer(L) :- tokenize('../cases/test.8bit', L).
