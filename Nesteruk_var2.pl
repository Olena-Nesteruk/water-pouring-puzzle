capacities(8, 5, 3, 40).             % Ємності чотирьох сосудів
initial_state(state(8, 0, 0, 30)).   % Початковий стан
final_state(state(1, 5, 2, 33)).     % Фінальний стан

% Всі можливі варіанти переливання води між сосудами
pour(state(A, B, C, D), state(A1, B1, C, D)) :- pour_one(A, B, A1, B1, 5). % A → B
pour(state(A, B, C, D), state(A1, B, C1, D)) :- pour_one(A, C, A1, C1, 3). % A → C
pour(state(A, B, C, D), state(A1, B, C, D1)) :- pour_one(A, D, A1, D1, 40). % A → D 
pour(state(A, B, C, D), state(A1, B1, C, D)) :- pour_one(B, A, B1, A1, 8). % B → A
pour(state(A, B, C, D), state(A, B1, C1, D)) :- pour_one(B, C, B1, C1, 3). % B → C
pour(state(A, B, C, D), state(A, B1, C, D1)) :- pour_one(B, D, B1, D1, 40). % B → D 
pour(state(A, B, C, D), state(A1, B, C1, D)) :- pour_one(C, A, C1, A1, 8). % C → A
pour(state(A, B, C, D), state(A, B1, C1, D)) :- pour_one(C, B, C1, B1, 5). % C → B
pour(state(A, B, C, D), state(A, B, C1, D1)) :- pour_one(C, D, C1, D1, 40). % C → D 
pour(state(A, B, C, D), state(A1, B, C, D)) :- pour_one(D, A, D, A1, 8). % D → A 
pour(state(A, B, C, D), state(A, B1, C, D)) :- pour_one(D, B, D, B1, 5). % D → B 
pour(state(A, B, C, D), state(A, B, C1, D)) :- pour_one(D, C, D, C1, 3). % D → C 

% Переливання з одного сосуду в інший
pour_one(From, To, FromNew, ToNew, CapTo) :-
    Transfer is min(From, CapTo - To), % Ллємо максимум можливого
    Transfer > 0, % Щоб перелити, сосуд не повинен бути пустим
    FromNew is From - Transfer,
    ToNew is To + Transfer.

% BFS пошук найкоротшого шляху з урахуванням відвіданих станів
solve(Solution) :-
    initial_state(Start),
    final_state(Goal),
    bfs([[Start]], Goal, [], Path), % Додаємо список відвіданих станів
    reverse(Path, Solution).

% BFS: якщо перший шлях приводить до розв’язку - повертаємо його
bfs([[State|Path] | _], Goal, _, [State|Path]) :-
    match_goal(State, Goal).

% BFS: розширюємо чергу
bfs([[State | Path] | RestQueue], Goal, Visited, Solution) :-
    findall([NextState, State | Path],
            (pour(State, NextState), \+ member(NextState, [State | Path]), \+ member(NextState, Visited)),
            NewPaths),
    append(RestQueue, NewPaths, NewQueue),
    append(Visited, NewPaths, NewVisited), % Додаємо унікальні відвідані стани
    bfs(NewQueue, Goal, NewVisited, Solution).
match_goal(state(A, B, C, _), state(A, B, C, _)).
