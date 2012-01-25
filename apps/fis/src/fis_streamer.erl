-module(fis_streamer).

-behaviour(gen_event).

-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3,
terminate/2]).

init([RequestPid]) ->
  error_logger:info_msg("Eventhandler for: ~p~n", [RequestPid]),
  {ok, RequestPid}.

handle_event({favicon, Url}, RequestPid) ->
  error_logger:info_msg("NEW FAVICON!!! ~p~n", [Url]),
  RequestPid ! { favicon, Url },
  {ok, RequestPid}.

handle_call(_, State) ->
  {ok, ok, State}.

handle_info(_, State) ->
  {ok, State}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

terminate(_Reason, _State) ->
  ok.