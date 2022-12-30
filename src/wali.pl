%consult('/Users/tiagobarbosa05/Documents/Wali_PFL_FEUP/src/wali.pl').
%consult('/Users/guilhermealmeida/FEUP - MIEIC/3ºano/PFL/Wali_PFL_FEUP/src/wali.pl').

:- [utils].
:- [output].
:- [input].
:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(random)).

% play
% Description : starts the wali game
play :-
    display_start_menu,
    read_until_between(0,5,GameOption),
    select_board_size(GameOption,BoardOption),
    turn_option_into_board_size(BoardOption,Size),
    initial_state(Size,InitialBoard,WhitePieces,BlackPieces,Turn,Phase),
    play_game(GameOption,InitialBoard,WhitePieces,BlackPieces,Turn,Phase).

% play_game(+GameOption,+Board,+WhitePieces,+BlackPieces,+Turn,+Phase)
% +GameOption -> 0 to 5 indicating (H/H, H/PC, PC/H, PC/PC,Instructions,Exit)
% +Board -> 2D list representing the board 
% +WhitePieces -> Number of starting white pieces
% +BlackPieces -> Number of starting black pieces
% +Turn -> Starting turn
% +Phase -> Starting phase
% Description : starts the game with specific definitions  
play_game(1,Board,WhitePieces,BlackPieces,Turn,Phase) :- 
                        display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase,human,human).

play_game(2,Board,WhitePieces,BlackPieces,Turn,Phase) :- 
                        display_select_difficulty_menu(black),
                        read_until_between(1,3,Option),
                        turn_option_into_ai(Option,AI),
                        display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase,human,AI).

play_game(3,Board,WhitePieces,BlackPieces,Turn,Phase) :- 
                        display_select_difficulty_menu(white),
                        read_until_between(1,3,Option),
                        turn_option_into_ai(Option,AI),
                        display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase,AI,human).

play_game(4,Board,WhitePieces,BlackPieces,Turn,Phase) :- 
                        display_select_difficulty_menu(white),
                        read_until_between(1,3,OptionWhite),
                        turn_option_into_ai(OptionWhite,AIWhite),
                        display_select_difficulty_menu(black),
                        read_until_between(1,3,OptionBlack),
                        turn_option_into_ai(OptionBlack,AIBlack),
                        display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase,AIWhite,AIBlack).

play_game(5,_,_,_,_,_) :-   display_instructions,
                            read_until_between(0,0,_),
                            play.
                          
play_game(0,_,_,_,_,_).

% game_cycle(+Board,+WhitePieces,+BlackPieces,+Turn,+Phase,+WhitePlayer,+BlackPlayer)
% +Board -> 2D list representing the current board
% +WhitePieces -> Number of current white pieces
% +BlackPieces -> Number of current black pieces
% +Turn -> Current turn
% +Phase -> Current phase
% +WhitePlayer -> Indicates if the white player is human or computer
% +BlackPlayer -> Indicates if the black player is human or computer
% Description : does a game cycle and changes the state of the game
game_cycle(Board,WhitePieces,BlackPieces,Turn,1,WhitePlayer,BlackPlayer) :- 
                        go_to_phase2(Board,WhitePieces,BlackPieces,Turn),!,
                        press_any_key_to_continue(phase2),
                        get_original_pieces(Board,Original),
                        NewWhitePieces is Original-WhitePieces,
                        NewBlackPieces is Original-BlackPieces,
                        display_game(Board,NewWhitePieces,NewBlackPieces,Turn,2),
                        game_cycle(Board,NewWhitePieces,NewBlackPieces,Turn,2,WhitePlayer,BlackPlayer).

game_cycle(Board,WhitePieces,BlackPieces,Turn,1,WhitePlayer,BlackPlayer) :- 
                        pass_place_piece(Board,WhitePieces,BlackPieces,Turn),!,
                        press_any_key_to_continue(pass),
                        switch_turns(Turn,NewTurn),
                        display_game(Board,WhitePieces,BlackPieces,NewTurn,1),
                        game_cycle(Board,WhitePieces,BlackPieces,NewTurn,1,WhitePlayer,BlackPlayer).                                                  

game_cycle(Board,WhitePieces,BlackPieces,Turn,1,WhitePlayer,BlackPlayer) :- 
                        choose_place_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY),
                        place_piece(Board,MoveX,MoveY,Turn,NewBoard),
                        handle_pieces(WhitePieces,BlackPieces,Turn,WhitePieces1,BlackPieces1),
                        switch_turns(Turn,NewTurn),
                        display_game(NewBoard,WhitePieces1,BlackPieces1,NewTurn,1),
                        game_cycle(NewBoard,WhitePieces1,BlackPieces1,NewTurn,1,WhitePlayer,BlackPlayer).

