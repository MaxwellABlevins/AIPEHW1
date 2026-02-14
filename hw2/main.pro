#!/home/$USER/bin/swipl -f -q

:- initialization(main, program).

valid_direction(D) :-
    D == left;
    D == right.

safe([M, C]) :-
    between(0, 3, M),
    between(0, 3, C),
    (
        M >= C;
        M == 0
    ).

safe([M, C, D]) :-
    valid_direction(D),
    safe([M, C]),

    MO is abs(M-3),
    CO is abs(C-3),

    safe([MD, CO]).

move([M,C,D], S2, A) :-
    

main :-
    safe([3, 3, left]),
    abort().
