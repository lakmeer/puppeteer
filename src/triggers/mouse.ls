
{ id, log } = require \std

{ Trigger } = require \./base


export class MouseTrigger extends Trigger

  (button-index) ->
    super ...

    document.add-event-listener \mousedown, ({ button }:event) ~>
      if button-index is button then @set on

    document.add-event-listener \mouseup, ({ button }) ~>
      if button-index is button then @set off


    # Only block context menu if RMB is actually being requested

    if button-index is MOUSE_RIGHT
      document.add-event-listener \contextmenu, (.prevent-default!)

