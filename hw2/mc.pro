/* =========================================================
   Programming Assignment #2
   Missionaries and Cannibals Problem

   State Representation
   A state is represented as:

        [ML, CL, Side]

   ML = number of missionaries on the left bank (0–3)
   CL = number of cannibals on the left bank (0–3)
   Side = location of the boat (left or right)

   The right bank is calculated as:
        MR = 3 - ML
        CR = 3 - CL

   Initial State
        start([3,3,left]).

   Goal State
        goal([0,0,right]).

   Search Implemented
   • Depth First Search (DFS) with cycle checking
   • Breadth First Search (BFS) with cycle checking
   • BFS guarantees the shortest solution path

   How to Run
   Load program in Prolog:

        ?- [mc].

   Run DFS solution:

        ?- run(dfs).

   Run BFS solution:

        ?- run(bfs).

   Validate a returned path:

        ?- solve_bfs(P), valid_path(P).

========================================================= */

start([3,3,left]).
goal([0,0,right]).
boats([[2,0],[0,2],[1,1],[1,0],[0,1]]).

% the state is safe if values are in range and on each bank
% there is either no missionaries or missionaries >= cannibals
safe([ML, CL, _]) :-
    between(0, 3, ML),
    between(0, 3, CL),
    MR is 3 - ML,
    CR is 3 - CL,
    (ML =:= 0 ; ML >= CL),
    (MR =:= 0 ; MR >= CR).

% moves transfer 1 or 2 people across the river
% boat(M, C) means M missionaries and C cannibals moved
% the resulting state has to be safe
move([ML, CL, left], [ML2, CL2, right], [M, C]) :-
    boats(Boats),
    member([M,C], Boats),
    ML2 is ML - M,
    CL2 is CL - C,
    safe([ML2, CL2, right]).

move([ML, CL, right], [ML2, CL2, left], [M, C]) :-
    boats(Boats),
    member([M,C], Boats),
    ML2 is ML + M,
    CL2 is CL + C,
    safe([ML2, CL2, left]).

% dfs explores paths in full before moving to the next.
% paths are stored reversed and flipped at the end
solve_dfs(Path) :-
    start(S),
    dfs_stack([[S]], RevPath),
    reverse(RevPath, Path).

dfs_stack([[State|Visited]|_], [State|Visited]) :-
    goal(State).

dfs_stack([[State|Visited]|OtherPaths], Path) :-
    findall(
        [Next, State|Visited],
        (move(State, Next, _),
         \+ member(Next, [State|Visited])),
        NewPaths
    ),
    append(NewPaths, OtherPaths, AllPaths),
    dfs_stack(AllPaths, Path).

% bfs explore depth levels in full before moving to the next
% this guarantees the shortest path
solve_bfs(Path) :-
    start(S),
    bfs([[S]], Path).

bfs([[State|Visited] | _], Path) :-
    goal(State),
    reverse([State|Visited], Path).

bfs([[State|Visited] | OtherPaths], Path) :-
    findall(
        [Next, State|Visited],
        (move(State, Next, _), \+ member(Next, [State|Visited])),
        NewPaths
    ),
    append(OtherPaths, NewPaths, AllPaths),
    bfs(AllPaths, Path).

% prints each state and the action taken to get to the next one
print_path([]).

print_path([State]) :-
    State = [ML, CL, Direction],
    MR is 3 - ML,
    CR is 3 - CL,
    format("[~wM, ~wC], [~wM ~wC] | ~w\t|~n", [ML, CL, MR, CR, Direction]).

print_path([S1, S2 | Rest]) :-
    move(S1, S2, Action),
    S1 = [ML, CL, Direction],
    MR is 3 - ML,
    CR is 3 - CL,
    format("[~wM, ~wC], [~wM ~wC] | ~w\t| Boat: ~w~n", [ML, CL, MR, CR, Direction, Action]),
    print_path([S2 | Rest]).

% run(dfs) or run(bfs) to find and print a solution
run(dfs) :-
    solve_dfs(Path),
    write('DFS'), nl,
    print_path(Path),
    length(Path, Len),
    Crossings is Len - 1,
    write('crossings: '), write(Crossings), nl.

run(bfs) :-
    solve_bfs(Path),
    write('BFS'), nl,
    print_path(Path),
    length(Path, Len),
    Crossings is Len - 1,
    write('Crossings: '), write(Crossings), nl.