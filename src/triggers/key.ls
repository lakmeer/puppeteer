
{ id, log } = require \std

{ Trigger } = require \./base
{ Output }  = require \../port


export class KeyTrigger extends Trigger

  output-spec = [ { type: SIGNAL_TYPE_POKE, on-pull: -> @state } ]

  (@keycode) ->
    super ...

    @generate-ports { output-spec }

    GlobalServices.EventSource.on \keydown, ~> if @keycode is it then @set on
    GlobalServices.EventSource.on \keyup,   ~> if @keycode is it then @set off

  set: ->
    GlobalServices.Poke.poke!
    super ...

