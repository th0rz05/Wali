toNumber(1,'1').



initial_state([ [0,2,0,0,2,0],
                [0,0,1,0,0,0],
                [0,2,0,2,0,1],
                [2,0,0,1,0,0],
                [1,0,1,0,2,0]],12,12,whiteturn,1).

display_piece(0) :- put_code(32).

display_piece(1) :- put_code(9312).

display_piece(2) :- put_code(10103).

validate_move(X,Y) :- X >= 0, X < 6, Y >= 0, Y < 5.

parse_move([L|[N|[]]],X,Y) :- X is L-97 , Y is N-49.