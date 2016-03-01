
# Require

{ id, log, invoke, raf } = require \std


# Globally-available Service Locators

class PokeService

  ->
    @callbacks = []
    @poke-scheduled = false

  on-poke: (λ) ->
    @callbacks.push λ

  dispatch: ->
    @callbacks.map invoke
    @poke-scheduled = false

  poke: ->
    @schedule-poke!

  schedule-poke: ->
    if not @poke-scheduled
      @poke-scheduled = true
      raf this~dispatch


class EventSource

  ->
    @callbacks =
      keydown:   []
      keyup:     []
      mousedown: []
      mouseup:   []

    @establish-listeners!

  dispatch: (event-name, value) ~~>
    @callbacks[event-name].map -> it value

  listener: (event-name) ->
    @socket.on event-name, @dispatch event-name

  on: (event, λ) ->
    if @callbacks[event]?
      that.push λ
    else
      console.warn "GlobalServices.EventSource.on - not registering unknown event name: '#event'"

  establish-listeners: ->
    @listener \keydown,   (.which)
    @listener \keyup,     (.which)
    @listener \mousedown, (.button)
    @listener \mouseup,   (.button)


class BrowserEventSource extends EventSource

  listener: (event-name, processor) ->
    document.add-event-listener event-name, processor >> @dispatch event-name


class WebsocketEventSource extends EventSource

  ->
    @socket = io(CONFIG_SOCKET_SERVER_ADDR)
    super ...
    @socket.on \connect,    -> console.info \connect
    @socket.on \disconnect, -> console.warn \disconnect

  dispatch: (event-name, value) ~~>
    log \dispatch event-name, value
    @callbacks[event-name].map -> it value


# Set up global access

global.GlobalServices =

  Poke: new PokeService

  EventSource:
    switch CONFIG_EVENT_SOURCE
    | EVENT_SOURCE_WEBSOCKETS => new WebsocketEventSource
    | EVENT_SOURCE_BROWSER    => new BrowserEventSource

