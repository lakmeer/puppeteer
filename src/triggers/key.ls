
{ id, log } = require \std

{ Trigger } = require \./base
{ Output }  = require \../port

export class KeyTrigger extends Trigger

  output-spec = [ { type: SIGNAL_TYPE_POKE, on-pull: -> @state } ]

  (@keycode) ->
    super ...

    @generate-ports { output-spec }

    document.add-event-listener \keydown, ({ which }) ~>
      if @keycode is which then @set on

    document.add-event-listener \keyup, ({ which }) ~>
      if @keycode is which then @set off

