% print_string(+String)
% +String -> String to be printed
% Description : prints a string to the output
print_string([]).
print_string([Code | T]) :- char_code(Char, Code),
                            write(Char),
                            print_string(T).

% print_n(+Symbol,+N)
% +Symbol -> Symbol to be printed
% +N -> Number of times
% Description : prints a symbol n times
print_n(_, 0).
print_n(Symbol, N) :- N > 0,
                      N1 is N-1,
                      write(Symbol),
                      print_n(Symbol, N1).

% draw_menu(+Items,+Size)
% +Items -> Items of the banner
% +Size -> Size of the banner
% Description : draws a banner with somes items
draw_menu(Items,Size) :-
    draw_top_line(Size),
    draw_items(Items,Size),
    draw_bottom_line(Size).

% draw_top_line(+Size)
% +Size -> Size of the banner
% Description : draws the top line of the banner
draw_top_line(Size) :-
    put_code(0x2554), % draw the top left corner
    draw_horizontal(0x2550, Size), % draw horizontal lines
    put_code(0x2557), % draw the top right corner
    nl.

% draw_bottom_line(+Size)
% +Size -> Size of the banner
% Description : draws the bottom line of the banner
draw_bottom_line(Size):-
    put_code(0x255A), % draw the bottom left corner
    draw_horizontal(0x2550, Size), % draw horizontal lines
    put_code(0x255D), % draw the bottom right corner
    nl.

% draw_horizontal(+Code,+N)
% +Code -> Code of the symbol
% +N -> Number of symbols
% Description : draws a line of symbols
draw_horizontal(Code, N) :-
    N > 0,
    put_code(Code),
    N1 is N - 1,
    draw_horizontal(Code, N1).
draw_horizontal(_, 0). % base case

% draw_items(+Items,+Size)
% +Items -> Items of the banner
% +Size -> Size of the banner
% Description : draws the items of the banner
draw_items([],_) :- !.
draw_items([Item|Items],Size) :-
    draw_item(Item,Size),
    draw_items(Items,Size).

% draw_item(+Item,+Size)
% +Item -> Item of the banner
% +Size -> Size of the banner
% Description : draws an item of the banner
draw_item(Item,Size) :-
    put_code(0x2551), % draw the left side of the box
    length(Item,Length),
    draw_padding((Size-Length)/2),
    draw_text(Item), % draw the text of the item
    draw_padding((Size-Length)/2),
    put_code(0x2551), % draw the right side of the box
    nl.

% draw_padding(+N)
% +N -> Number of paddings
% Description : draws a padding for centering the item of the banner
draw_padding(N) :-
    N > 0,
    put_code(0x20), % add a space
    N1 is N - 1,
    draw_padding(N1).
draw_padding(_). % base case

% draw_text(+Text)
% +Text -> Text to drawn to the screen
% Description : draws a text in the screen
draw_text(Text) :-
    draw_codes(Text).

% draw_codes(+String)
% +String -> String to be printed
% Description : helper function to draw_text
draw_codes([]) :- !.
draw_codes([Code|Codes]) :-
    put_code(Code),
    draw_codes(Codes).

