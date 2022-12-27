initial_state(normal,[   [0,0,0,0,0,0],
                        [0,0,0,0,0,0],
                        [0,0,0,0,0,0],
                        [0,0,0,0,0,0],
                        [0,0,0,0,0,0]],12,12,whiteturn,1).

initial_state(big,[ [0,0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0,0]],22,22,whiteturn,1).

board_size(Board,Width,Height) :-
        length(Board, Height), 
        nth0(0,Board,Row),
        length(Row, Width).

get_original_pieces(Board,Pieces) :-
    board_size(Board,Width,_Height),
    Width =:= 6,!,
    Pieces is 12.

get_original_pieces(_,22).

switch_turns(whiteturn,blackturn).
switch_turns(blackturn,whiteturn).

turn_number(whiteturn,1).
turn_number(blackturn,2).

turn_option_into_board_size(1,normal).
turn_option_into_board_size(2,big).

select_board_size(0,1) :- !.
select_board_size(5,1) :- !.
select_board_size(_,BoardOption) :- 
        display_select_board_menu,
        read_until_between(1,2,BoardOption).

       
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
    board_size(Board,Width,_Height),
    NewWidth is Width - 1,
    X < NewWidth,
    X1 is X+1,
    value_is(X1,Y,Value,Board).

neighbor(X, Y, Board, Value) :-
    Y > 0,
    Y1 is Y - 1,
    value_is(X,Y1,Value,Board).

neighbor(X, Y, Board, Value) :-
    board_size(Board,_Width,Height),
    NewHeight is Height -1,
    Y < NewHeight,
    Y1 is Y + 1,
    value_is(X,Y1,Value,Board).

neighbor_diagonal(X, Y, Board, Value) :- %top left
    X > 0,
    Y > 0,
    X1 is X - 1,
    Y1 is Y - 1,
    get_value(X1,Y1,Value,Board).

neighbor_diagonal(X, Y, Board, Value) :- %top right
    board_size(Board,Width,_Height),
    NewWidth is Width - 1,
    X < NewWidth,
    Y > 0,
    X1 is X + 1,
    Y1 is Y - 1,
    get_value(X1,Y1,Value,Board).

neighbor_diagonal(X, Y, Board, Value) :- %bottom left
    board_size(Board,_Width,Height),
    NewHeight is Height -1,
    Y < NewHeight,
    X > 0,
    X1 is X - 1,
    Y1 is Y + 1,
    get_value(X1,Y1,Value,Board).

neighbor_diagonal(X, Y, Board, Value) :- %bottom right
    board_size(Board,Width,Height),
    NewWidth is Width - 1,
    NewHeight is Height -1,
    X < NewWidth,
    Y < NewHeight,
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

computer3_turn(whiteturn,computer3,_).
computer3_turn(blackturn,_,computer3).

turn_option_into_ai(1,computer1).
turn_option_into_ai(2,computer2).
turn_option_into_ai(3,computer3).

letter_to_number(0,"a").
letter_to_number(1,"b").
letter_to_number(2,"c").
letter_to_number(3,"d").
letter_to_number(4,"e").
letter_to_number(5,"f").
letter_to_number(6,"g").
letter_to_number(7,"h").
letter_to_number(8,"i").

last_X_elements(List,X,LastX) :-
    length(List, Length),
    ( Length < X ->
        LastX = List
    ;
        reverse(List, Reversed),
        length(LastX, X),
        append(LastX, _, Reversed)
    ).
   

same_value2([_]).
same_value2([Value1-_-_|T]) :-
    same_value2(T),
    T = [Value2-_-_|_],
    Value1 = Value2.

same_value4([_]).
same_value4([Value1-_-_-_-_|T]) :-
    same_value4(T),
    T = [Value2-_-_-_-_|_],
    Value1 = Value2.

same_value_as_last2(Elem, Last) :-
    Elem = Value-_-_,
    Last = Value-_-_.

same_value_as_last4(Elem, Last) :-
    Elem = Value-_-_-_-_,
    Last = Value-_-_-_-_.

get_all_of_high_value2(List,Result) :-  
    findall(Elem, (member(Elem, List), last(List, Last), same_value_as_last2(Elem, Last)), Result).

get_all_of_high_value4(List,Result) :-  
    findall(Elem, (member(Elem, List), last(List, Last), same_value_as_last4(Elem, Last)), Result).