game_cycle(Board,WhitePieces,BlackPieces,_,2,_,_) :-    
                        game_over(Board,WhitePieces,BlackPieces,Winner),!,
                        congratulate_winner(Winner).

game_cycle(Board,WhitePieces,BlackPieces,Turn,2,WhitePlayer,BlackPlayer) :- 
                        choose_move_piece(Board,Turn,WhitePlayer,BlackPlayer,X,Y,NewX,NewY),
                        move_piece(Board,X,Y,NewX,NewY,Turn,NewBoard),
                        new_3_in_a_row(Board,NewBoard,Turn,WhitePieces,BlackPieces,WhitePlayer,BlackPlayer,FinalBoard,NewWhitePieces,NewBlackPieces),
                        switch_turns(Turn,NewTurn),
                        display_game(FinalBoard,NewWhitePieces,NewBlackPieces,NewTurn,2),
                        game_cycle(FinalBoard,NewWhitePieces,NewBlackPieces,NewTurn,2,WhitePlayer,BlackPlayer).

% game_over(+Board,+WhitePieces,+BlackPieces,-Winner)
% +Board -> 2D list representing the current board
% +WhitePieces -> Number of current white pieces
% +BlackPieces -> Number of current black pieces
% -Winner -> Who was won the game
% Description : see if the game is over and indicates the winner
game_over(_,2,_,black).

game_over(_,_,2,white).

% choose_place_piece(+Board,+Turn,+WhitePlayer,+BlackPlayer,-MoveX,-MoveY)
% +Board -> 2D list representing the current board
% +Turn -> Current turn
% +WhitePlayer -> Indicates if the white player is human or computer
% +BlackPlayer -> Indicates if the black player is human or computer
% -MoveX -> X of the spot to place the piece
% -MoveY -> Y of the spot to place the piece
% Description : choose the spot to place the next piece
choose_place_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY) :- 
                        human_turn(Turn,WhitePlayer,BlackPlayer),!,
                        repeat,
                        read_move(place,MoveX,MoveY),
                        validate_place_piece(Board,MoveX,MoveY,Turn),!.

choose_place_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY) :- 
                        computer1_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_place_piece_moves(Board,Turn,Moves),
                        random_member(MoveX-MoveY,Moves),
                        press_any_key_to_continue(ai_place,MoveX,MoveY).

choose_place_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY) :- 
                        computer2_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_place_piece_moves(Board,Turn,Moves),
                        setof(Value-MvX-MvY, NewBoard^( member(MvX-MvY, Moves),place_piece(Board,MvX,MvY,Turn,NewBoard),value(place,NewBoard,Turn,Value)),ValueMoves),
                        get_best_place_piece(ValueMoves,3,_Value,MoveX,MoveY),
                        press_any_key_to_continue(ai_place,MoveX,MoveY).

choose_place_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY) :- 
                        computer3_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_place_piece_moves(Board,Turn,Moves),
                        setof(Value-MvX-MvY, NewBoard^( member(MvX-MvY, Moves),place_piece(Board,MvX,MvY,Turn,NewBoard),value(place,NewBoard,Turn,Value)),ValueMoves),
                        get_best_place_piece(ValueMoves,1,_Value,MoveX,MoveY),
                        press_any_key_to_continue(ai_place,MoveX,MoveY).

% choose_move_piece(+Board,+Turn,+WhitePlayer,+BlackPlayer,-MoveX,-MoveY,-NewX,-NewY)
% +Board -> 2D list representing the current board
% +Turn -> Current turn
% +WhitePlayer -> Indicates if the white player is human or computer
% +BlackPlayer -> Indicates if the black player is human or computer
% -MoveX -> X of the spot of the piece to move
% -MoveY -> Y of the spot of the piece to move
% -NewX -> X of the new spot of the piece
% -NewY -> X of the new spot of the piece
% Description : choose a piece and where to move it
choose_move_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY,NewX,NewY) :- 
                        human_turn(Turn,WhitePlayer,BlackPlayer),!,
                        repeat,
                        read_move(MoveX,MoveY,NewX,NewY),
                        validate_move_piece(Board,MoveX,MoveY,NewX,NewY,Turn),!.

choose_move_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY,NewX,NewY) :- 
                        computer1_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_move_piece_moves(Board,Turn,Moves),
                        random_member(MoveX-MoveY-NewX-NewY,Moves),
                        press_any_key_to_continue(ai_move,MoveX,MoveY,NewX,NewY).

