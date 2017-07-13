# Travis falls back to using a Makefile if it doesn't find a rebar.config.

.PHONY: test
test:
	erlc rpncalc.erl
	ct_run -dir test -pa .

