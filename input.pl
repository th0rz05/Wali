print_string([]).
print_string([Code | T]) :- char_code(Char, Code),
                            write(Char),
                            print_string(T).

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
                                       print_string("Choose an option[0-4] :"),
                                       read_number(Value),
                                       Value >= Min,
                                       Value =< Max,
                                       !.