
{ id, log } = require \std

{ Trigger } = require \./base


export class MouseTrigger extends Trigger

  output-spec = [ { type: SIGNAL_TYPE_POKE, on-pull: -> @state } ]

  (@button-index) ->
    super ...

    @generate-ports { output-spec }

    document.add-event-listener \mousedown, ({ button }:event) ~>
      if @button-index is button then @set on

    document.add-event-listener \mouseup, ({ button }) ~>
      if @button-index is button then @set off


    # Only block context menu if RMB is actually being requested

    if @button-index is MOUSE_RIGHT
      document.add-event-listener \contextmenu, (.prevent-default!)