choose_move_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY,NewX,NewY) :- 
                        computer2_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_move_piece_moves(Board,Turn,Moves),
                        setof(Value-MvX-MvY-NewX-NewY, NewBoard^( member(MvX-MvY-NewX-NewY, Moves),move_piece(Board,MvX,MvY,NewX,NewY,Turn,NewBoard),value(move,Board,NewBoard,Turn,Value)),ValueMoves),
                        get_best_move_piece(ValueMoves,3,_Value,MoveX,MoveY,NewX,NewY),
                        press_any_key_to_continue(ai_move,MoveX,MoveY,NewX,NewY).

choose_move_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY,NewX,NewY) :- 
                        computer3_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_move_piece_moves(Board,Turn,Moves),
                        setof(Value-MvX-MvY-NewX-NewY, NewBoard^( member(MvX-MvY-NewX-NewY, Moves),move_piece(Board,MvX,MvY,NewX,NewY,Turn,NewBoard),value(move,Board,NewBoard,Turn,Value)),ValueMoves),
                        get_best_move_piece(ValueMoves,1,_Value,MoveX,MoveY,NewX,NewY),
                        press_any_key_to_continue(ai_move,MoveX,MoveY,NewX,NewY).

% choose_remove_piece(+Board,+Turn,+WhitePlayer,+BlackPlayer,-MoveX,-MoveY)
% +Board -> 2D list representing the current board
% +Turn -> Current turn
% +WhitePlayer -> Indicates if the white player is human or computer
% +BlackPlayer -> Indicates if the black player is human or computer
% -MoveX -> X of the spot of the piece to remove
% -MoveY -> Y of the spot of the piece to remove
% Description : choose the spot of the piece to remove
choose_remove_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY) :- 
                        human_turn(Turn,WhitePlayer,BlackPlayer),!,
                        repeat,
                        read_move(remove,MoveX,MoveY),
                        validate_remove_piece(Board,MoveX,MoveY,Turn),!.

choose_remove_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY) :- 
                        computer1_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_remove_piece_moves(Board,Turn,Moves),
                        random_member(MoveX-MoveY,Moves),
                        press_any_key_to_continue(ai_remove,MoveX,MoveY).

choose_remove_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY) :- 
                        computer2_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_remove_piece_moves(Board,Turn,Moves),
                        setof(Value-MvX-MvY, NewBoard^( member(MvX-MvY, Moves),remove_piece(Board,MvX,MvY,NewBoard),value(remove,NewBoard,Turn,Value)),ValueMoves),
                        get_best_remove_piece(ValueMoves,3,Value,MoveX,MoveY),
                        press_any_key_to_continue(ai_remove,MoveX,MoveY).

choose_remove_piece(Board,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY) :- 
                        computer3_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_remove_piece_moves(Board,Turn,Moves),
                        setof(Value-MvX-MvY, NewBoard^( member(MvX-MvY, Moves),remove_piece(Board,MvX,MvY,NewBoard),value(remove,NewBoard,Turn,Value)),ValueMoves),
                        get_best_remove_piece(ValueMoves,1,Value,MoveX,MoveY),
                        press_any_key_to_continue(ai_remove,MoveX,MoveY).

% no_more_valid_place_piece_moves(+Board)
% +Board -> 2D list representing the current board
% Description : succeeds if there is no more valid spot to place a piece
no_more_valid_place_piece_moves(Board) :- no_turn_place_piece_moves(Board,whiteturn),
                                          no_turn_place_piece_moves(Board,blackturn).

% no_turn_place_piece_moves(+Board,+Turn)
% +Board -> 2D list representing the current board
% +Turn -> Current turn
% Description : succeeds if there is no more valid spot to place a piece for a specific turn
no_turn_place_piece_moves(Board,Turn) :- valid_place_piece_moves(Board,Turn,Moves),
                                        length(Moves,0).

% valid_place_piece_moves(+Board,+Turn,-Moves)
% +Board -> 2D list representing the current board
% +Turn -> Current turn
% -Moves -> List of possible moves
% Description : returns a list of the possible place moves
valid_place_piece_moves(Board,Turn,Moves):- findall(X-Y, validate_place_piece(Board,X,Y,Turn), Moves).%write(Moves).

