%%%-------------------------------------------------------------------
%% @doc rpncalc
%% @end
%%%-------------------------------------------------------------------

-module(rpncalc).

-export([calculate/1, start/0, start/1]).

%%====================================================================
%% API
%%====================================================================

start() -> usage().

start(Args) ->
    S = string:trim(Args),
    Result = calculate(S),
    case Result of
      {error, E} -> io:format("Error: ~w~n", [E]);
      {ok, R} -> io:format("Result: ~w~n", [R])
    end,
    Result.

%%====================================================================
%% Internal functions
%%====================================================================

usage() ->
    io:format("Usage: rpncalc:start(\"8 6 4 2 + + -\").~n"),
    {error, "Bad usage."}.

calculate("") -> {error, "Empty."};
calculate(Args) ->
    io:format("Calculating: ~s...~n", [Args]),
    Result = parse(Args, []),
    Result.

parse([], _Stack) -> {error, "Nothing to calculate."};
parse([H | T], Stack) when H == 32 -> parse(T, Stack);
parse(S, Stack) ->
    {N, R} = string:to_integer(S),
    case N of
      error -> exec(hd([S]), Stack);
      _ -> parse(R, [N | Stack])
    end.

op($+, A, B) -> A + B;
op($-, A, B) -> B - A;
op($*, A, B) -> A * B;
op($/, A, B) -> B / A.

exec([H | T], Stack) when H == 32 -> exec(T, Stack);
exec(_, [H]) -> {ok, H};
exec([H_ops | T_ops], Stack) ->
    [A | A_stack_tail] = Stack,
    [B | B_stack_tail] = A_stack_tail,
    Result = op(H_ops, A, B),
    exec(T_ops, [Result | B_stack_tail]).
