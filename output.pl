print_n(_, 0).
print_n(Symbol, N) :- N > 0,
                      N1 is N-1,
                      write(Symbol),
                      print_n(Symbol, N1).


print_string([]).
print_string([Code | T]) :- char_code(Char, Code),
                            write(Char),
                            print_string(T).


print_text(Text, Symbol, Padding) :- write(Symbol),
                                     print_n(' ', Padding),
                                     print_string(Text),
                                     print_n(' ', Padding),
                                     write(Symbol).


print_text_pieces(Text,Pieces,Symbol, Padding) :- write(Symbol),
                                     print_n(' ', Padding),
                                     print_string(Text),
                                     write(Pieces),
                                     print_n(' ', Padding),
                                     write(Symbol).

print_banner_edge(Text, Symbol, Padding) :- length(Text, Len),
                                            Width is Len + Padding*2 + 2,
                                            print_n(Symbol, Width).

print_banner_edge_pieces(Text,Pieces, Symbol, Padding) :- Pieces>=10,
                                            length(Text, Len),
                                            Width is Len + Padding*2 + 4,
                                            print_n(Symbol, Width).

print_banner_edge_pieces(Text,Pieces, Symbol, Padding) :- Pieces<10,
                                            length(Text, Len),
                                            Width is Len + Padding*2 + 3,
                                            print_n(Symbol, Width).

print_banner_empty(Text, Symbol, Padding) :- length(Text, Len),
                                             NSpaces is Len + Padding*2,
                                             write(Symbol),
                                             print_n(' ', NSpaces),
                                             write(Symbol).

print_banner_empty_pieces(Text,Pieces, Symbol, Padding) :- Pieces >=10,
                                            length(Text, Len),
                                             NSpaces is Len + Padding*2 + 2,
                                             write(Symbol),
                                             print_n(' ', NSpaces),
                                             write(Symbol).

print_banner_empty_pieces(Text,Pieces, Symbol, Padding) :- Pieces<10,
                                            length(Text, Len),
                                             NSpaces is Len + Padding*2 + 1,
                                             write(Symbol),
                                             print_n(' ', NSpaces),
                                             write(Symbol).

print_banner(Text, Symbol, Padding) :- Padding >= 0,
                                       print_banner_edge(Text, Symbol, Padding), nl,
                                       print_banner_empty(Text, Symbol, Padding), nl,
                                       print_text(Text, Symbol, Padding), nl,
                                       print_banner_empty(Text, Symbol, Padding), nl,
                                       print_banner_edge(Text, Symbol, Padding).

print_double_banner(Text1,WhitePieces, Text2,BlackPieces, Symbol, Padding) :- Padding >= 0,
                                       print_banner_edge_pieces(Text1,WhitePieces,Symbol, Padding),print_banner_edge_pieces(Text2,BlackPieces,Symbol, Padding),nl,
                                       print_banner_empty_pieces(Text1,WhitePieces, Symbol, Padding),print_banner_empty_pieces(Text2,BlackPieces, Symbol, Padding),nl,
                                       print_text_pieces(Text1,WhitePieces, Symbol, Padding),print_text_pieces(Text2,BlackPieces, Symbol, Padding), nl,
                                       print_banner_empty_pieces(Text1,WhitePieces, Symbol, Padding),print_banner_empty_pieces(Text2,BlackPieces, Symbol, Padding),nl,
                                       print_banner_edge_pieces(Text1,WhitePieces,Symbol, Padding),print_banner_edge_pieces(Text2,BlackPieces,Symbol, Padding),nl.





