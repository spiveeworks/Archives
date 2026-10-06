-module(tree).
-compile(export_all).

-type tree(A) :: A | list(tree(A)).

uncons([]) ->
    error;
uncons([H | T]) ->
    case uncons(H) of
        error ->
            uncons(T);
        {ok, {X, []}} ->
            {ok, {X, T}};
        {ok, {X, NewH}} ->
            {ok, {X, [NewH | T]}}
    end;
uncons(X) ->
    {ok, {X, []}}.

uncons2([]) ->
    error;
uncons2([H | T]) when is_list(H) ->
    uncons2(H ++ T);
uncons2([H | T]) ->
    {ok, {H, T}};
uncons2(X) ->
    {ok, {X, []}}.

uncons3([]) ->
    error;
uncons3([[] | T]) ->
    uncons3(T);
uncons3([[H | T1] | T2]) ->
    uncons3([H | [T1 | T2]]);
uncons3([H | T]) ->
    {ok, {H, T}};
uncons3(X) ->
    {ok, {X, []}}.


uncons_r([]) ->
    error;
uncons_r([H | T]) ->
    io:format("Calling uncons_r(~p, ~p)~n", [H, T]),
    uncons_r(H, T);
uncons_r(X) ->
    {ok, {[], X}}.

uncons_r(Acc, []) ->
    io:format("Calling uncons_r(~p)~n", [Acc]),
    uncons_r(Acc);
uncons_r(Acc, [H]) ->
    io:format("Calling uncons_r(~p, ~p)~n", [Acc, H]),
    uncons_r(Acc, H);
uncons_r(Acc, [H | T]) ->
    io:format("Calling uncons_r(~p, ~p)~n", [[Acc, H], T]),
    uncons_r([Acc, H], T);
uncons_r(Acc, X) ->
    {ok, {Acc, X}}.


uncons_r2([]) ->
    error;
uncons_r2([H | []]) ->
    uncons_r2(H);
uncons_r2([H1 | [H2 | T]]) ->
    uncons_r2([[H1 | H2] | T]);
uncons_r2([H | T]) ->
    {ok, {H, T}};
uncons_r2(X) ->
    {ok, {[], X}}.