% valid_move_piece_moves(+Board,+Turn,-Moves)
% +Board -> 2D list representing the current board
% +Turn -> Current turn
% -Moves -> List of possible moves
% Description : returns a list of the possible moves
valid_move_piece_moves(Board,Turn,Moves):- findall(X-Y-NewX-NewY, validate_move_piece(Board,X,Y,NewX,NewY,Turn), Moves).%write(Moves).

% valid_remove_piece_moves(+Board,+Turn,-Moves)
% +Board -> 2D list representing the current board
% +Turn -> Current turn
% -Moves -> List of possible moves
% Description : returns a list of the possible removes
valid_remove_piece_moves(Board,Turn,Moves):- findall(X-Y, validate_remove_piece(Board,X,Y,Turn), Moves).%write(Moves).

% validate_place_piece(+Board,+X,+Y,+Turn)
% +Board -> 2D list representing the current board
% +X -> X of the spot to place the piece
% +Y -> Y of the spot to place the piece
% +Turn -> Current turn
% Description : succeeds if the place move is valid
validate_place_piece(Board,X,Y,Turn) :-
    board_size(Board,Width,Height),
    NewWidth is Width - 1,
    NewHeight is Height -1,
    between(0, NewWidth, X),
    between(0, NewHeight, Y), 
    not_occupied(Board,X,Y), 
    no_neighbours(Board,X,Y,Turn). 

% validate_remove_piece(+Board,+X,+Y,+Turn)
% +Board -> 2D list representing the current board
% +X -> X of the spot of the piece to remove
% +Y -> Y of the spot of the piece to remove
% +Turn -> Current turn
% Description : succeeds if the remove is valid
validate_remove_piece(Board,X,Y,Turn) :-
    board_size(Board,Width,Height),
    NewWidth is Width - 1,
    NewHeight is Height -1,
    between(0, NewWidth, X),
    between(0, NewHeight, Y), 
    has_enemy(Board,X,Y,Turn). 

% validate_move_piece(+Board,+X,+Y,+NewX,+NewY,+Turn)
% +Board -> 2D list representing the current board
% +X -> X of the spot of the piece to move
% +Y -> Y of the spot of the piece to move
% +NewX -> X of the new spot of the piece
% +NewY -> Y of the new spot of the piece
% +Turn -> Current turn
% Description : succeeds if the move is valid
validate_move_piece(Board,X,Y,NewX,NewY,Turn) :- 
    board_size(Board,Width,Height),
    NewWidth is Width - 1,
    NewHeight is Height -1,
    between(0, NewWidth, X),
    between(0, NewHeight, Y),
    has_piece(Board,X,Y,Turn),
    between(0, NewWidth, NewX),
    DiffX is NewX-X,
    between(-1, 1, DiffX),
    between(0, NewHeight, NewY),
    DiffY is NewY-Y,
    between(-1, 1, DiffY),
    (DiffX=:=0;DiffY=:=0),
    not_occupied(Board,NewX,NewY).

% has_piece(+Board,+X,+Y,+Turn)
% +Board -> 2D list representing the current board
% +X -> X of the spot of the board
% +Y -> Y of the spot of the board
% +Turn -> Current turn
% Description : succeeds if the spot has a piece of the current player
has_piece(Board,X,Y,whiteturn) :- value_is(X, Y, 1, Board).

has_piece(Board,X,Y,blackturn) :- value_is(X, Y, 2, Board).

% has_enemy(+Board,+X,+Y,+Turn)
% +Board -> 2D list representing the current board
% +X -> X of the spot of the board
% +Y -> Y of the spot of the board
% +Turn -> Current turn
% Description : succeeds if the spot has an enemy piece of the current player
has_enemy(Board,X,Y,whiteturn) :- value_is(X, Y, 2, Board).

has_enemy(Board,X,Y,blackturn) :- value_is(X, Y, 1, Board).

% not_occupied(+Board,+X,+Y)
% +Board -> 2D list representing the current board
% +X -> X of the spot of the board
% +Y -> Y of the spot of the board
% Description : succeeds if the spot has no piece
not_occupied(Board,X,Y) :- value_is(X, Y, 0, Board).

% no_neighbours(+Board,+X,+Y,+Turn)
% +Board -> 2D list representing the current board
% +X -> X of the spot of the board
% +Y -> Y of the spot of the board
% +Turn -> Current turn
% Description : succeeds if the spot has no neighbour friend pieces
no_neighbours(Board,X,Y,whiteturn) :- \+ neighbor(X, Y, Board, 1).

no_neighbours(Board,X,Y,blackturn) :- \+ neighbor(X, Y, Board, 2).

