initial_state([ [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0]],4,4,whiteturn,1).


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

press_any_key_to_continue(ai_place,MoveX,MoveY) :-
    write('Computer will place a piece in '),
    display_move(MoveX,MoveY),nl,
    write('Press ENTER to CONTINUE...'),
    get_char(_).

press_any_key_to_continue(ai_remove,MoveX,MoveY) :-
    write('Computer will remove the piece from '),
    display_move(MoveX,MoveY),nl,
    write('Press ENTER to CONTINUE...'),
    get_char(_).

press_any_key_to_continue(ai_move,MoveX,MoveY,NewX,NewY) :-
    write('Computer will make the move '),
    display_move(MoveX,MoveY),write(' to '),display_move(NewX,NewY),nl,
    write('Press ENTER to CONTINUE...'),
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

get_value(X, Y, Value, List) :-
    nth0(Y, List, Row),
    nth0(X, Row, Element),
    Value is Element.

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

neighbor_diagonal(X, Y, Board, Value) :- %top left
   X > 0,
   Y > 0,
   X1 is X - 1,
   Y1 is Y - 1,
   get_value(X1,Y1,Value,Board).
neighbor_diagonal(X, Y, Board, Value) :- %top right
   X < 5,
   Y > 0,
   X1 is X + 1,
   Y1 is Y - 1,
   get_value(X1,Y1,Value,Board).
neighbor_diagonal(X, Y, Board, Value) :- %bottom left
   X > 0,
   Y < 4,
   X1 is X - 1,
   Y1 is Y + 1,
   get_value(X1,Y1,Value,Board).
neighbor_diagonal(X, Y, Board, Value) :- %bottom right
   X < 5,
   Y < 4,
   X1 is X + 1,
   Y1 is Y + 1,
   get_value(X1,Y1,Value,Board).

get_nr_of_neighbor_diagonal(X,Y,Board,Turn,Number) :-
    findall(Value, (neighbor_diagonal(X, Y, Board, Value),Value=:=Turn,value_is(X,Y,Turn,Board)), Values),
    length(Values,Number).

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


human_turn(whiteturn,human,_).
human_turn(blackturn,_,human).

computer1_turn(whiteturn,computer1,_).
computer1_turn(blackturn,_,computer1).

computer2_turn(whiteturn,computer2,_).
computer2_turn(blackturn,_,computer2).

turn_option_into_ai(1,computer1).
turn_option_into_ai(2,computer2).

letter_to_number(0,'a').
letter_to_number(1,'b').
letter_to_number(2,'c').
letter_to_number(3,'d').
letter_to_number(4,'e').
letter_to_number(5,'f').


last_X_elements(List,X,LastX) :-
    length(List, Length),
    ( Length < X ->
        LastX = List
    ;
        reverse(List, Reversed),
        length(LastX, X),
        append(LastX, _, Reversed)
    ).
   