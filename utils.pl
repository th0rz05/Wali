initial_state([ [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0]],3,3,whiteturn,1).

display_piece(0) :- put_code(32).

display_piece(1) :- put_code(9312).

display_piece(2) :- put_code(10103).

switch_turns(whiteturn,blackturn).
switch_turns(blackturn,whiteturn).

parse_move([L|[N|[]]],X,Y) :- X is L-97 , Y is N-49.

%up
parse_move([L|[N|[117|[]]]],X,Y,NewX,NewY) :- X is L-97 ,
                                             Y is N-49,
                                             NewX is X,
                                             NewY is Y -1.

%down
parse_move([L|[N|[100|[]]]],X,Y,NewX,NewY) :- X is L-97 ,
                                             Y is N-49,
                                             NewX is X,
                                             NewY is Y + 1.

%left
parse_move([L|[N|[108|[]]]],X,Y,NewX,NewY) :- X is L-97 ,
                                             Y is N-49,
                                             NewX is X -1 ,
                                             NewY is Y.

%right
parse_move([L|[N|[114|[]]]],X,Y,NewX,NewY) :- X is L-97 ,
                                             Y is N-49,
                                             NewX is X +1 ,
                                             NewY is Y.

press_any_key_to_continue :-
    print_banner("PHASE 2 STARTING",*, 7),nl,nl,nl,
    write('Press Enter to continue...'),
    get_char(_).


replace(X, Y, Value, List, NewList) :-
    nth0(Y, List, Row),
    replace_in_list(X, Value, Row, NewRow),
    replace_in_list(Y, NewRow, List, NewList).

replace_in_list(_, _, [], []).
replace_in_list(0, Value, [_|Tail], [Value|Tail]).
replace_in_list(Index, Value, [Head|Tail], [Head|Result]) :-
    Index > 0,
    NewIndex is Index - 1,
    replace_in_list(NewIndex, Value, Tail, Result).

value_is(X, Y, Value, List) :-
    nth0(Y, List, Row),
    nth0(X, Row, Element),
    Element =:= Value.

neighbor(X, Y, Board, Value) :-
   X > 0,
   X1 is X - 1,
   value_is(X1,Y,Value,Board).
neighbor(X, Y, Board, Value) :-
   X < 5,
   X1 is X+1,
   value_is(X1,Y,Value,Board).
neighbor(X, Y, Board, Value) :-
   Y > 0,
   Y1 is Y - 1,
   value_is(X,Y1,Value,Board).
neighbor(X, Y, Board, Value) :-
   Y < 4,
   Y1 is Y + 1,
   value_is(X,Y1,Value,Board).

