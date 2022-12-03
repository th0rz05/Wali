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


switch_turns(whiteturn,blackturn).
switch_turns(blackturn,whiteturn).


replace([H1|T1], 0, H1, N, [N|T1]).
replace([H1|T1], X, O, N, L2) :- X > 0,
                                X1 is X-1,
                                replace(T1,X1,O,N,L3),
                                L2 = [H1|L3].


move([Line|Rest],X,0,[NewLine|Rest],whiteturn) :- replace(Line,X,_O,1,NewLine).

move([Line|Rest],X,0,[NewLine|Rest],blackturn) :- replace(Line,X,_O,2,NewLine).

move([Line|Rest],X,Y,NewBoard,Turn) :- Y1 is Y-1,
                                        move(Rest,X,Y1,NB,Turn),
                                        NewBoard =[Line|NB].

                                                

play_game(2) :- print_banner("To be developed",*,3).

play_game(3) :- print_banner("To be developed",*,3).

play_game(0) :- print_banner("Thank you for playing!",*,3).