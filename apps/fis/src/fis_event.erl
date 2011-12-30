-module(fis_event).

-export([start_link/0]).

start_link() ->
  { ok, Pid } = gen_event:start_link(),

  register(fis_event, Pid),

  { ok, Pid }.