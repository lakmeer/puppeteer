
{ id, log } = require \std

{ Node } = require \./base


export class MouseNode extends Node

  output-spec = [ { type: SIGNAL_TYPE_POKE, on-pull: -> @state } ]

  (@button-index) ->
    super ...

    @generate-ports { output-spec }

    GlobalServices.EventSource.on \mousedown, (button) ~>
      if @button-index is button then @set on
      GlobalServices.Poke.poke!

    GlobalServices.EventSource.on \mouseup, (button) ~>
      if @button-index is button then @set off
      GlobalServices.Poke.poke!

    # Only block context menu if RMB is actually being requested

    if @button-index is MOUSE_RIGHT
      document.add-event-listener \contextmenu, (.prevent-default!)

