#!/home/$USER/bin/swipl -f -q

:- initialization(main, program).

valid_entries(M, C) :-
    between(0, 3, M),
    between(0, 3, C).

safe(M, C) :-
    M >= C;
    M == 0;
    C == 0.

main() :-
    safe(2, 3),
    abort().
