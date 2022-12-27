read_number_acc(X, X) :- peek_code(10), !.
read_number_acc(Acc, X) :- \+ peek_code(10),
                           get_code(Code),
                           char_code('0', Zero),
                           Digit is Code-Zero,
                           Digit >= 0,
                           Digit < 10,
                           NewAcc is Acc*10 + Digit,
                           read_number_acc(NewAcc, X).
read_number(X) :- read_number_acc(0, X),
                  get_code(10).

read_until_between(Min, Max, Value) :- repeat,
                                       print_string("Choose an option["),
                                       write(Min-Max),
                                       print_string("] : "),
                                       read_number(Value),
                                       Value >= Min,
                                       Value =< Max,
                                       !,nl.

read_string("") :- peek_code(10),
                   !,
                   get_code(_).
read_string([Char | T]) :- get_code(Char),
                           read_string(T).

read_move(X,Y,place) :- print_string("Choose a spot to place the piece(ex:a2): "),
                read_string(Move),
                length(Move,2),
                parse_move(Move,X,Y),nl.

read_move(X,Y,remove) :- print_string("Choose a spot to remove the piece(ex:a2): "),
                read_string(Move),
                length(Move,2),
                parse_move(Move,X,Y),nl.

read_move(X,Y,NewX,NewY) :- print_string("Choose a piece and valid move( u(up),d(down),l(left),r(right) -> ex:a2u): "),
                            read_string(Move),
                            length(Move,3),
                            parse_move(Move,X,Y,NewX,NewY),nl.