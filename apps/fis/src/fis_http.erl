-module(fis_http).

-export([start/1, stop/0, handle_http/1]).

% start misultin http server
start(Port) ->
    misultin:start_link([{port, Port}, {loop, fun(Req) -> handle_http(Req) end}]).

% stop misultin
stop() ->
    misultin:stop().

% callback on request received
handle_http(Request) ->
  handle(Request:get(method), Request:resource([lowercase, urldecode]), Request).

% delivers the sse html document
handle('GET', [], Request) ->
  Path = code:priv_dir(fis) ++ "/sse.html",
  error_logger:info_msg("Path: ~p~n", [Path]),
  Request:file( Path );

% starts on fis_
handle('GET', ["events"], Request) ->
  % register new event handler and pass Req as its state
  gen_event:add_handler( fis_event, fis_streamer, [self()]),

  Request:stream(
    head, [{"Content-Type", "text/event-stream"},{"Connection", "keep-alive"}]
  ),

  stream(Request);

handle('GET', [_], Request) ->
  Request:respond(400, [{"Content-Type", "text/plain"}], "Not Found").

stream(Request) ->
  receive
    closed ->
      do_funky_stuff;
    { favicon, FaviconUrl } ->
      Msg = ["data: ", FaviconUrl, "\n\n"],
      Request:stream( Msg ),
      stream( Request )
    after 1000 ->
      stream( Request )
    end.
