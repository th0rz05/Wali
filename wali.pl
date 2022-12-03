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
                                                    nl,nl,write(MoveX),write(MoveY),nl,nl,
                                                    switch_turns(Turn,NewTurn),
                                                    display_game(Board,WhitePieces,BlackPieces,NewTurn,1),
                                                    game_cycle(Board,WhitePieces,BlackPieces,NewTurn,1).

choose_move(Board,Pieces,Turn,MoveX,MoveY) :- Pieces>0,repeat,
                                read_move(MoveX,MoveY),validate_move(MoveX,MoveY),!.


switch_turns(whiteturn,blackturn).
switch_turns(blackturn,whiteturn).

                                                

play_game(2) :- print_banner("To be developed",*,3).

play_game(3) :- print_banner("To be developed",*,3).

play_game(0) :- print_banner("Thank you for playing!",*,3).