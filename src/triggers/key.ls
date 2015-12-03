
{ Trigger } = require \./base

export class KeyTrigger extends Trigger

  (keycode) ->
    super ...

    document.add-event-listener \keydown, ({ which }) ~>
      if keycode is which then @set on

    document.add-event-listener \keyup, ({ which }) ~>
      if keycode is which then @set off

