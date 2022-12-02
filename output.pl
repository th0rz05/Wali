display_start_menu :-
    nl,
    write('   *************************************************************************************   '),nl,
    write('   |                                                                                   |   '),nl,
    write('   |   WWWWWWWW                           WWWWWWWW                  lllllll   iiii     |   '),nl,
    write('   |   W::::::W                           W::::::W                  l:::::l  i::::i    |   '),nl,
    write('   |   W::::::W                           W::::::W                  l:::::l   iiii     |   '),nl,
    write('   |   W::::::W                           W::::::W                  l:::::l            |   '),nl,
    write('   |    W:::::W           WWWWW           W:::::W   aaaaaaaaaaaaa    l::::l iiiiiii    |   '),nl,
    write('   |     W:::::W         W:::::W         W:::::W    a::::::::::::a   l::::l i:::::i    |   '),nl,
    write('   |      W:::::W       W:::::::W       W:::::W     aaaaaaaaa:::::a  l::::l  i::::i    |   '),nl,
    write('   |       W:::::W     W:::::::::W     W:::::W               a::::a  l::::l  i::::i    |   '),nl,
    write('   |        W:::::W   W:::::W:::::W   W:::::W         aaaaaaa:::::a  l::::l  i::::i    |   '),nl,                           
    write('   |         W:::::W W:::::W W:::::W W:::::W        aa::::::::::::a  l::::l  i::::i    |   '),nl,
    write('   |          W:::::W:::::W   W:::::W:::::W        a::::aaaa::::::a  l::::l  i::::i    |   '),nl,
    write('   |           W:::::::::W     W:::::::::W        a::::a    a:::::a  l::::l  i::::i    |   '),nl,
    write('   |            W:::::::W       W:::::::W         a::::a    a:::::a l::::::li::::::i   |   '),nl,
    write('   |             W:::::W         W:::::W          a:::::aaaa::::::a l::::::li::::::i   |   '),nl,
    write('   |              W:::W           W:::W            a::::::::::aa:::al::::::li::::::i   |   '),nl,
    write('   |               WWW             WWW              aaaaaaaaaa  aaaalllllllliiiiiiii   |   '),nl,
    write('   |                                                                                   |   '),nl,
    write('   |                                                                                   |   '),nl,
    write('   |                               1 - PLAYER VS PLAYER                                |   '),nl,
    write('   |                               2 - PLAYER VS COMPUTER                              |   '),nl,
    write('   |                               3 - COMPUTER VS PLAYER                              |   '),nl,
    write('   |                               4 - COMPUTER VS COMPUTER                            |   '),nl,
    write('   |                               0 - EXIT                                            |   '),nl,
    write('   |                                                                                   |   '),nl,
    write('   *************************************************************************************   '),nl.
 
                                                                             
display_game([H | T],WhitePieces,BlackPieces,Turn,Phase) :-
    nl,
    length(H, Width),
    display_letters(Width),
    nl, nl,
    display_board([H | T]).


display_letters(Width) :- write('     '),display_letters(Width, 0).
display_letters(Width, Width) :- !.
display_letters(Width, ActualWidth) :-
    CharCode is ActualWidth + 65,
    put_code(CharCode),write('   '),
    NewWidth is ActualWidth + 1,
    display_letters(Width, NewWidth).


display_board(Board) :- display_board(Board, 0).
display_board([], _).
display_board([L | R], ActualHeight) :-
    write(' '),write(ActualHeight), write('   '),
    display_line(L), nl, nl,
    NewHeight is ActualHeight + 1,
    display_board(R, NewHeight).


display_line([]).
display_line([H | T]) :-
    write(H),
    write('   '),
    display_line(T).


display_turn(0) :- write('White\'s turn.\n').
display_turn(1) :- write('Black\'s turn.\n').                                                                            
                                                                             
                                                                             
                                                                             
                                                                             
                                                                             












                               
                               
                               


                                                   


