%consult('/Users/tiagobarbosa05/Documents/Wali_PFL_FEUP/wali.pl').

:- [utils].
:- [output].
:- [input].

play :-
    repeat,
    display_start_menu,
    read_until_between(0,3,Option),
    initial_state(InitialBoard,WhitePieces,BlackPieces,Turn,Phase),
    play_game(Option,InitialBoard,WhitePieces,BlackPieces,Turn,Phase).

play_game(1,Board,WhitePieces,BlackPieces,Turn,Phase) :- display_game(Board,WhitePieces,BlackPieces,Turn,Phase),
                                                        game_cycle(Board,WhitePieces,BlackPieces,Turn,Phase).

game_cycle(Board,WhitePieces,BlackPieces,Turn,1) :- choose_move(Board,WhitePieces,Turn,MoveX,MoveY),
                                                    move(Board,MoveX,MoveY,NewBoard,Turn),
                                                    switch_turns(Turn,NewTurn),
                                                    display_game(NewBoard,WhitePieces,BlackPieces,NewTurn,1),
                                                    game_cycle(NewBoard,WhitePieces,BlackPieces,NewTurn,1).

choose_move(Board,Pieces,Turn,MoveX,MoveY) :- Pieces>0,repeat,
                                read_move(MoveX,MoveY),validate_move(MoveX,MoveY),!.

valid_moves(Board,Turn,Moves) :- valid_moves(Board,Turn,4,5,Moves),write(Moves). %6-1 e 5-1 pq index 0


valid_moves(Board,Turn,-1,Y,[]).
valid_moves(Board,Turn,X,Y,Moves) :- valid_moves_line(Board,Turn,X,Y,NewMovesLine),
                                    X1 is X-1,
                                    valid_moves(Board,Turn,X1,Y,NewMoves),
                                    append(NewMoves,NewMovesLine,Moves).


valid_moves_line(Board,Turn,X,-1,[]).
valid_moves_line(Board,Turn,X,Y,MovesLine) :- validate_move(X,Y),
                                    Y1 is Y-1,
                                    valid_moves_line(Board,Turn,X,Y1,NewMovesLine),
                                    append(NewMovesLine,[X-Y],MovesLine).


validate_move(X,Y) :- X >= 0, X < 5, Y >= 0, Y < 6.


move([Line|Rest],0,Y,[NewLine|Rest],whiteturn) :- replace(Line,Y,_O,1,NewLine).

move([Line|Rest],0,Y,[NewLine|Rest],blackturn) :- replace(Line,Y,_O,2,NewLine).

move([Line|Rest],X,Y,NewBoard,Turn) :- X1 is X-1,
                                        move(Rest,X1,Y,NB,Turn),
                                        NewBoard =[Line|NB].

                                                

play_game(2) :- print_banner("To be developed",*,3).

play_game(3) :- print_banner("To be developed",*,3).

play_game(0) :- print_banner("Thank you for playing!",*,3).