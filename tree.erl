-module(tree).
-compile(export_all).

-type tree(A) :: A | list(tree(A)).

uncons([]) ->
    error;
uncons([H | T]) ->
    uncons(H, T);
uncons(X) ->
    {ok, {X, []}}.

uncons([], T) ->
    uncons(T);
uncons([H | T1], T2) ->
    uncons(H, [T1 | T2]);
uncons(H, T) ->
    {ok, {H, T}}.

uncons_r([]) ->
    error;
uncons_r([H | T]) ->
    uncons_r(H, T);
uncons_r(X) ->
    {ok, {[], X}}.

uncons_r(H, []) ->
    uncons_r(H);
uncons_r(H1, [H2 | T]) ->
    uncons_r([H1 | H2], T);
uncons_r(H, T) ->
    {ok, {H, T}}.

foldl(F, Acc, [])      -> Acc;
foldl(F, Acc, [H | T]) -> foldl(F, foldl(F, Acc, H), T);
foldl(F, Acc, X)       -> F(X, Acc).

foldr(F, Acc, [])      -> Acc;
foldr(F, Acc, [H | T]) -> foldl(F, foldl(F, Acc, T), H);
foldr(F, Acc, X)       -> F(X, Acc).

foldlflat(F, Acc, Tree) ->
    case uncons(Tree) of
        error ->
            Acc;
        {ok, {X, Rest}} ->
            NewAcc = F(X, Acc),
            foldlflat(F, NewAcc, Rest)
    end.

foldrflat(F, Acc, Tree) ->
    case uncons_r(Tree) of
        error ->
            Acc;
        {ok, {Rest, X}} ->
            NewAcc = F(X, Acc),
            foldlflat(F, NewAcc, Rest)
    end.