% handle_pieces(+WhitePieces,+BlackPieces,+Turn,-NewWhitePieces,-NewBlackPieces)
% +WhitePieces -> Number of current white pieces
% +BlackPieces -> Number of current black pieces
% +Turn -> Current turn
% -NewWhitePieces -> Number of new white pieces
% -NewBlackPieces -> Number of new black pieces
% Description : updates the number of the specific turn pieces
handle_pieces(WhitePieces,BlackPieces,whiteturn,NewWhitePieces,NewBlackPieces) :- NewWhitePieces is WhitePieces-1,NewBlackPieces is BlackPieces.

handle_pieces(WhitePieces,BlackPieces,blackturn,NewWhitePieces,NewBlackPieces) :- NewBlackPieces is BlackPieces-1,NewWhitePieces is WhitePieces.

% place_piece(+Board,+X,+Y,+Turn,-NewBoard)
% +Board -> 2D list representing the current board
% +X -> X of the spot to place the piece
% +Y -> Y of the spot to place the piece
% +Turn -> Current turn
% -NewBoard -> 2D list representing the board after the place move
% Description : places a piece of a specific turn on a spot of the board
place_piece(Board,X,Y,whiteturn,NewBoard) :- replace(X,Y,1,Board,NewBoard).

place_piece(Board,X,Y,blackturn,NewBoard) :- replace(X,Y,2,Board,NewBoard).

% remove_piece(+Board,+X,+Y,-NewBoard)
% +Board -> 2D list representing the current board
% +X -> X of the spot of the piece to remove
% +Y -> X of the spot of the piece to remove
% -NewBoard -> 2D list representing the board after the remove
% Description : removes a piece of the board
remove_piece(Board,X,Y,NewBoard) :- replace(X,Y,0,Board,NewBoard).

remove_piece(Board,X,Y,NewBoard) :- replace(X,Y,0,Board,NewBoard).

% move_piece(+Board,+X,+Y,+NewX,+NewY,+Turn,-NewBoard)
% +Board -> 2D list representing the current board
% +X -> X of the spot of the piece to move
% +Y -> X of the spot of the piece to move
% +NewX -> X of the new spot of the piece
% +NewY -> Y of the new spot of the piece
% +Turn -> Current turn
% -NewBoard -> 2D list representing the board after the move
% Description : moves a piece of a specific turn on the board
move_piece(Board,X,Y,NewX,NewY,whiteturn,NewBoard) :- replace(X,Y,0,Board,TempBoard),
                                                      replace(NewX,NewY,1,TempBoard,NewBoard).

move_piece(Board,X,Y,NewX,NewY,blackturn,NewBoard) :- replace(X,Y,0,Board,TempBoard),
                                                      replace(NewX,NewY,2,TempBoard,NewBoard).


% go_to_phase2(+Board,+WhitePieces,+BlackPieces,+Turn)
% +Board -> 2D list representing the current board
% +WhitePieces -> Number of current white pieces
% +BlackPieces -> Number of current black pieces
% +Turn -> Current turn
% Description : succeeds if phase1 is over
go_to_phase2(_,0,0,_).%os dois sem peças

%os dois sem moves
go_to_phase2(Board,_,_,_) :- no_more_valid_place_piece_moves(Board).

%um sem moves e outro sem peças
go_to_phase2(Board,0,_,blackturn) :- no_turn_place_piece_moves(Board,blackturn).
go_to_phase2(Board,_,0,whiteturn) :- no_turn_place_piece_moves(Board,whiteturn).

% pass_place_piece(+Board,+WhitePieces,+BlackPieces,+Turn)
% +Board -> 2D list representing the current board
% +WhitePieces -> Number of current white pieces
% +BlackPieces -> Number of current black pieces
% +Turn -> Current turn
% Description : succeeds if there is no moves possible and current player needs to pass                                                                                        
pass_place_piece(_,0,_,whiteturn).%sem peças

pass_place_piece(_,_,0,blackturn).%sem peças

%sem moves
pass_place_piece(Board,_,_,Turn) :- no_turn_place_piece_moves(Board,Turn).

% three_in_a_row(+Number,+List)
% +Number -> Number composing the 3 in a row 
% +List -> List of 3 or 4 numbers
% Description : succeeds if the list has exaclty 3 of the Number in a row
three_in_a_row(Nr,[Nr,Nr,Nr,Dif|[]]) :- Nr \= Dif.

three_in_a_row(Nr,[Nr,Nr,Nr|[]]).

