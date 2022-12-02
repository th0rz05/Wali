initial_state([ [0,2,0,0,2,0],
                [0,0,1,0,0,0],
                [0,2,0,2,0,1],
                [2,0,0,1,0,0],
                [1,0,1,0,2,0]],12,12,0,1).

display_piece(0) :- put_code(32).

display_piece(1) :- put_code(9312).

display_piece(2) :- put_code(10103).