% display_start_menu
% Description : displays the start menu
display_start_menu :- draw_menu([ 
            " ",
            "@@@@@@@@                           @@@@@@@@                    @@@@@@@     @@@@  ",
            "@@@@@@@@                           @@@@@@@@                    @@@@@@@    @@@@@@ ",
            "@@@@@@@@                           @@@@@@@@                    @@@@@@@     @@@@  ",
            "@@@@@@@@                           @@@@@@@@                    @@@@@@@           ",
            " @@@@@@@           @@@@@           @@@@@@@  @@@@@@@@@@@@@       @@@@@@   @@@@@@@ ",
            "  @@@@@@@         @@@@@@@         @@@@@@@   @@@@@@@@@@@@@@      @@@@@@   @@@@@@@ ",
            "   @@@@@@@       @@@@@@@@@       @@@@@@@    @@@@@@@@@@@@@@@     @@@@@@    @@@@@@ ",
            "    @@@@@@@     @@@@@@@@@@@     @@@@@@@              @@@@@@     @@@@@@    @@@@@@ ",
            "     @@@@@@@   @@@@@@@@@@@@@   @@@@@@@        @@@@@@@@@@@@@     @@@@@@    @@@@@@ ",
            "      @@@@@@@ @@@@@@@ @@@@@@@ @@@@@@@       @@@@@@@@@@@@@@@     @@@@@@    @@@@@@ ",
            "       @@@@@@@@@@@@@   @@@@@@@@@@@@@       @@@@@@@@@@@@@@@@     @@@@@@    @@@@@@ ",
            "        @@@@@@@@@@@     @@@@@@@@@@@       @@@@@@    @@@@@@@     @@@@@@    @@@@@@ ",
            "         @@@@@@@@@       @@@@@@@@@        @@@@@@    @@@@@@@    @@@@@@@@  @@@@@@@@",
            "          @@@@@@@         @@@@@@@         @@@@@@@@@@@@@@@@@    @@@@@@@@  @@@@@@@@",
            "           @@@@@           @@@@@           @@@@@@@@@@@@@@@@@   @@@@@@@@  @@@@@@@@",
            "            @@@             @@@             @@@@@@@@@@  @@@@@  @@@@@@@@  @@@@@@@@",
            " ",
            " ",
            "1 - PLAYER VS PLAYER     ",
            "2 - PLAYER VS COMPUTER   ",
            "3 - COMPUTER VS PLAYER   ",
            "4 - COMPUTER VS COMPUTER ",
            "5 - INSTRUCTIONS         ",
            "0 - EXIT                 ",
            " ",
            " "
            ],85),nl.

% display_select_board_menu
% Description : displays the select board size menu
display_select_board_menu :-draw_menu([ 
            " ",
            " ",
            "Select board size",
            " ",
            "1 - NORMAL (6X5) ",
            "2 - BIG    (9X8) ",
            " ",
            " "
            ],85),nl.

% display_select_difficulty_menu(+Player)
% +Player -> white or black
% Description : displays the select difficulty menu
display_select_difficulty_menu(white) :-draw_menu([ 
            " ",
            " ",
            "Select white AI difficulty ",
            " ",
            "1 - EASY   ",
            "2 - MEDIUM ",
            "3 - HARD   ",
            " ",
            " "
            ],85),nl.

display_select_difficulty_menu(black) :- draw_menu([ 
            " ",
            " ",
            "Select black AI difficulty ",
            " ",
            "1 - EASY   ",
            "2 - MEDIUM ",
            "3 - HARD   ",
            " ",
            " "
            ],85),nl.

% display_instructions
% Description : displays the game instructions
display_instructions :- draw_menu([ 
            " ",
            "INSTRUCTIONS ",
            " ",
            "The original game is played on a 5x6 square board with 12 stones per player but",
            "you can play the giant version with a 8x9 board with 22 stones per player.     ",
            " ",
            "In PHASE1, players take turns dropping their stones onto the board in spots not",
            "orthogonaly adjacent to friendly stones trying to place them strategically.    ",
            " ",
            "In PHASE2, players take turns moving their stones to adjacent empty spaces on  ",
            "the board, trying to create exactly 3 pieces in a row (horizontal or vertical) ",
            "to capture their opponent's stones.                                            ",
            " ",
            "The winner is the person who leaves their opponent with 2 or less stones.      ",
            " ",
            "0 - EXIT ",
            " "
            ],85),nl.

% display_game(+Board,+WhitePieces,+BlackPieces,+Turn,+Phase)
% +Board -> 2D list representing the board 
% +WhitePieces -> Number of current white pieces
% +BlackPieces -> Number of current black pieces
% +Turn -> Current turn
% +Phase -> Current phase
% Description : displays the current game
display_game(Board,WhitePieces,BlackPieces,Turn,Phase) :-
    display_phase(Phase),
    display_nr_pieces(WhitePieces,BlackPieces),
    display_board(Board),
    nl,
    display_turn(Turn).

% display_phase(+Phase)
% +Phase -> Number indicating the game phase
% Description : displays the current phase
display_phase(1) :- draw_menu([ " ",
                                "PHASE 1",
                                " "
                                ],85),nl.

display_phase(2) :- draw_menu([ " ",
                                "PHASE 2",
                                " "
                                ],85),nl.

% display_nr_pieces(+WhitePieces,+BlackPieces)
% +WhitePieces -> Number of current white pieces
% +BlackPieces -> Number of current black pieces
% Description : displays the current number of pieces
display_nr_pieces(WhitePieces,BlackPieces) :- 
                    display_pieces(WhitePieces,BlackPieces,String),
                    draw_menu([ " ",
                                String,
                                " "
                                ],85),nl,nl.

