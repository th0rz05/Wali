%consult('/Users/tiagobarbosa05/Documents/Wali_PFL_FEUP/wali.pl').
%consult('/Users/guilhermealmeida/FEUP - MIEIC/3ºano/PFL/Wali_PFL_FEUP/wali.pl').

:- [utils].
:- [output].
:- [input].
:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(random)).

play :-
    display_start_menu,
    read_until_between(0,4,Option),
    initial_state(InitialBoard,WhitePieces,BlackPieces,Turn,Phase),
    play_game(Option,InitialBoard,WhitePieces,BlackPieces,Turn,Phase).

play_game(1,Board,WhitePieces,BlackPieces,Turn,Phase) :- 
                        display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase,human,human).

play_game(2,Board,WhitePieces,BlackPieces,Turn,Phase) :- 
                        display_select_difficulty_menu(black),
                        read_until_between(1,2,Option),
                        turn_option_into_ai(Option,AI),
                        display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase,human,AI).

play_game(3,Board,WhitePieces,BlackPieces,Turn,Phase) :- 
                        display_select_difficulty_menu(white),
                        read_until_between(1,2,Option),
                        turn_option_into_ai(Option,AI),
                        display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase,AI,human).

play_game(4,Board,WhitePieces,BlackPieces,Turn,Phase) :- 
                        display_select_difficulty_menu(white),
                        read_until_between(1,2,OptionWhite),
                        turn_option_into_ai(OptionWhite,AIWhite),
                        display_select_difficulty_menu(black),
                        read_until_between(1,2,OptionBlack),
                        turn_option_into_ai(OptionBlack,AIBlack),
                        display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase,AIWhite,AIBlack).

game_cycle(Board,WhitePieces,BlackPieces,Turn,1,WhitePlayer,BlackPlayer) :- 
                        go_to_phase2(Board,WhitePieces,BlackPieces,Turn),!,
                        press_any_key_to_continue(phase2),
                        NewWhitePieces is 4-WhitePieces,
                        NewBlackPieces is 4-BlackPieces,
                        display_game(Board,NewWhitePieces,NewBlackPieces,Turn,2),
                        game_cycle(Board,NewWhitePieces,NewBlackPieces,Turn,2,WhitePlayer,BlackPlayer).

game_cycle(Board,WhitePieces,BlackPieces,Turn,1,WhitePlayer,BlackPlayer) :- 
                        pass_place_piece(Board,WhitePieces,BlackPieces,Turn),!,
                        press_any_key_to_continue(pass),
                        switch_turns(Turn,NewTurn),
                        display_game(Board,WhitePieces,BlackPieces,NewTurn,1),
                        game_cycle(Board,WhitePieces,BlackPieces,NewTurn,1,WhitePlayer,BlackPlayer).                                                  

game_cycle(Board,WhitePieces,BlackPieces,Turn,1,WhitePlayer,BlackPlayer) :- 
                        choose_place_piece(Board,Turn,MoveX,MoveY,WhitePlayer,BlackPlayer),
                        place_piece(Board,MoveX,MoveY,NewBoard,Turn),
                        handle_pieces(WhitePieces,BlackPieces,Turn,WhitePieces1,BlackPieces1),
                        switch_turns(Turn,NewTurn),
                        display_game(NewBoard,WhitePieces1,BlackPieces1,NewTurn,1),
                        game_cycle(NewBoard,WhitePieces1,BlackPieces1,NewTurn,1,WhitePlayer,BlackPlayer).

game_cycle(Board,WhitePieces,BlackPieces,_,2,_,_) :-    
                        game_over(Board,WhitePieces,BlackPieces,Winner),!,
                        congratulate_winner(Winner).

game_cycle(Board,WhitePieces,BlackPieces,Turn,2,WhitePlayer,BlackPlayer) :- 
                        choose_move_piece(Board,Turn,X,Y,NewX,NewY,WhitePlayer,BlackPlayer),
                        move_piece(Board,X,Y,NewX,NewY,NewBoard,Turn),
                        new_3_in_a_row(Board,NewBoard,Turn,WhitePieces,BlackPieces,FinalBoard,NewWhitePieces,NewBlackPieces,WhitePlayer,BlackPlayer),
                        switch_turns(Turn,NewTurn),
                        display_game(FinalBoard,NewWhitePieces,NewBlackPieces,NewTurn,2),
                        game_cycle(FinalBoard,NewWhitePieces,NewBlackPieces,NewTurn,2,WhitePlayer,BlackPlayer).

game_over(_,2,_,black).

game_over(_,_,2,white).


choose_place_piece(Board,Turn,MoveX,MoveY,WhitePlayer,BlackPlayer) :- 
                        human_turn(Turn,WhitePlayer,BlackPlayer),!,
                        repeat,
                        read_move(MoveX,MoveY,place),
                        validate_place_piece(Board,MoveX,MoveY,Turn),!.

