initial_state([ [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0]],12,12,whiteturn,1).


display_piece(0) :- put_code(32).

display_piece(1) :- put_code(9312).

display_piece(2) :- put_code(10103).

switch_turns(whiteturn,blackturn).
switch_turns(blackturn,whiteturn).

turn_number(whiteturn,1).
turn_number(blackturn,2).

list_append([], L, L).
list_append([H | T1], L2, [H | T2]) :-
    list_append(T1, L2, T2).

list_append([], []) :- !.
list_append([HL | T], OL) :-
    list_append(T, IL),
    list_append(HL, IL, OL).

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

press_any_key_to_continue(phase2) :-
    print_banner("NO MOVES POSSIBLE",*, 7),nl,nl,nl,
    print_banner("PHASE 2 STARTING",*, 7),nl,nl,nl,
    write('Press ENTER to continue...'),
    get_char(_).

press_any_key_to_continue(pass) :-
    print_banner("NO MOVES POSSIBLE",*, 7),nl,nl,nl,
    write('Press ENTER to PASS...'),
    get_char(_).

congratulate_winner(white) :- print_banner("WINNER!! CONGRATULATIONS WHITE",*, 7),nl,nl.

congratulate_winner(black) :- print_banner("WINNER!! CONGRATULATIONS BLACK",*, 7),nl,nl.

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


my_sublist(L, M, N, S) :-
    findall(E, (nth0(I, L, E), I >= M, I =< N), S).

empty([[]|T]):- empty(T).
empty([[]]).

first([[P|A]|R], [P|Ps], [A|As]):- first(R, Ps, As).
first([], [], []).


invert_indexs(X-Y-D,Y-X-D).

invert_columns_indexs([],[]).

invert_columns_indexs([Pos|Tail],Positions) :- invert_columns_indexs(Tail,NewPositions),
    										invert_indexs(Pos,NewPos),
    										Positions = [NewPos | NewPositions].


deal_with_pieces_after_remove(blackturn,WhitePieces,BlackPieces,NewWhitePieces,BlackPieces) :- NewWhitePieces is WhitePieces - 1.

deal_with_pieces_after_remove(whiteturn,WhitePieces,BlackPieces,WhitePieces,NewBlackPieces) :- NewBlackPieces is BlackPieces - 1.