% ==========================================
% Tic-Tac-Toe Minimax (Starter)
% Board: list of 9 cells, each x/o/e
% Max player: x
% Min player: o
% ==========================================

:- dynamic(expanded/1).

% ---------- instrumentation ----------
clear_count :- retractall(expanded(_)), assertz(expanded(0)).
inc_count   :- retract(expanded(N)), N1 is N+1, assertz(expanded(N1)).
get_count(N):- expanded(N).

% ---------- helpers ----------
other(x,o).
other(o,x).

% pretty print (optional)
print_board([A,B,C,D,E,F,G,H,I]) :-
    format("~w ~w ~w~n~w ~w ~w~n~w ~w ~w~n", [A,B,C,D,E,F,G,H,I]).

% ---------- winning lines ----------
line(1,2,3). line(4,5,6). line(7,8,9).
line(1,4,7). line(2,5,8). line(3,6,9).
line(1,5,9). line(3,5,7).

% win(+Board, +Player)
win(Board, P) :-
    line(I,J,K),
    nth1(I,Board,P),
    nth1(J,Board,P),
    nth1(K,Board,P).

% full(+Board)
full(Board) :- \+ member(e, Board).

% ---------- TODO A1: move/3 ----------

% move(+Board, +Player, -NextBoard)
% place Player in one empty cell

move(Board, Player, NextBoard) :-
    nth1(Index, Board, e),          % find empty position
    replace(Board, Index, Player, NextBoard).

replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]) :-
    I > 1,
    I1 is I - 1,
    replace(T, I1, X, R).

% ---------- TODO A2: terminal/1 and utility/2 Finished by Maxwell----------
terminal(Board) :-
    win(Board, x) ; win(Board, o) ; full(Board).

utility(Board, 1)  :- win(Board, x).
utility(Board, -1) :- win(Board, o).
utility(Board, 0)  :- full(Board), \+ win(Board, x), \+ win(Board, o).

% ---------- minimax ----------
% minimax_value(+Board, +Player, -Value)
minimax_value(Board, Player, Value) :-
    inc_count,
    ( terminal(Board) ->
        utility(Board, Value)
    ; Player == x ->
        % Max node: take maximum over children
        findall(V,
                ( move(Board, Player, B2),
                  other(Player, P2),
                  minimax_value(B2, P2, V)
                ),
                Vs),
        max_list(Vs, Value)
    ; % Min node: take minimum over children
        findall(V,
                ( move(Board, Player, B2),
                  other(Player, P2),
                  minimax_value(B2, P2, V)
                ),
                Vs),
        min_list(Vs, Value)
    ).

% ---------- TODO A4: best_move/4 ----------
% choose successor with best minimax value for Player

best_move(Board, Player, BestBoard, BestValue) :-
    findall((Value, NextBoard),
        ( move(Board, Player, NextBoard),
          other(Player, NextPlayer),
          minimax_value(NextBoard, NextPlayer, Value)
        ),
        Moves),
    choose_best(Player, Moves, (BestValue, BestBoard)).

choose_best(x, Moves, Best) :-
    max_member(Best, Moves).

choose_best(o, Moves, Best) :-
    min_member(Best, Moves).