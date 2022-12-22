%consult('/Users/tiagobarbosa05/Documents/Wali_PFL_FEUP/wali.pl').
%consult('/Users/guilhermealmeida/FEUP - MIEIC/3ºano/PFL/Wali_PFL_FEUP/wali.pl').

:- [utils].
:- [output].
:- [input].
:- use_module(library(lists)).
:- use_module(library(between)).

play :-
    repeat,
    display_start_menu,
    read_until_between(0,3,Option),
    initial_state(InitialBoard,WhitePieces,BlackPieces,Turn,Phase),
    play_game(Option,InitialBoard,WhitePieces,BlackPieces,Turn,Phase).

play_game(1,Board,WhitePieces,BlackPieces,Turn,Phase) :- display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                                                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase).

play_game(2,_,_,_,_,_) :- print_banner("To be developed",*,3).

play_game(3,_,_,_,_,_) :- print_banner("To be developed",*,3).

play_game(0,_,_,_,_,_) :- print_banner("Thank you for playing!",*,3).

game_cycle(Board,WhitePieces,BlackPieces,Turn,1) :- go_to_phase2(Board,WhitePieces,BlackPieces,Turn),!,
                                                    press_any_key_to_continue,
                                                    display_game(Board,3,3,Turn,2),
                                                    game_cycle(Board,3,3,Turn,2).

game_cycle(Board,WhitePieces,BlackPieces,Turn,1) :- pass_place_piece(Board,WhitePieces,BlackPieces,Turn),!,
                                                    print_banner("move passed",*,3),
                                                    switch_turns(Turn,NewTurn),
                                                    display_game(Board,WhitePieces,BlackPieces,NewTurn,1),
                                                    game_cycle(Board,WhitePieces,BlackPieces,NewTurn,1).                                                  

game_cycle(Board,WhitePieces,BlackPieces,Turn,1) :- choose_place_piece(Board,Turn,MoveX,MoveY),
                                                    place_piece(Board,MoveX,MoveY,NewBoard,Turn),
                                                    handle_pieces(WhitePieces,BlackPieces,Turn,WhitePieces1,BlackPieces1),
                                                    switch_turns(Turn,NewTurn),
                                                    display_game(NewBoard,WhitePieces1,BlackPieces1,NewTurn,1),
                                                    game_cycle(NewBoard,WhitePieces1,BlackPieces1,NewTurn,1).

game_cycle(Board,WhitePieces,BlackPieces,Turn,2) :- choose_move_piece(Board,Turn,X,Y,NewX,NewY),
                                                    move_piece(Board,X,Y,NewX,NewY,NewBoard,Turn),
                                                    switch_turns(Turn,NewTurn),
                                                    display_game(NewBoard,WhitePieces,BlackPieces,NewTurn,2),
                                                    game_cycle(NewBoard,WhitePieces,BlackPieces,NewTurn,2).


choose_place_piece(Board,Turn,MoveX,MoveY) :- repeat,
                                            read_move(MoveX,MoveY),
                                            validate_place_piece(Board,MoveX,MoveY,Turn),!.


choose_move_piece(Board,Turn,MoveX,MoveY,NewX,NewY) :- repeat,
                                                read_move(MoveX,MoveY,NewX,NewY),
                                                validate_move_piece(Board,MoveX,MoveY,NewX,NewY,Turn),!.

no_more_valid_place_piece_moves(Board) :- no_turn_place_piece_moves(Board,whiteturn),
                                          no_turn_place_piece_moves(Board,blackturn).

no_turn_place_piece_moves(Board,Turn) :- valid_place_piece_moves(Board,Turn,Moves),
                                        length(Moves,0).

valid_place_piece_moves(Board,Turn,Moves):- findall(X-Y, validate_place_piece(Board,X,Y,Turn), Moves).%write(Moves).

validate_place_piece(Board,X,Y,Turn) :- between(0, 5, X),between(0, 4, Y), not_occupied(Board,X,Y), no_neighbours(Board,X,Y,Turn). 

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

not_occupied(Board,X,Y) :- value_is(X, Y, 0, Board).

no_neighbours(Board,X,Y,whiteturn) :- \+ neighbor(X, Y, Board, 1).

no_neighbours(Board,X,Y,blackturn) :- \+ neighbor(X, Y, Board, 2).

handle_pieces(WhitePieces,BlackPieces,whiteturn,NewWhitePieces,NewBlackPieces) :- NewWhitePieces is WhitePieces-1,NewBlackPieces is BlackPieces.
handle_pieces(WhitePieces,BlackPieces,blackturn,NewWhitePieces,NewBlackPieces) :- NewBlackPieces is BlackPieces-1,NewWhitePieces is WhitePieces.

place_piece(Board,X,Y,NewBoard,whiteturn) :- replace(X,Y,1,Board,NewBoard).

place_piece(Board,X,Y,NewBoard,blackturn) :- replace(X,Y,2,Board,NewBoard).

move_piece(Board,X,Y,NewX,NewY,NewBoard,whiteturn) :- replace(X,Y,0,Board,TempBoard),
                                                      replace(NewX,NewY,1,TempBoard,NewBoard).

move_piece(Board,X,Y,NewX,NewY,NewBoard,blackturn) :- replace(X,Y,0,Board,TempBoard),
                                                      replace(NewX,NewY,2,TempBoard,NewBoard).

%sem peças
go_to_phase2(_,0,0,_).

%sem moves
go_to_phase2(Board,_,_,_) :- no_more_valid_place_piece_moves(Board).

%um sem moves e outro sem peças
go_to_phase2(Board,0,_,blackturn) :- no_turn_place_piece_moves(Board,blackturn).
go_to_phase2(Board,_,0,whiteturn) :- no_turn_place_piece_moves(Board,whiteturn).

%sem peças                                                                                        
pass_place_piece(_,0,_,whiteturn).

pass_place_piece(_,_,0,blackturn).

%sem moves
pass_place_piece(Board,_,_,Turn) :- no_turn_place_piece_moves(Board,Turn).

