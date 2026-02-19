#!/home/$USER/bin/swipl -f -q

:- initialization(main(S, G), program).


start([[3,3,left], [0,0,right]]).
goal([[0,0,left], [3,3,right]]).
boat(A,B).

valid_sides([left, right]).

valid_boats([
    [2, 0],
    [0, 2],
    [1, 0],
    [0, 1],
    [1, 1]
]).

safe([M, C]) :-
    between(0, 3, M),
    between(0, 3, C),
    (
        M >= C;
        M == 0
    ).

safe([M, C, _]) :-
    safe([M, C]),

    MO is abs(M-3),
    CO is abs(C-3),

    safe([MO, CO]).

action(M, C) :-
    M + C < 3,
    M + C > 0.

move([M1,C1,S1], [M2,C2,S2], A) :-
    valid_boats(B),
    member(A, B),

    valid_sides(SS),

    member(S1, SS),
    member(S2, SS),

    safe([M1,C1,S1]),

    A = [MM,CM],

    M1 is M1 - MM,
    C1 is C1 - CM,

    M2 is M2 - MM,
    C2 is C2 - CM.

dfs(Curr) :- 
    goal(G),
    Curr == G,
    Curr is [SL, SR],
    SL is [M1,C1,S1],
    SR is [M2,C2,S2],

    move([M1,C1,S1], [M2,C2,S2], [_, _]).

main(SL, SR) :-
    start([SL, SR]),
    dfs([SL, SR]).