display_start_menu :-
    nl,
    write('   *************************************************************************************   '),nl,
    write('   |                                                                                   |   '),nl,
    write('   |   WWWWWWWW                           WWWWWWWW                  WWWWWWW   WWWW     |   '),nl,
    write('   |   WxxxxxxW                           WxxxxxxW                  WxxxxxW  WxxxxW    |   '),nl,
    write('   |   WxxxxxxW                           WxxxxxxW                  WxxxxxW   WWWW     |   '),nl,
    write('   |   WxxxxxxW                           WxxxxxxW                  WxxxxxW            |   '),nl,
    write('   |    WxxxxxW           WWWWW           WxxxxxW   aaaaaaaaaaaaa    WxxxxW aaaaaaa    |   '),nl,
    write('   |     WxxxxxW         WxxxxxW         WxxxxxW    axxxxxxxxxxxxa   WxxxxW axxxxxa    |   '),nl,
    write('   |      WxxxxxW       WxxxxxxxW       WxxxxxW     aaaaaaaaaxxxxxa  WxxxxW  axxxxa    |   '),nl,
    write('   |       WxxxxxW     WxxxxxxxxxW     WxxxxxW               axxxxa  WxxxxW  axxxxa    |   '),nl,
    write('   |        WxxxxxW   WxxxxxWxxxxxW   WxxxxxW         aaaaaaaxxxxxa  WxxxxW  axxxxa    |   '),nl,                           
    write('   |         WxxxxxW WxxxxxW WxxxxxW WxxxxxW        aaxxxxxxxxxxxxa  WxxxxW  axxxxa    |   '),nl,
    write('   |          WxxxxxWxxxxxW   WxxxxxWxxxxxW        axxxxaaaaxxxxxxa  WxxxxW  axxxxa    |   '),nl,
    write('   |           WxxxxxxxxxW     WxxxxxxxxxW        axxxxa    axxxxxa  WxxxxW  axxxxa    |   '),nl,
    write('   |            WxxxxxxxW       WxxxxxxxW         axxxxa    axxxxxa WxxxxxxWaxxxxxxa   |   '),nl,
    write('   |             WxxxxxW         WxxxxxW          axxxxxaaaaxxxxxxa WxxxxxxWaxxxxxxa   |   '),nl,
    write('   |              WxxxW           WxxxW            axxxxxxxxxxaaxxxaWxxxxxxWaxxxxxxa   |   '),nl,
    write('   |               WWW             WWW              aaaaaaaaaa  aaaaWWWWWWWWaaaaaaaa   |   '),nl,
    write('   |                                                                                   |   '),nl,
    write('   |                                                                                   |   '),nl,
    write('   |                               1 - PLAYER VS PLAYER                                |   '),nl,
    write('   |                               2 - PLAYER VS COMPUTER                              |   '),nl,
    write('   |                               3 - COMPUTER VS PLAYER                              |   '),nl,
    write('   |                               4 - COMPUTER VS COMPUTER                            |   '),nl,
    write('   |                               0 - EXIT                                            |   '),nl,
    write('   |                                                                                   |   '),nl,
    write('   *************************************************************************************   '),nl,nl.
 
                                                                             
display_game([H | T],WhitePieces,BlackPieces,Turn,Phase) :-
    nl,nl,nl,
    display_phase(Phase),
    display_nr_pieces(WhitePieces,BlackPieces),
    length(H, Width),
    display_letters(Width),
    nl, nl,
    display_board([H | T]),
    nl,
    display_turn(Turn).

display_phase(1) :- print_banner("PHASE 1",*, 7),nl,nl,nl.

display_phase(2) :- print_banner("PHASE 2",*, 7),nl,nl,nl.


display_nr_pieces(WhitePieces,BlackPieces) :- print_double_banner("White pieces: ",WhitePieces,"Black pieces: ",BlackPieces, *, 3),nl,nl,nl.


display_letters(Width) :- write('     '),display_letters(Width, 0).
display_letters(Width, Width) :- !.
display_letters(Width, ActualWidth) :-
    CharCode is ActualWidth + 65,
    put_code(CharCode),write('   '),
    NewWidth is ActualWidth + 1,
    display_letters(Width, NewWidth).


display_board(Board) :- display_board(Board, 1).
display_board([], _).
display_board([L | R], ActualHeight) :-
    write(' '),write(ActualHeight), write('   '),
    display_line(L), nl, nl,
    NewHeight is ActualHeight + 1,
    display_board(R, NewHeight).


display_line([]).
display_line([H | T]) :-
    display_piece(H),
    write('   '),
    display_line(T).
                                                                           
                                                                             
display_turn(0) :- print_banner("White's turn",*, 7),nl,nl.

display_turn(1) :- print_banner("Black's turn",*, 7),nl,nl.                                                                             
                                                                             
                                                                             
                                                                             












                               
                               
                               


                                                   