% check_for_3_in_a_row(+Number,+List,+Previous,+Position,+Direction,+Column,-Positions)
% +Number -> Number composing the 3 in a row
% +List -> List of numbers
% +Previous -> Previous number to check if its different from 3 in a row
% +Position -> Current position
% +Direction -> 3 in a row direction (h or v)
% +Column -> Current column
% -Positions -> List of positions of the 3 in a row
% Description : checks a list for 3 in a rows and returns their positions in a list
check_for_3_in_a_row(_,List,_,Position,_,_,[]) :- length(List,Size),
    									MaxPosition is Size-2,
    									Position =:= MaxPosition.

check_for_3_in_a_row(Number,List,Number,Position,Direction,Column,Positions) :- nth0(Position, List, Element),
    												NewPosition is Position + 1 ,
    												check_for_3_in_a_row(Number,List,Element,NewPosition,Direction,Column,NewPositions),
    												Positions = NewPositions.

check_for_3_in_a_row(Number,List,_Diff,Position,Direction,Column,Positions) :-  UpperBound is Position+3,
    												my_sublist(List,Position,UpperBound, Sublist),
    												nth0(Position, List, Element),
    												NewPosition is Position + 1 ,
    												check_for_3_in_a_row(Number,List,Element,NewPosition,Direction,Column,NewPositions),
    												(   three_in_a_row(Number,Sublist)->  Positions = [Position-Column-Direction| NewPositions];
                                                       Positions = NewPositions).

% check_columns_for_3_in_a_row(+Board,+Number,-Positions)
% +Board -> 2D list representing the current board
% +Number -> Number composing the 3 in a Rows
% -Positions -> List of the positions of the 3 in a rows
% Description : checks the columns of the board for 3 in a rows and returns their positions in a list
check_columns_for_3_in_a_row(Board,Number,Positions) :- check_rows_for_3_in_a_row(Board,Number,0,'v',ListofListofPositions), list_append(ListofListofPositions,Positions).

% check_rows_for_3_in_a_row(+Board,+Number,-Positions)
% +Board -> 2D list representing the current board
% +Number -> Number composing the 3 in a Rows
% -Positions -> List of the positions of the 3 in a rows
% Description : checks the rows of the board for 3 in a rows and returns their positions in a list
check_rows_for_3_in_a_row(Board,Number,Positions) :- check_rows_for_3_in_a_row(Board,Number,0,'h',ListofListofPositions), list_append(ListofListofPositions,Positions).

% check_rows_for_3_in_a_row(+Board,+Number,+Column,+Direction,-Positions)
% +Board -> 2D list representing the current board
% +Number -> Number composing the 3 in a row
% +Column -> Current column
% +Direction -> 3 in a row direction (h or v)
% -Positions -> List of positions of the 3 in a row
% Description : checks a board rows for 3 in a rows and returns their positions in a list
check_rows_for_3_in_a_row([Row|RestOfRows],Number,Column,Direction,Positions) :- NewColumn is Column + 1 ,
    																	check_rows_for_3_in_a_row(RestOfRows,Number,NewColumn,Direction,NewPositions),
    																	check_for_3_in_a_row(Number,Row,empty,0,Direction,Column,Pos),
    																	Positions = [Pos|NewPositions].

check_rows_for_3_in_a_row([],_,_,_,[]).

% check_board_for_3_in_a_row(+Board,+Number,-Positions)
% +Board -> 2D list representing the current board
% +Number -> Number composing the 3 in a Rows
% -Positions -> List of the positions of the 3 in a rows
% Description : checks the board for 3 in a rows and returns their positions in a list
check_board_for_3_in_a_row(Board,Number,Positions) :- check_rows_for_3_in_a_row(Board,Number,RowPositions),
    												transpose(Board,TransposedBoard),
    												check_columns_for_3_in_a_row(TransposedBoard,Number,InvertedColumnPositions),!,
    												invert_columns_indexs(InvertedColumnPositions,ColumnPositions),
    												append(RowPositions,ColumnPositions,Positions).

