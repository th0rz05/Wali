%consult('/Users/tiagobarbosa05/Documents/Wali_PFL_FEUP/wali.pl').

:- [utils].
:- [output].
:- [input].

play :-
    repeat,
    display_start_menu,
    read_until_between(0,4,Option),
    write(Option).