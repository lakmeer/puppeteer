
export class EventSource

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