% display_piece(+Number)
% +Number -> Number of the internal representation
% Description : displays a piece
display_piece(0) :- write('     ').

display_piece(1) :- write('  '),put_code(0x25CE),write('  ').

display_piece(2) :- write('  '),put_code(0x25C9),write('  ').

% display_letters(+Width)
% +Width -> Width of the board
% Description : displays the letters on top of the board
display_letters(Width) :-   NumberSpaces is 42-((Width+1)*3),
                            print_n(' ',NumberSpaces),
                            write('     '),display_letters(Width, 0).

% display_letters(+Width,+CurrentWidth)
% +Width -> Width of the board
% +CurrentWidth -> Current width
% Description : helper function to display_letters                 
display_letters(Width, Width) :- !.
display_letters(Width, ActualWidth) :-
    CharCode is ActualWidth + 65,
    write('   '),
    put_code(CharCode),
    write('  '),
    NewWidth is ActualWidth + 1,
    display_letters(Width, NewWidth).

% display_board(+Board)
% +Board -> 2D list representing the board 
% Description : displays the board
display_board(Board):-
    board_size(Board,Width,Height),
    display_letters(Width),nl,
    display_board(Board, Height).

% display_board(+CurrentBoard,+Height)
% +CurrentBoard -> 2D list representing the current board 
% +Height -> Height of the board
% Description : helper function to display the board
display_board([Row|[]], Height):-
    !,%last row
    display_last_row(Row,Height).

display_board([Row|RestOfRows], Height):- 
    length([Row|RestOfRows], ActualHeight),
    ActualHeight =:= Height,
    !,% first row
    display_first_row(Row),
    display_board(RestOfRows, Height).

display_board([Row|RestOfRows], Height):-
    length([Row|RestOfRows], ActualHeight),
    CurrentHeight is Height - ActualHeight + 1,
    display_middle_row(Row,CurrentHeight),
    display_board(RestOfRows, Height).

% display_piece_row(+Row)
% +Row -> List representing the row 
% Description : displays a row of pieces
display_piece_row([]):-
    !,
    put_code(0x2551),nl.

display_piece_row([Piece|Rest]):-
    put_code(0x2551), 
    display_piece(Piece),
    display_piece_row(Rest).

% display_first_row(+Row)
% +Row -> List representing the row 
% Description : displays the top of the board and the row of pieces
display_first_row(Row):-
    length(Row, Width),NumberSpaces is 42-((Width+1)*3),
    print_n(' ',NumberSpaces),write('     '),display_top_of_board(1,Width),
    print_n(' ',NumberSpaces),write('  1  '),display_piece_row(Row).

% display_top_of_board(+CurrentWidth,+Width)
% +CurrentWidth -> Current width
% +Width -> Width of the board
% Description : displays the top divider of the board
display_top_of_board(1, Width):-
    !,
    put_code(0x2554),
    put_code(0x2550), put_code(0x2550),put_code(0x2550),put_code(0x2550),put_code(0x2550),
    display_top_of_board(2, Width).

display_top_of_board(Width, Width):-
    !,
    put_code(0x2566), 
    put_code(0x2550), put_code(0x2550), put_code(0x2550),put_code(0x2550),put_code(0x2550),
    put_code(0x2557),nl.

display_top_of_board(Size, Width):-
    put_code(0x2566), 
    put_code(0x2550), put_code(0x2550),put_code(0x2550),put_code(0x2550),put_code(0x2550),
    NewSize is Size + 1,
    display_top_of_board(NewSize, Width).

% display_middle_row(+Row,+CurrentHeight)
% +Row -> List representing the row 
% +CurrentHeight -> Current height
% Description : displays a middle separator and the row of pieces
display_middle_row(Row,CurrentHeight):-
    length(Row, Width),NumberSpaces is 42-((Width+1)*3),
    print_n(' ',NumberSpaces),write('     '),display_middle_separator(1,Width),
    print_n(' ',NumberSpaces),write('  '),write(CurrentHeight),write('  '),
    display_piece_row(Row).

% display_middle_separator(+CurrentWidth,+Width)
% +CurrentWidth -> Current width
% +Width -> Width of the board
% Description : displays the middle divider of the board
display_middle_separator(1, Width):-
    !,
    put_code(0x2560), 
    put_code(0x2550), put_code(0x2550),put_code(0x2550),put_code(0x2550),put_code(0x2550),
    display_middle_separator(2, Width).

