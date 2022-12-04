%consult('/Users/tiagobarbosa05/Documents/Wali_PFL_FEUP/wali.pl').
%consult('/Users/guilhermealmeida/FEUP - MIEIC/3ºano/PFL/Wali_PFL_FEUP/wali.pl').

:- [utils].
:- [output].
:- [input].
:- use_module(library(lists)).

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
                                read_move(MoveX,MoveY),validate_move(Board,MoveX,MoveY,Turn),!.

valid_moves(Board,Turn,Moves) :- valid_moves(Board,Turn,4,5,Moves),write(Moves). %5-1 e 6-1 pq index 0


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


validate_move(Board,X,Y,Turn) :- X >= 0, X < 5, Y >= 0, Y < 6, not_occupied(Board,X,Y), no_neighbours(Board,X,Y,Turn). %desenvolver um not_ocuppied(Board,X,Y) e no_neighbours(Board,X,Y,Turn) para ver se nao tem nenhum vizinho igual

not_occupied(Board,X,Y) :- nth0(X,Board,R),
                           nth0(Y,R,R2),
                           R2 == 0.

%corners
no_neighbours(Board,0,0,whiteturn) :- nth0(0,Board,R), nth0(1,R,R2), R2\=1, nth0(1,Board,R3), nth0(0,R3,R4), R4\=1.
no_neighbours(Board,0,0,blackturn) :- nth0(0,Board,R), nth0(1,R,R2), R2\=2, nth0(1,Board,R3), nth0(0,R3,R4), R4\=2.
no_neighbours(Board,0,5,whiteturn) :- nth0(0,Board,R), nth0(4,R,R2), R2\=1, nth0(1,Board,R3), nth0(5,R3,R4), R4\=1.
no_neighbours(Board,0,5,blackturn) :- nth0(0,Board,R), nth0(4,R,R2), R2\=2, nth0(1,Board,R3), nth0(5,R3,R4), R4\=2.
no_neighbours(Board,4,0,whiteturn) :- nth0(3,Board,R), nth0(0,R,R2), R2\=1, nth0(4,Board,R3), nth0(1,R3,R4), R4\=1. 
no_neighbours(Board,4,0,blackturn) :- nth0(3,Board,R), nth0(0,R,R2), R2\=2, nth0(4,Board,R3), nth0(1,R3,R4), R4\=2. 
no_neighbours(Board,4,5,whiteturn) :- nth0(3,Board,R), nth0(5,R,R2), R2\=1, nth0(4,Board,R3), nth0(4,R3,R4), R4\=1. 
no_neighbours(Board,4,5,blackturn) :- nth0(3,Board,R), nth0(5,R,R2), R2\=2, nth0(4,Board,R3), nth0(4,R3,R4), R4\=2. 
%sides
no_neighbours(Board,0,Y,whiteturn) :- nth0(0,Board,R), nth0(Y1,R,R2), R2\=1, nth0(0,Board,R3), nth0(Y2,R3,R4), R4\=1, nth0(1,Board,R5), nth0(Y,R5,R6), R6\=1, Y1 is Y-1, Y2 is Y+1.
no_neighbours(Board,0,Y,blackturn) :- nth0(0,Board,R), nth0(Y1,R,R2), R2\=2, nth0(0,Board,R3), nth0(Y2,R3,R4), R4\=2, nth0(1,Board,R5), nth0(Y,R5,R6), R6\=2, Y1 is Y-1, Y2 is Y+1.
no_neighbours(Board,X,0,whiteturn) :- nth0(X1,Board,R), nth0(0,R,R2), R2\=1, nth0(X2,Board,R3), nth0(0,R3,R4), R4\=1, nth0(X,Board,R5), nth0(1,R5,R6), R6\=1, X1 is X-1, X2 is X+1.
no_neighbours(Board,X,0,blackturn) :- nth0(X1,Board,R), nth0(0,R,R2), R2\=2, nth0(X2,Board,R3), nth0(0,R3,R4), R4\=2, nth0(X,Board,R5), nth0(1,R5,R6), R6\=2, X1 is X-1, X2 is X+1.
no_neighbours(Board,4,Y,whiteturn) :- nth0(4,Board,R), nth0(Y1,R,R2), R2\=1, nth0(4,Board,R3), nth0(Y2,R3,R4), R4\=1, nth0(3,Board,R5), nth0(Y,R5,R6), R6\=1, Y1 is Y-1, Y2 is Y+1.
no_neighbours(Board,4,Y,blackturn) :- nth0(4,Board,R), nth0(Y1,R,R2), R2\=2, nth0(4,Board,R3), nth0(Y2,R3,R4), R4\=2, nth0(3,Board,R5), nth0(Y,R5,R6), R6\=2, Y1 is Y-1, Y2 is Y+1.
no_neighbours(Board,X,5,whiteturn) :- nth0(X1,Board,R), nth0(5,R,R2), R2\=1, nth0(X2,Board,R3), nth0(5,R3,R4), R4\=1, nth0(X,Board,R5), nth0(4,R5,R6), R6\=1, X1 is X-1, X2 is X+1.
no_neighbours(Board,X,5,blackturn) :- nth0(X1,Board,R), nth0(5,R,R2), R2\=2, nth0(X2,Board,R3), nth0(5,R3,R4), R4\=2, nth0(X,Board,R5), nth0(4,R5,R6), R6\=2, X1 is X-1, X2 is X+1.
%middle
no_neighbours(Board,X,Y,whiteturn) :-  nth0(X1,Board,R), nth0(Y,R,R2), R2\=1, nth0(X2,Board,R3), nth0(Y,R3,R4), R4\=1, nth0(X,Board,R5), nth0(Y1,R5,R6), R6\=1, nth0(X,Board,R7), nth0(Y2,R7,R8), R8\=1, X1 is X-1, X2 is X+1, Y1 is Y-1, Y2 is Y+1.
no_neighbours(Board,X,Y,blackturn) :-  nth0(X1,Board,R), nth0(Y,R,R2), R2\=2, nth0(X2,Board,R3), nth0(Y,R3,R4), R4\=2, nth0(X,Board,R5), nth0(Y1,R5,R6), R6\=2, nth0(X,Board,R7), nth0(Y2,R7,R8), R8\=2, X1 is X-1, X2 is X+1, Y1 is Y-1, Y2 is Y+1.


move([Line|Rest],0,Y,[NewLine|Rest],whiteturn) :- replace(Line,Y,_O,1,NewLine).

move([Line|Rest],0,Y,[NewLine|Rest],blackturn) :- replace(Line,Y,_O,2,NewLine).

move([Line|Rest],X,Y,NewBoard,Turn) :- X1 is X-1,
                                        move(Rest,X1,Y,NB,Turn),
                                        NewBoard =[Line|NB].


play_game(2) :- print_banner("To be developed",*,3).

play_game(3) :- print_banner("To be developed",*,3).

play_game(0) :- print_banner("Thank you for playing!",*,3).