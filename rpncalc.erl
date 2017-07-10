%%%-------------------------------------------------------------------
%% @doc rpncalc
%% @end
%%%-------------------------------------------------------------------

-module(rpncalc).
-export([start/0, start/1]).

%%====================================================================
%% API
%%====================================================================

start()     -> usage().
start(Args) ->
    S = string:trim(Args),
    calculate(S).


%%====================================================================
%% Internal functions
%%====================================================================

usage() ->
    io:format("Usage: rpncalc:start(\"8 6 4 2 + + + -\").").

calculate("")   -> io:format("Syntax error: too few values.~n");
calculate(Args) ->
    io:format("Calculating: ~s~n.", [Args]),

    Tokens = string:tokens(Args, " "),

    Result = parse(Tokens, []),
    io:format("Result: ~w~n", [Result]).

parse([], Stack)        -> Stack;
parse(Tokens, Stack)    -> 
    {NewTokens, NewStack} = stack_nums(Tokens, Stack),
    exec(NewTokens, NewStack).

stack_nums(Tokens, Stack) -> 
    [H|T] = Tokens,

    M = re:run(H, "^[0-9]*$"),

    case M of 
        {match, _}  -> stack_nums(T, [list_to_integer(H)|Stack]);
        nomatch     -> {Tokens, Stack}
    end.

op("+", A, B) -> A + B;
op("-", A, B) -> B - A;
op("*", A, B) -> A * B;
op("/", A, B) -> B / A.

exec(_, [H|[]])     -> H;
exec(Ops, Stack)    ->
    [H|T] = Ops,

    [A|A_stack_tail] = Stack,
    [B|B_stack_tail] = A_stack_tail,

    Result = op(H, A, B),

    exec(T, [Result|B_stack_tail]).