display_middle_separator(Width, Width):-
    !,
    put_code(0x256C), 
    put_code(0x2550), put_code(0x2550),put_code(0x2550),put_code(0x2550),put_code(0x2550),
    put_code(0x2563),nl.

display_middle_separator(Size, Width):-
    put_code(0x256C),
    put_code(0x2550), put_code(0x2550),put_code(0x2550),put_code(0x2550),put_code(0x2550),
    NewSize is Size + 1,
    display_middle_separator(NewSize, Width).

% display_last_row(+Row,+CurrentHeight)
% +Row -> List representing the row 
% +CurrentHeight -> Current height
% Description : displays a middle separator ,the row of pieces and bottom divider of the board
display_last_row(Row,CurrentHeight):-
    length(Row, Width),NumberSpaces is 42-((Width+1)*3),
    print_n(' ',NumberSpaces),write('     '),display_middle_separator(1,Width),
    print_n(' ',NumberSpaces),write('  '),write(CurrentHeight),write('  '),display_piece_row(Row),
    print_n(' ',NumberSpaces),write('     '),display_bottom_of_board(1,Width).

% display_bottom_of_board(+CurrentWidth,+Width)
% +CurrentWidth -> Current width
% +Width -> Width of the board
% Description : displays the bottom divider of the board
display_bottom_of_board(1, Width):-
    !,
    put_code(0x255A), 
    put_code(0x2550), put_code(0x2550),put_code(0x2550),put_code(0x2550),put_code(0x2550),
    display_bottom_of_board(2, Width).

display_bottom_of_board(Width, Width):-
    !,
    put_code(0x2569), 
    put_code(0x2550), put_code(0x2550),put_code(0x2550),put_code(0x2550),put_code(0x2550),
    put_code(0x255D),nl.

display_bottom_of_board(Size, Width):-
    put_code(0x2569),
    put_code(0x2550), put_code(0x2550),put_code(0x2550),put_code(0x2550),put_code(0x2550),
    NewSize is Size + 1,
    display_bottom_of_board(NewSize, Width).

% display_turn(+Turn) 
% +Turn -> Current turn
% Description : displays the current turn                                                                    
display_turn(whiteturn) :- draw_menu([ " ",
                                "White's turn ",
                                " "
                                ],85),nl.

display_turn(blackturn) :- draw_menu([ " ",
                                "Black's turn ",
                                " "
                                ],85),nl.

% display_3_in_a_row 
% Description : displays that a 3 in a row exists
display_3_in_a_row :- draw_menu([ " ",
                                "3 IN A ROW!",
                                " "
                                ],85),nl.   

% display_pieces(+WhitePieces,+BlackPieces,-String)
% +WhitePieces -> Number of current white pieces
% +BlackPieces -> Number of current black pieces
% -String -> String with the number of pieces information
% Description : transforms the pieces information into a string
display_pieces(WhitePieces,BlackPieces,String) :-
                    display_color_piece(white,WhitePieces,WhiteString),
                    display_color_piece(black,BlackPieces,BlackString),
                    append(WhiteString,"           ", TempString1),
                    append(TempString1, BlackString,String).

% display_color_piece(+Color,+Pieces,-String)
% +Color -> Color of the pieces
% +Pieces -> Number of pieces
% -String -> String with the number of pieces information
% Description : transforms the piece color information into a string for each color
display_color_piece(white,Pieces,String) :-
                    Pieces > 9,!,
                    Tens is Pieces // 10,
                    Units is Pieces mod 10,
                    AsciiTens is Tens + 48,
                    AsciiUnits is Units + 48,
                    append(" White Pieces : ",[AsciiTens,AsciiUnits], String).

display_color_piece(white,Pieces,String) :-
                    Ascii is Pieces + 48,
                    append("White Pieces : ",[Ascii], String).

display_color_piece(black,Pieces,String) :-
                    Pieces > 9,!,
                    Tens is Pieces // 10,
                    Units is Pieces mod 10,
                    AsciiTens is Tens + 48,
                    AsciiUnits is Units + 48,
                    append(" Black Pieces : ",[AsciiTens,AsciiUnits], String).

display_color_piece(black,Pieces,String) :-
                    Ascii is Pieces + 48,
                    append("Black Pieces : ",[Ascii], String).

