:- consult('mc.pro').
% Bulk run tests with `run_tests().`. If any test fails, run_tests() will also fail.

% test cases to validate safety
test_1():- safe([3,3,left]).
test_2():- \+ safe([1,2,left]).
test_3():-
    move([3,3,left], S2, A),
    safe(S2),
    boats(B),
    member(A, B).

% test that last move in bfs solution is [0,0,right]. 
test_4():-
    solve_bfs(P),
    last(P, Last),
    Last == [0,0,right].

% test that last move in dfs solution is [0,0,right]. 
test_5():-
    solve_dfs(P),
    last(P, Last),
    Last == [0,0,right].


% print lengths of DFS and DFS paths
test_6():-
    solve_dfs(P_dfs),
    solve_bfs(P_bfs),
    
    length(P_dfs, Nodes_dfs),
    length(P_bfs, Nodes_bfs),

    L_dfs is Nodes_dfs - 1,
    L_bfs is Nodes_bfs - 1,
    
    write("Start Test 6: \n"),
    format("DFS length: ~w~n", [L_dfs]),
    format("BFS length: ~w~n", [L_bfs]),
    write("End Test 6: \n\n").



% checks that every consecutive pair in a path is a valid move
valid_path([_]).
valid_path([S1, S2 | Rest]) :-
    move(S1, S2, _),
    valid_path([S2 | Rest]).

test_7():-
    solve_dfs(P_dfs), valid_path(P_dfs),
    solve_bfs(P_bfs), valid_path(P_bfs).

% Ensure returned path is valid AND ends in goal
test_8():-
    solve_bfs(P),
    valid_path(P),
    last(P,[0,0,right]).

test_9():-
    solve_dfs(P),
    valid_path(P),
    last(P,[0,0,right]).

% Run all tests with `?- run_tests().`
% Only test 6 prints information regarding the test.
run_tests():-
    test_1(),
    test_2(),
    test_3(),
    test_4(),
    test_5(),
    test_6(),
    test_7(),
    test_8(),
    test_9().