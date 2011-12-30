-module(fis_http).

-export([start/1, stop/0]).

% start misultin http server
start(Port) ->
    misultin:start_link([{port, Port}, {loop, fun(Req) -> handle_http(Req) end}]).

% stop misultin
stop() ->
    misultin:stop().

% callback on request received
handle_http(Req) ->
  handle(Req:get(method), Req:resource([lowercase, urldecode]), Req).

% delivers the sse html document
handle('GET', [], Req) ->
  Req:file("/www/favicon_sniffer/public/sse-node.html");

% starts on fis_
handle('GET', ["events"], Req) ->
  % register new event handler and pass Req as its state
  ok.