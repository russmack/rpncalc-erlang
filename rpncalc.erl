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

parse([], Stack) -> {ok, Stack};
parse([H | T], Stack) when H == 32 -> parse(T, Stack);
parse($+, [A, B]) -> A + B;
parse($-, [A, B]) -> B - A;
parse($*, [A, B]) -> A * B;
parse($/, [A, B]) -> B / A;
parse([H | T], Stack) ->
    {N, R} = string:to_integer([H | T]),
    case N of
        error ->
            [A | A_stack_tail] = Stack,
            [B | B_stack_tail] = A_stack_tail,
            Result = parse(H, [A, B]),
            parse(T, [Result | B_stack_tail]);
        _ -> parse(R, [N | Stack])
    end.
