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

play_game(1,Board,WhitePieces,BlackPieces,Turn,Phase) :- display_game(InitialBoard,WhitePieces,BlackPieces,Turn,Phase).
                                                        %develop game_cycle

play_game(2) :- print_banner("To be developed",*,3).

play_game(3) :- print_banner("To be developed",*,3).

play_game(0) :- print_banner("Thank you for playing!",*,3).