% new_3_in_a_row(+Board,+NewBoard,+Turn,+WhitePieces,+BlackPieces,+WhitePlayer,+BlackPlayer,-FinalBoard,-NewWhitePieces,-NewBlackPieces)
% +Board -> 2D list representing the board before the move
% +NewBoard -> 2D list representing the board after the move
% +Turn -> Current turn
% +WhitePieces -> Number of current white pieces
% +BlackPieces -> Number of current black pieces
% +WhitePlayer -> Indicates if the white player is human or computer
% +BlackPlayer -> Indicates if the black player is human or computer
% -FinalBoard -> 2D list representing the board after the possible remove
% -NewWhitePieces -> Number of white pieces after the possible remove
% -NewBlackPieces -> Number of black pieces after the possible remove
% Description : sees if there is a new 3 in a row and if true asks the current player to remove an enemy piece
new_3_in_a_row(Board,NewBoard,Turn,WhitePieces,BlackPieces,WhitePlayer,BlackPlayer,FinalBoard,NewWhitePieces,NewBlackPieces) :- 
                                                turn_number(Turn,Number),
                                                check_board_for_3_in_a_row(Board,Number,OldPositions),
                                                check_board_for_3_in_a_row(NewBoard,Number,NewPositions),
                                                length(OldPositions,OldLength),
                                                length(NewPositions,NewLength),
                                                OldPositions \= NewPositions,
                                                NewLength >= OldLength,!, %new 3 in a row
                                                display_game(NewBoard,WhitePieces,BlackPieces,Turn,2),
                                                display_3_in_a_row,
                                                choose_remove_piece(NewBoard,Turn,WhitePlayer,BlackPlayer,MoveX,MoveY),
                                                remove_piece(NewBoard,MoveX,MoveY,BoardAfterRemove),
                                                deal_with_pieces_after_remove(Turn,WhitePieces,BlackPieces,NewWhitePieces,NewBlackPieces),
                                                FinalBoard = BoardAfterRemove.
                                                  
new_3_in_a_row(_,NewBoard,_,WhitePieces,BlackPieces,_,_,NewBoard,WhitePieces,BlackPieces). %no new 3 in a row

% value(+Phase,+Board,+NewBoard,+Turn,-Value)
% +Phase -> Indicates if its a place move, a move or a remove
% +Board -> 2D list representing the board before the move
% +NewBoard -> 2D list representing the board after the move
% +Turn -> Current turn
% -Value -> Number representing the value for the current turn player
% Description : returns the value of a specific gamestate
value(move,Board,NewBoard,Turn,Value) :- 
                turn_number(Turn,TurnNumber),
                check_board_for_3_in_a_row(Board,TurnNumber,OldPositions),
                check_board_for_3_in_a_row(NewBoard,TurnNumber,NewPositions),
                length(OldPositions,OldLength),
                length(NewPositions,NewLength),
                OldPositions \= NewPositions,
                NewLength >= OldLength,!, %new 3 in a row
                Value is NewLength-OldLength.

value(move,_,_,_,-1).   

% value(+Phase,+Board,+Turn,-Value)
% +Phase -> Indicates if its a place move, a move or a remove
% +Board -> 2D list representing the board before the move
% +Turn -> Current turn
% -Value -> Number representing the value for the current turn player
% Description : returns the value of a specific gamestate
value(place,Board,Turn,Value) :- 
                turn_number(Turn,TurnNumber),
                value(place,Board,Board,TurnNumber,0,Value).

value(remove,Board,Turn,NegativeValue) :-
                switch_turns(Turn,NextTurn),
                get_opponent_best_move_piece(Board,NextTurn,Value,_MoveX,_MoveY,_NewX,_NewY),
                NegativeValue is -Value.

% value(+Phase,+Board,+CompleteBoard,+TurnNumber,+Y,-Value)
% +Phase -> Indicates if its a place move, a move or a remove
% +Board -> 2D list representing the board
% +CompleteBoard -> 2D list representing the complete board
% +TurnNumber -> Number of piece of the current turn
% +Y -> Y of the current row
% -Value -> Number representing the value for the current turn player
% Description : helper function to the value place fucntion
value(place,[],_,_,_,0).
value(place,[Row|Rows],CompleteBoard,Turn,Y,Result) :-
    Y1 is Y+1,
    value(place,Rows,CompleteBoard,Turn,Y1,SubResult),
    value_row(place,Row,CompleteBoard,Turn,0,Y,RowResult),
    Result is SubResult + RowResult.

% value_row(+Phase,+Row,+CompleteBoard,+TurnNumber,+X,+Y,-Value)
% +Phase -> Indicates if its a place move, a move or a remove
% +Row -> List representing the row
% +CompleteBoard -> 2D list representing the complete board
% +TurnNumber -> Number of piece of the current turn
% +X -> X of the current position
% +Y -> Y of the current row
% -Value -> Number representing the value for the current turn player
% Description : second helper function to the value place fucntion
value_row(place,[],_,_,_,_,0).
value_row(place,[_Elem|Elems],Board,Turn,X,Y,Result) :-
    X1 is X +1,
    value_row(place,Elems,Board,Turn,X1,Y,SubResult),
    get_nr_of_neighbor_diagonal(X,Y,Board,Turn,Nr),
    Result is SubResult + Nr.

