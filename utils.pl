initial_state([ [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0],
                [0,0,0,0,0,0]],12,12,whiteturn,1).

display_piece(0) :- put_code(32).

display_piece(1) :- put_code(9312).

display_piece(2) :- put_code(10103).

switch_turns(whiteturn,blackturn).
switch_turns(blackturn,whiteturn).

parse_move([L|[N|[]]],X,Y) :- Y is L-97 , X is N-49.

replace([H1|T1], 0, H1, N, [N|T1]).
replace([H1|T1], X, O, N, L2) :- X > 0,
                                X1 is X-1,
                                replace(T1,X1,O,N,L3),
                                L2 = [H1|L3].
