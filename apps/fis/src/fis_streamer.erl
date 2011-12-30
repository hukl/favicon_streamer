-module(fis_streamer).
-behaviour(gen_event).

-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3,
terminate/2]).

init([Req]) ->
  Req:stream(head, [{"Content-Type", "text/event-stream"},{"Connection", "keep-alive"}]),
  % send stream
  Req:stream("id: 0\n"),
  Req:stream("data: ick werd bekloppt\n\n"),
  error_logger:info_msg("Request in init: ~p~n", [Req]),
  {ok, Req}.

handle_event({new_favicon, Url}, Req) ->
  error_logger:info_msg("Request in handle_event: ~p~n", [Req]),
  error_logger:info_msg("NEW FAVICON!!! ~p~n", [Url]),
  Req:stream("id: 1\n"),
  Req:stream("data: ick werd beklopptTM\n\n"),
  {ok, Req}.

handle_call(_, State) ->
  {ok, ok, State}.

handle_info(_, State) ->
  {ok, State}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

terminate(_Reason, _State) ->
  ok.