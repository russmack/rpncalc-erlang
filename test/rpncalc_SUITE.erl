-module(rpncalc_SUITE).
-compile(export_all).

all() ->
    [test_noargs, 
     test_empty,
     test_one_num, 
     test_two_num, 
     test_add, 
     test_sub, 
     test_mul, 
     test_div,
     test_mix1,
     test_mix2].

test_noargs(_Config) ->
    {error, _} = rpncalc:start().

test_empty(_Config) ->
    {error, _} = rpncalc:start("").

test_one_num(_Config) ->
    {ok, [2]} = rpncalc:calculate("2").

test_two_num(_Config) ->
    {ok, [3, 2]} = rpncalc:calculate("2 3").

test_add(_Config) ->
    {ok, [3]} = rpncalc:calculate("1 2 +").

test_sub(_Config) ->
    {ok, [2]} = rpncalc:calculate("7 5 -").

test_mul(_Config) ->
    {ok, [15]} = rpncalc:calculate("3 5 *").

test_div(_Config) ->
    {ok, [7.0]} = rpncalc:calculate("70 10 /").

test_mix1(_Config) ->
    {ok, [7.0]} = rpncalc:calculate("70 5 2 * /").

test_mix2(_Config) ->
    {ok, [8.0]} = rpncalc:calculate("10 2 3 + / 4 *").

