% initial_state(+Size,+Board,+WhitePieces,+BlackPieces,+Turn,+Phase).
% +Size -> Size of the board (normal or big)
% +Board -> 2D list representing the board 
% +WhitePieces -> Number of starting white pieces
% +BlackPieces -> Number of starting black pieces
% +Turn -> Starting turn
% +Phase -> Starting phase
% Description : initializes the elements for the game
initial_state(normal,[  [0,0,0,0,0,0],
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

% board_size(+Board,-Width,-Height)
% +Board -> 2D list representing the board 
% -Width -> Width of the board
% -Height -> Height of the board
% Description : returns the width and height of the board
board_size(Board,Width,Height) :-
        length(Board, Height), 
        nth0(0,Board,Row),
        length(Row, Width).

% get_original_pieces(+Board,-Pieces)
% +Board -> 2D list representing the board 
% -Pieces -> Number of starting pieces
% Description : returns the number of initial pieces
get_original_pieces(Board,Pieces) :-
    board_size(Board,Width,_Height),
    Width =:= 6,!,
    Pieces is 12.

get_original_pieces(_,22).

% switch_turns(+CurrentTurn,-NextTurn)
% +CurrentTurn -> Current turn
% -NextTurn -> Next turn
% Description : switches turns
switch_turns(whiteturn,blackturn).
switch_turns(blackturn,whiteturn).

% switch_turns(+Turn,-Number)
% +Turn -> Current turn
% -Number -> Number representing the turn
% Description : returns the number that represent that turn
turn_number(whiteturn,1).
turn_number(blackturn,2).

% turn_option_into_board_size(+Option,-Size)
% +Option -> Option chosen
% -Size -> Size of the board (normal or big)
% Description : returns the size of the board accordingly to the option chosen
turn_option_into_board_size(1,normal).
turn_option_into_board_size(2,big).

% select_board_size(+Option,-BoardSizeOption)
% +Option -> Option chosen
% -BoardSizeOption -> Option representing the size of the board
% Description : if not exit or instructions ask the user for the size of the board
select_board_size(0,1) :- !.
select_board_size(5,1) :- !.
select_board_size(_,BoardOption) :- 
        display_select_board_menu,
        read_until_between(1,2,BoardOption).

% list_append(+List1,+List2,-ConcatList)
% +List1 -> First list
% +List2 -> Second list
% -ConcatList -> Concatenated list
% Description : concatenates 2 lists
list_append([], L, L).
list_append([H | T1], L2, [H | T2]) :-
    list_append(T1, L2, T2).

% list_append(+ListofLists,-FlatList)
% +ListofLists -> List of lists
% -FlatList -> Flatten list
% Description : turns a list of lists into a list
list_append([], []) :- !.
list_append([HL | T], OL) :-
    list_append(T, IL),
    list_append(HL, IL, OL).

% parse_move(+String,-X,-Y)
% +String -> String with the move to be made (ex:a2)
% -X -> X of the move
% -Y -> Y of the move
% Description : parses a string into a move
parse_move([L|[N|[]]],X,Y) :- X is L-97 , Y is N-49.

% parse_move(+String,-X,-Y,-NewX,-NewY)
% +String -> String with the move to be made (ex:a2d)
% -X -> X of the move
% -Y -> Y of the move
% -NewX -> NewX of the move
% -NewY -> NewY of the move
% Description : parses a string into a move
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

% replace(+X, +Y, +Value, +List, -NewList)
% +X -> X of the position
% +Y -> Y of the position
% +Value -> Value to replace with
% +List -> 2d list
% -NewList -> 2d List after replacement
% Description : replaces a number on the position (X,Y) of a 2d list with the value
replace(X, Y, Value, List, NewList) :-
    nth0(Y, List, Row),
    replace_in_list(X, Value, Row, NewRow),
    replace_in_list(Y, NewRow, List, NewList).

% replace_in_list(+Idx, +Value, +List, -NewList)
% +Idx -> Idx of the position
% +Value -> Value to replace with
% +List -> List
% -NewList -> List after replacement
% Description : replaces a number on the index Idx of a list with the value
replace_in_list(_, _, [], []).
replace_in_list(0, Value, [_|Tail], [Value|Tail]).
replace_in_list(Index, Value, [Head|Tail], [Head|Result]) :-
    Index > 0,
    NewIndex is Index - 1,
    replace_in_list(NewIndex, Value, Tail, Result).

% value_is(+X, +Y, +Value, +List)
% +X -> X of the position
% +Y -> Y of the position
% +Value -> Value to be checked
% +List -> 2d list
% Description : succeeds if the number on the position (X,Y) of the 2d list is the value
value_is(X, Y, Value, List) :-
    nth0(Y, List, Row),
    nth0(X, Row, Element),
    Element =:= Value.

% get_value(+X, +Y,+List,-Value)
% +X -> X of the position
% +Y -> Y of the position
% +List -> 2d list
% -Value -> Value of the position
% Description : returns the number on the position (X,Y) of the 2d list
get_value(X, Y, List,Value) :-
    nth0(Y, List, Row),
    nth0(X, Row, Element),
    Value is Element.

% neighbor(+X, +Y,+Board,+Value)
% +X -> X of the position
% +Y -> Y of the position
% +Board -> 2d list representing the board
% +Value -> Value of the position
% Description : succeeds if an orthogonal neighbour of the position (X,Y) of the 2d list is equal to the value
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

% neighbor_diagonal(+X, +Y,+Board,-Value)
% +X -> X of the position
% +Y -> Y of the position
% +Board -> 2d list representing the board
% -Value -> Value of the position
% Description : gets the value of the diagonal neighbours of the position (X,Y) of the 2d list
neighbor_diagonal(X, Y, Board, Value) :- %top left
    X > 0,
    Y > 0,
    X1 is X - 1,
    Y1 is Y - 1,
    get_value(X1,Y1,Board,Value).

neighbor_diagonal(X, Y, Board, Value) :- %top right
    board_size(Board,Width,_Height),
    NewWidth is Width - 1,
    X < NewWidth,
    Y > 0,
    X1 is X + 1,
    Y1 is Y - 1,
    get_value(X1,Y1,Board,Value).

neighbor_diagonal(X, Y, Board, Value) :- %bottom left
    board_size(Board,_Width,Height),
    NewHeight is Height -1,
    Y < NewHeight,
    X > 0,
    X1 is X - 1,
    Y1 is Y + 1,
    get_value(X1,Y1,Board,Value).

neighbor_diagonal(X, Y, Board, Value) :- %bottom right
    board_size(Board,Width,Height),
    NewWidth is Width - 1,
    NewHeight is Height -1,
    X < NewWidth,
    Y < NewHeight,
    X1 is X + 1,
    Y1 is Y + 1,
    get_value(X1,Y1,Board,Value).

% get_nr_of_neighbor_diagonal(+X, +Y,+Board,+Turn,-Number)
% +X -> X of the position
% +Y -> Y of the position
% +Board -> 2d list representing the board
% +Turn -> Number representing the current turn
% -Number -> Number of friendly diagonal neighbours
% Description : returns the number of friendly diagonal neighbours pieces of the position (X,Y) of the 2d list
get_nr_of_neighbor_diagonal(X,Y,Board,Turn,Number) :-
    findall(Value, (neighbor_diagonal(X, Y, Board, Value),Value=:=Turn,value_is(X,Y,Turn,Board)), Values),
    length(Values,Number).

% my_sublist(+L, +M, +N, -S)
% +L -> List
% +M -> Start index
% +N -> Last index
% -S -> Sublist
% Description : returns a sublist of a list
my_sublist(L, M, N, S) :-
    findall(E, (nth0(I, L, E), I >= M, I =< N), S).

% invert_indexs(+Pos,-InvPos)
% +Pos -> 3 in a row position(X-Y-Direction)
% -InvPos -> Position with inverted X and Y
% Description : inverts the X and Y of a 3 in a row position
invert_indexs(X-Y-D,Y-X-D).

% invert_columns_indexs(+Pos,-InvPos)
% +Pos -> List of positions of 3 in a row in columns
% -InvPos -> List of inverted positions
% Description : inverts the 3 in a row positions because of the transposed matrix for checking the columns
invert_columns_indexs([],[]).

invert_columns_indexs([Pos|Tail],Positions) :- invert_columns_indexs(Tail,NewPositions),
    										invert_indexs(Pos,NewPos),
    										Positions = [NewPos | NewPositions].

% deal_with_pieces_after_remove(+Turn,+WhitePieces,+BlackPieces,-NewWhitePieces,-NewBlackPieces)
% +Turn -> Starting turn
% +WhitePieces -> Number of white pieces before move
% +BlackPieces -> Number of black pieces before move
% -NewWhitePieces -> Number of white pieces after move
% -NewBlackPieces -> Number of black pieces after move
% Description : updates the number of pieces after a move
deal_with_pieces_after_remove(blackturn,WhitePieces,BlackPieces,NewWhitePieces,BlackPieces) :- NewWhitePieces is WhitePieces - 1.

deal_with_pieces_after_remove(whiteturn,WhitePieces,BlackPieces,WhitePieces,NewBlackPieces) :- NewBlackPieces is BlackPieces - 1.

% human_turn(+Turn,+WhitePlayer,+BlackPlayer)
% +Turn -> Current turn
% +WhitePlayer -> Indicates if the white player is human or computer
% +BlackPlayer -> Indicates if the black player is human or computer
% Description : succeeds if it is a human turn
human_turn(whiteturn,human,_).
human_turn(blackturn,_,human).

% computer1_turn(+Turn,+WhitePlayer,+BlackPlayer)
% +Turn -> Current turn
% +WhitePlayer -> Indicates if the white player is human or computer
% +BlackPlayer -> Indicates if the black player is human or computer
% Description : succeeds if it is a computer level 1 AI turn
computer1_turn(whiteturn,computer1,_).
computer1_turn(blackturn,_,computer1).

% computer2_turn(+Turn,+WhitePlayer,+BlackPlayer)
% +Turn -> Current turn
% +WhitePlayer -> Indicates if the white player is human or computer
% +BlackPlayer -> Indicates if the black player is human or computer
% Description : succeeds if it is a computer level 2 AI turn
computer2_turn(whiteturn,computer2,_).
computer2_turn(blackturn,_,computer2).

% computer3_turn(+Turn,+WhitePlayer,+BlackPlayer)
% +Turn -> Current turn
% +WhitePlayer -> Indicates if the white player is human or computer
% +BlackPlayer -> Indicates if the black player is human or computer
% Description : succeeds if it is a computer level 3 AI turn
computer3_turn(whiteturn,computer3,_).
computer3_turn(blackturn,_,computer3).

% turn_option_into_ai(+Option,-AI)
% +Option -> Option chosen
% -AI -> AI player with level 1, 2 or 3
% Description : returns a computer player with level accordingly to the option chosen
turn_option_into_ai(1,computer1).
turn_option_into_ai(2,computer2).
turn_option_into_ai(3,computer3).

% letter_to_number(+Number,-Letter)
% +Number -> Number of the column
% -Letter -> Corresponding letter
% Description : transforms a number representing the index on the board with the corresponding letter
letter_to_number(0,"a").
letter_to_number(1,"b").
letter_to_number(2,"c").
letter_to_number(3,"d").
letter_to_number(4,"e").
letter_to_number(5,"f").
letter_to_number(6,"g").
letter_to_number(7,"h").
letter_to_number(8,"i").

% last_X_elements(+List,+X,-LastX)
% +List -> List of elements
% +X -> Number of elements to return
% -LastX -> List with X number of elements from the end of the list
% Description : returns the last X elements of a list
last_X_elements(List,X,LastX) :-
    length(List, Length),
    ( Length < X ->
        LastX = List
    ;
        reverse(List, Reversed),
        length(LastX, X),
        append(LastX, _, Reversed)
    ).

% same_value2(+ListMoves)
% +ListMoves -> List of moves of the type Value-X-Y
% Description : succeeds if the moves have all the same value
same_value2([_]).
same_value2([Value1-_-_|T]) :-
    same_value2(T),
    T = [Value2-_-_|_],
    Value1 = Value2.

% same_value4(+ListMoves)
% +ListMoves -> List of moves of the type Value-X-Y-NewX-NewY
% Description : succeeds if the moves have all the same value
same_value4([_]).
same_value4([Value1-_-_-_-_|T]) :-
    same_value4(T),
    T = [Value2-_-_-_-_|_],
    Value1 = Value2.

% same_value_as_last2(+Elem,+LastElem)
% +Elem -> Element of a list of moves of the type Value-X-Y
% +LastElem -> Last element of a list of moves of the type Value-X-Y
% Description : succeeds if the move has the same value as the highest value move(last)
same_value_as_last2(Elem, Last) :-
    Elem = Value-_-_,
    Last = Value-_-_.

% same_value_as_last4(+Elem,+LastElem)
% +Elem -> Element of a list of moves of the type Value-X-Y-NewX-NewY
% +LastElem -> Last element of a list of moves of the type Value-X-Y-NewX-NewY
% Description : succeeds if the move has the same value as the highest value move(last)
same_value_as_last4(Elem, Last) :-
    Elem = Value-_-_-_-_,
    Last = Value-_-_-_-_.

% get_all_of_high_value2(+List,-Result)
% +List -> List of moves of the type Value-X-Y
% -Result -> List of the best moves
% Description : returns a list of the best value moves
get_all_of_high_value2(List,Result) :-  
    findall(Elem, (member(Elem, List), last(List, Last), same_value_as_last2(Elem, Last)), Result).

% get_all_of_high_value4(+List,-Result)
% +List -> List of moves of the type Value-X-Y-NewX-NewY
% -Result -> List of the best moves
% Description : returns a list of the best value moves
get_all_of_high_value4(List,Result) :-  
    findall(Elem, (member(Elem, List), last(List, Last), same_value_as_last4(Elem, Last)), Result).
