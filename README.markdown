## Usage

Install ```tcpflow``` and make sure it is available in your path. Make sure you
have the proper permissions to put you network interface in promiscuous mode.

You can get the latest version here: http://afflib.org/downloads/

Get the source:

```
git clone git://github.com/hukl/favicon_streamer.git

cd favicon_streamer
```

Edit ```apps/fis/src/fis.app.src``` and adjust the sniffer command, especially
the interface to use.

Then either run the app directly by invoking:

```
rebar get-deps
rebar compile

erl -pa deps/*/ebin apps/*/ebin

application:start(sasl).
application:start(fis).
```

Or generate a release which is a little more convenient to use:

```
cd rel
rebar create-node nodeid=fis
cd ..
rebar compile && rebar generate -f
./rel/fis/bin/fis console
```