choose_place_piece(Board,Turn,MoveX,MoveY,WhitePlayer,BlackPlayer) :- 
                        computer1_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_place_piece_moves(Board,Turn,Moves),
                        random_member(MoveX-MoveY,Moves),
                        press_any_key_to_continue(ai_place,MoveX,MoveY).

choose_move_piece(Board,Turn,MoveX,MoveY,NewX,NewY,WhitePlayer,BlackPlayer) :- 
                        human_turn(Turn,WhitePlayer,BlackPlayer),!,
                        repeat,
                        read_move(MoveX,MoveY,NewX,NewY),
                        validate_move_piece(Board,MoveX,MoveY,NewX,NewY,Turn),!.

choose_move_piece(Board,Turn,MoveX,MoveY,NewX,NewY,WhitePlayer,BlackPlayer) :- 
                        computer1_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_move_piece_moves(Board,Turn,Moves),
                        random_member(MoveX-MoveY-NewX-NewY,Moves),
                        press_any_key_to_continue(ai_move,MoveX,MoveY,NewX,NewY).

choose_remove_piece(Board,Turn,MoveX,MoveY,WhitePlayer,BlackPlayer) :- 
                        human_turn(Turn,WhitePlayer,BlackPlayer),!,
                        repeat,
                        read_move(MoveX,MoveY,remove),
                        validate_remove_piece(Board,MoveX,MoveY,Turn),!.

choose_remove_piece(Board,Turn,MoveX,MoveY,WhitePlayer,BlackPlayer) :- 
                        computer1_turn(Turn,WhitePlayer,BlackPlayer),!,
                        valid_remove_piece_moves(Board,Turn,Moves),
                        random_member(MoveX-MoveY,Moves),
                        press_any_key_to_continue(ai_remove,MoveX,MoveY).

no_more_valid_place_piece_moves(Board) :- no_turn_place_piece_moves(Board,whiteturn),
                                          no_turn_place_piece_moves(Board,blackturn).

no_turn_place_piece_moves(Board,Turn) :- valid_place_piece_moves(Board,Turn,Moves),
                                        length(Moves,0).

valid_place_piece_moves(Board,Turn,Moves):- findall(X-Y, validate_place_piece(Board,X,Y,Turn), Moves).%write(Moves).

valid_move_piece_moves(Board,Turn,Moves):- findall(X-Y-NewX-NewY, validate_move_piece(Board,X,Y,NewX,NewY,Turn), Moves).%write(Moves).

valid_remove_piece_moves(Board,Turn,Moves):- findall(X-Y, validate_remove_piece(Board,X,Y,Turn), Moves).%write(Moves).

validate_place_piece(Board,X,Y,Turn) :- between(0, 5, X),between(0, 4, Y), not_occupied(Board,X,Y), no_neighbours(Board,X,Y,Turn). 

validate_remove_piece(Board,X,Y,Turn) :- between(0, 5, X),between(0, 4, Y), has_enemy(Board,X,Y,Turn). 

validate_move_piece(Board,X,Y,NewX,NewY,Turn) :- between(0, 5, X),
                                            between(0, 4, Y),
                                            has_piece(Board,X,Y,Turn),
                                            between(0, 5, NewX),
                                            DiffX is NewX-X,
                                            between(-1, 1, DiffX),
                                            between(0, 4, NewY),
                                            DiffY is NewY-Y,
                                            between(-1, 1, DiffY),
                                            (DiffX=:=0;DiffY=:=0),
                                            not_occupied(Board,NewX,NewY).


has_piece(Board,X,Y,whiteturn) :- value_is(X, Y, 1, Board).

has_piece(Board,X,Y,blackturn) :- value_is(X, Y, 2, Board).

has_enemy(Board,X,Y,whiteturn) :- value_is(X, Y, 2, Board).

has_enemy(Board,X,Y,blackturn) :- value_is(X, Y, 1, Board).

not_occupied(Board,X,Y) :- value_is(X, Y, 0, Board).

no_neighbours(Board,X,Y,whiteturn) :- \+ neighbor(X, Y, Board, 1).

no_neighbours(Board,X,Y,blackturn) :- \+ neighbor(X, Y, Board, 2).

handle_pieces(WhitePieces,BlackPieces,whiteturn,NewWhitePieces,NewBlackPieces) :- NewWhitePieces is WhitePieces-1,NewBlackPieces is BlackPieces.
handle_pieces(WhitePieces,BlackPieces,blackturn,NewWhitePieces,NewBlackPieces) :- NewBlackPieces is BlackPieces-1,NewWhitePieces is WhitePieces.

place_piece(Board,X,Y,NewBoard,whiteturn) :- replace(X,Y,1,Board,NewBoard).

place_piece(Board,X,Y,NewBoard,blackturn) :- replace(X,Y,2,Board,NewBoard).

remove_piece(Board,X,Y,NewBoard) :- replace(X,Y,0,Board,NewBoard).

remove_piece(Board,X,Y,NewBoard) :- replace(X,Y,0,Board,NewBoard).

