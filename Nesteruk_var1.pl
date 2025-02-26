% Ємності трьох сосудів
capacities(8, 5, 3).

% Початковий стан
initial_state(state(3, 5, 0)).

% Фінальний стан
final_state(state(1, 4, 3)).

% Всі можливі варіанти переливання води
pour(state(A, B, C), state(A1, B1, C)) :- pour_one(A, B, A1, B1, 5). % A → B
pour(state(A, B, C), state(A1, B, C1)) :- pour_one(A, C, A1, C1, 3). % A → C
pour(state(A, B, C), state(A1, B1, C)) :- pour_one(B, A, B1, A1, 8). % B → A
pour(state(A, B, C), state(A, B1, C1)) :- pour_one(B, C, B1, C1, 3). % B → C
pour(state(A, B, C), state(A1, B, C1)) :- pour_one(C, A, C1, A1, 8). % C → A
pour(state(A, B, C), state(A, B1, C1)) :- pour_one(C, B, C1, B1, 5). % C → B

% Переливання з одного сосуду в інший
pour_one(From, To, FromNew, ToNew, CapTo) :-
    Transfer is min(From, CapTo - To), % Ллємо максимум можливого
    Transfer > 0, % Щоб перелити, сосуд не повинен бути пустим
    FromNew is From - Transfer,
    ToNew is To + Transfer.

% BFS пошук найкоротшого шляху
solve(Solution) :-
    initial_state(Start),
    final_state(Goal),
    bfs([[Start]], Goal, Path),
    reverse(Path, Solution).

% BFS: якщо поточний шлях приводить до розв’язку - повертаємо його
bfs([[State|Path] | _], Goal, [State|Path]) :-
    State = Goal.

% BFS: розширюємо чергу
bfs([[State | Path] | RestQueue], Goal, Solution) :-
    findall([NextState, State | Path],
            (pour(State, NextState), \+ member(NextState, [State | Path])),
            NewPaths),
    append(RestQueue, NewPaths, NewQueue),
    bfs(NewQueue, Goal, Solution).