% get_opponent_best_move_piece(+Board,+Turn,-Value,-MoveX,-MoveY,-NewX,-NewY)
% +Board -> 2D list representing the current board
% +Turn -> Current turn
% -Value -> Value of the opponent best move
% -MoveX -> X of the piece of the opponent best move
% -MoveY -> Y of the piece of the opponent best move
% -NewX -> New X of the piece of the opponent best move
% -NewY -> New Y of the piece of the opponent best move
% Description : gets the opponent player best future move
get_opponent_best_move_piece(Board,Turn,Value,MoveX,MoveY,NewX,NewY) :-
            valid_move_piece_moves(Board,Turn,Moves),
            setof(Value-MvX-MvY-NewX-NewY, NewBoard^( member(MvX-MvY-NewX-NewY, Moves),move_piece(Board,MvX,MvY,NewX,NewY,Turn,NewBoard),value(move,Board,NewBoard,Turn,Value)),ValueMoves),
            last_X_elements(ValueMoves,1,BestMoves),
            random_member(Value-MoveX-MoveY-NewX-NewY,BestMoves).

% get_best_place_piece(+ValueMoves,+NrMoves,-Value,-MoveX,-MoveY)
% +ValueMoves -> List of the possible moves with the associated value
% +NrMoves -> Size of the list of best moves to randomly select a move 
% -Value -> Value of the chosen place move
% -MoveX -> X of the chosen place move
% -MoveY -> Y of the chosen place move    
% Description : get the best place piece move
get_best_place_piece(ValueMoves,_,Value,MoveX,MoveY) :-
            same_value2(ValueMoves),!, %all same value
            random_member(Value-MoveX-MoveY,ValueMoves).

get_best_place_piece(ValueMoves,1,Value,MoveX,MoveY) :- % get all the top value moves
            !,get_all_of_high_value2(ValueMoves,BestMoves),
            random_member(Value-MoveX-MoveY,BestMoves).

get_best_place_piece(ValueMoves,NrMoves,Value,MoveX,MoveY) :- % not all same value
            last_X_elements(ValueMoves,NrMoves,BestMoves),
            random_member(Value-MoveX-MoveY,BestMoves).

% get_best_move_piece(+ValueMoves,+NrMoves,-Value,-MoveX,-MoveY,-NewX,-NewY)
% +ValueMoves -> List of the possible moves with the associated value
% +NrMoves -> Size of the list of best moves to randomly select a move 
% -Value -> Value of the chosen move
% -MoveX -> X of the piece to move
% -MoveY -> Y of the piece to move  
% -NewX -> X of the piece after the move
% -NewY -> Y of the piece after the move   
% Description : get the best piece move
get_best_move_piece(ValueMoves,_,Value,MoveX,MoveY,NewX,NewY) :-
            same_value4(ValueMoves),!, %all same value
            random_member(Value-MoveX-MoveY-NewX-NewY,ValueMoves).

get_best_move_piece(ValueMoves,1,Value,MoveX,MoveY,NewX,NewY) :- % get all the top value moves
            !,get_all_of_high_value4(ValueMoves,BestMoves),
            random_member(Value-MoveX-MoveY-NewX-NewY,BestMoves).

get_best_move_piece(ValueMoves,NrMoves,Value,MoveX,MoveY,NewX,NewY) :- % not all same value
            last_X_elements(ValueMoves,NrMoves,BestMoves),
            random_member(Value-MoveX-MoveY-NewX-NewY,BestMoves).

% get_best_remove_piece(+ValueMoves,+NrMoves,-Value,-MoveX,-MoveY)
% +ValueMoves -> List of the possible moves with the associated value
% +NrMoves -> Size of the list of best moves to randomly select a move 
% -Value -> Value of the chosen place move
% -MoveX -> X of the piece to remove
% -MoveY -> Y of the piece to remove    
% Description : get the best piece remove
get_best_remove_piece(ValueMoves,_,Value,MoveX,MoveY) :-
            same_value2(ValueMoves),!, %all same value
            random_member(Value-MoveX-MoveY,ValueMoves).

get_best_remove_piece(ValueMoves,1,Value,MoveX,MoveY) :- % get all the top value moves
            !,get_all_of_high_value2(ValueMoves,BestMoves),
            random_member(Value-MoveX-MoveY,BestMoves).

get_best_remove_piece(ValueMoves,NrMoves,Value,MoveX,MoveY) :- % not all same value
            last_X_elements(ValueMoves,NrMoves,BestMoves),
            random_member(Value-MoveX-MoveY,BestMoves).