% display_move(+Type,+MoveX,+MoveY,-String)
% +Type -> Type of move
% +MoveX -> X of the move
% +MoveY -> Y of the move
% -String -> String with the move information
% Description : transforms the move into a string
display_move(place,MoveX,MoveY,String) :-
                    letter_to_number(MoveX,Letter),
                    NewMoveY is MoveY+1,
                    AsciiNumber is NewMoveY + 48,
                    append("Computer will place a piece in ",Letter, TempString),
                    append(TempString,[AsciiNumber],String).

display_move(remove,MoveX,MoveY,String) :-
                    letter_to_number(MoveX,Letter),
                    NewMoveY is MoveY+1,
                    AsciiNumber is NewMoveY + 48,
                    append(" Computer will remove a piece from ",Letter, TempString),
                    append(TempString,[AsciiNumber],String).        

% display_move(+Type,+MoveX,+MoveY,+NewX,+NewY,-String)
% +Type -> Type of move
% +MoveX -> X of the move
% +MoveY -> Y of the move
% +NewX -> NewX of the move
% +NewY -> NewY of the move
% -String -> String with the move information
% Description : transforms the move into a string
display_move(move,MoveX,MoveY,NewX,NewY,String) :-
                    letter_to_number(MoveX,Letter),
                    NewMoveY is MoveY+1,
                    AsciiNumber is NewMoveY + 48,
                    append("Computer will make a move from ",Letter, TempString1),
                    append(TempString1,[AsciiNumber],TempString2),
                    append(TempString2," to ",TempString3),
                    letter_to_number(NewX,NewLetter),
                    NewNewY is NewY+1,
                    NewAsciiNumber is NewNewY + 48,
                    append(TempString3,NewLetter, TempString4),
                    append(TempString4,[NewAsciiNumber],String).

% congratulate_winner(+Winner)
% +Winner -> Winner of the game
% Description : displays the winner of the game
congratulate_winner(white) :- draw_menu(
                            [ " ",
                            "WINNER!! ",
                            "CONGRATULATIONS PLAYER WITH WHITE PIECES ",
                            " "
                            ],85).

congratulate_winner(black) :- draw_menu(
                            [ " ",
                            "WINNER!! ",
                            "CONGRATULATIONS PLAYER WITH BLACK PIECES ",
                            " "
                            ],85).                                                   

% press_any_key_to_continue(+Type)   
% +Type -> Type of the event
% Description : informs the user of an event and waits for an enter to be pressed                                                                
press_any_key_to_continue(phase2) :-
    draw_menu([ " ",
                "NO MOVES POSSIBLE",
                "PHASE 2 STARTING ",
                " ",
                "  Press ENTER to CONTINUE... ",
                " "
                ],85),
    nl,get_char(_),nl.

press_any_key_to_continue(pass) :-
    draw_menu([ " ",
                "NO MOVES POSSIBLE",
                " ",
                "  Press ENTER to CONTINUE... ",
                " "
                ],85),
    nl,get_char(_),nl.

% press_any_key_to_continue(+Type,+MoveX,+MoveY)   
% +Type -> Type of the event
% +MoveX -> X of the move
% +MoveY -> Y of the move
% Description : informs the user of an event and waits for an enter to be pressed  
press_any_key_to_continue(ai_place,MoveX,MoveY) :-
    display_move(place,MoveX,MoveY,String),
    draw_menu([ " ",
                String,
                " ",
                "Press ENTER to CONTINUE... ",
                " "
                ],85),
    nl,get_char(_),nl.

press_any_key_to_continue(ai_remove,MoveX,MoveY) :-
    display_move(remove,MoveX,MoveY,String),
    draw_menu([ " ",
                String,
                " ",
                "Press ENTER to CONTINUE... ",
                " "
                ],85),
    nl,get_char(_),nl.

% press_any_key_to_continue(+Type,+MoveX,+MoveY,+NewX,+NewY)   
% +Type -> Type of the event
% +MoveX -> X of the move
% +MoveY -> Y of the move
% +NewX -> NewX of the move
% +NewY -> NewY of the move
% Description : informs the user of an event and waits for an enter to be pressed 
press_any_key_to_continue(ai_move,MoveX,MoveY,NewX,NewY) :-
    display_move(move,MoveX,MoveY,NewX,NewY,String),
    draw_menu([ " ",
                String,
                " ",
                "Press ENTER to CONTINUE... ",
                " "
                ],85),
    nl,get_char(_),nl.












                               
                               
                               


                                                   