move_piece(Board,X,Y,NewX,NewY,NewBoard,whiteturn) :- replace(X,Y,0,Board,TempBoard),
                                                      replace(NewX,NewY,1,TempBoard,NewBoard).

move_piece(Board,X,Y,NewX,NewY,NewBoard,blackturn) :- replace(X,Y,0,Board,TempBoard),
                                                      replace(NewX,NewY,2,TempBoard,NewBoard).

%os dois sem peças
go_to_phase2(_,0,0,_).

%os dois sem moves
go_to_phase2(Board,_,_,_) :- no_more_valid_place_piece_moves(Board).

%um sem moves e outro sem peças
go_to_phase2(Board,0,_,blackturn) :- no_turn_place_piece_moves(Board,blackturn).
go_to_phase2(Board,_,0,whiteturn) :- no_turn_place_piece_moves(Board,whiteturn).

%sem peças                                                                                        
pass_place_piece(_,0,_,whiteturn).

pass_place_piece(_,_,0,blackturn).

%sem moves
pass_place_piece(Board,_,_,Turn) :- no_turn_place_piece_moves(Board,Turn).




three_in_a_row(Nr,[Nr,Nr,Nr,Dif|[]]) :- Nr \= Dif.

three_in_a_row(Nr,[Nr,Nr,Nr|[]]).

check_for_3_in_a_row(_,List,_,Position,[],_,_) :- length(List,Size),
    									MaxPosition is Size-2,
    									Position =:= MaxPosition.


check_for_3_in_a_row(Number,List,Number,Position,Positions,Direction,Column) :- nth0(Position, List, Element),
    												NewPosition is Position + 1 ,
    												check_for_3_in_a_row(Number,List,Element,NewPosition,NewPositions,Direction,Column),
    												Positions = NewPositions.

check_for_3_in_a_row(Number,List,_Diff,Position,Positions,Direction,Column) :-  UpperBound is Position+3,
    												my_sublist(List,Position,UpperBound, Sublist),
    												nth0(Position, List, Element),
    												NewPosition is Position + 1 ,
    												check_for_3_in_a_row(Number,List,Element,NewPosition,NewPositions,Direction,Column),
    												(   three_in_a_row(Number,Sublist)->  Positions = [Position-Column-Direction| NewPositions];
                                                       Positions = NewPositions).

check_columns_for_3_in_a_row(Board,Number,Positions) :- check_rows_for_3_in_a_row(Board,Number,0, ListofListofPositions,'v'), list_append(ListofListofPositions,Positions).

check_rows_for_3_in_a_row(Board,Number,Positions) :- check_rows_for_3_in_a_row(Board,Number,0, ListofListofPositions,'h'), list_append(ListofListofPositions,Positions).

check_rows_for_3_in_a_row([Row|RestOfRows],Number,Column,Positions,Direction) :- NewColumn is Column + 1 ,
    																	check_rows_for_3_in_a_row(RestOfRows,Number,NewColumn,NewPositions,Direction),
    																	check_for_3_in_a_row(Number,Row,empty,0,Pos,Direction,Column),
    																	Positions = [Pos|NewPositions].

check_rows_for_3_in_a_row([],_,_,[],_).

check_board_for_3_in_a_row(Board,Number,Positions) :- check_rows_for_3_in_a_row(Board,Number,RowPositions),
    												transpose(Board,TransposedBoard),
    												check_columns_for_3_in_a_row(TransposedBoard,Number,InvertedColumnPositions),!,
    												invert_columns_indexs(InvertedColumnPositions,ColumnPositions),
    												append(RowPositions,ColumnPositions,Positions).

new_3_in_a_row(Board,NewBoard,Turn,WhitePieces,BlackPieces,FinalBoard,NewWhitePieces,NewBlackPieces,WhitePlayer,BlackPlayer) :- 
                                                turn_number(Turn,Number),
                                                check_board_for_3_in_a_row(Board,Number,OldPositions),
                                                check_board_for_3_in_a_row(NewBoard,Number,NewPositions),
                                                length(OldPositions,OldLength),
                                                length(NewPositions,NewLength),
                                                OldPositions \= NewPositions,
                                                NewLength >= OldLength,!, %new 3 in a row
                                                display_game(NewBoard,WhitePieces,BlackPieces,Turn,2),
                                                print_banner("3 IN A ROW",*, 7),nl,
                                                choose_remove_piece(NewBoard,Turn,MoveX,MoveY,WhitePlayer,BlackPlayer),
                                                remove_piece(NewBoard,MoveX,MoveY,BoardAfterRemove),
                                                deal_with_pieces_after_remove(Turn,WhitePieces,BlackPieces,NewWhitePieces,NewBlackPieces),
                                                FinalBoard = BoardAfterRemove.
                                                  

new_3_in_a_row(_,NewBoard,_,WhitePieces,BlackPieces,NewBoard,WhitePieces,BlackPieces,_,_). %no new 3 in a row
