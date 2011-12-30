
-module(fis_tcpflow).
-behavior(gen_server).

% Managment API
-export([start/0, start_link/0, stop/0]).

% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

% Public API
-export([]).

% Record which holds the Port
-record(state, { port, regex }).

%% ===================================================================
%% Management API
%% ===================================================================

start() ->
  gen_server:start( {local, ?MODULE}, ?MODULE, [], []).

start_link() ->
  gen_server:start_link( {local, ?MODULE}, ?MODULE, [], []).

stop() -> gen_server:cast(?MODULE, stop).

%% ===================================================================
%% gen_server callbacks
%% ===================================================================

init([]) ->
  Cmd   = "tcpflow -i en1 -c -s -b 1024 dst port 80",
  Port  = open_port({spawn, Cmd}, [stream, use_stdio, exit_status, binary]),

  { ok, Regex } = re:compile("GET\\s(.*\\.ico).+\\r\\nHost\\:\\s?(.+)\\b"),
  { ok, #state{ port = Port, regex = Regex } }.

handle_call( _Msg, _From, State ) ->
  { reply, ok, State }.

handle_cast( stop, State ) ->
  { stop, normal, State };

handle_cast( _Msg, State ) ->
  { noreply, normal, State }.

code_change(_OldVsn, State, _Extra) ->
  { ok, State }.

handle_info( Info, State ) ->
  {_, {data, Data}} = Info,
  case re:run( Data, State#state.regex, [global,{capture,[1,2],list}] ) of
    {match, [[Path,Host]]} ->
      error_logger:info_msg("Host: ~p~nPath: ~p~n", [Host, Path]);
    _ -> ok
  end,
  { noreply, State }.

terminate( _Reason, _State ) ->
  whatever.

%% ===================================================================
%% Public API
%% ===================================================================



