-module(fis_streamer).
-behaviour(gen_event).

-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3,
terminate/2]).

% Record which holds the current Request
-record(state, { request }).

init([Req]) ->
  Req:stream(head, [{"Content-Type", "text/event-stream"},{"Connection", "keep-alive"}]),
  {ok, #state{ request = Req }}.

handle_event({new_favicon, Url}, State) ->
  error_logger:info_msg("NEW FAVICON!!! ~p~n", [Url]),
  Req = State#state.request,
  Req:stream("data: Lolwhut\n\n"),
  {ok, State}.

handle_call(_, State) ->
{ok, ok, State}.

handle_info(_, State) ->
{ok, State}.

code_change(_OldVsn, State, _Extra) ->
{ok, State}.

terminate(_Reason, _State) ->
ok.



  % error_logger:info_msg("Header: ~p~n", [Req:get(headers)]),
  % error_logger:info_msg("Body: ~p~n",   [Req:get(body)]),
  % % send headers
  % Req:stream(head, [{"Content-Type", "text/event-stream"},{"Connection", "keep-alive"}]),
  % % send stream
  % Req:stream("id: 1\n"),
  % Req:stream("data: oh hai\n\n"),
  % timer:sleep(2000),
  % % send stream
  % Req:stream("id: 2\n"),
  % Req:stream("data: gibbet doch janich\n\n"),

  % timer:sleep(2000),
  % % send stream
  % Req:stream("id: 3\n"),
  % Req:stream("data: ick werd bekloppt\n\n"),
  % % close socket
  % Req:stream(close).