
{ id, log } = require \std

{ Trigger } = require \./base

keysymbols =
  90: \Z
  88: \X
  67: \C
  86: \V


export class KeyTrigger extends Trigger

  (keycode) ->
    super ...

    @keysym = keysymbols[keycode]

    @canvas = document.create-element \canvas
    @canvas.width = @canvas.height = 100
    @ctx = @canvas.get-context \2d
    @ctx.fill-rect 0, 0, 100, 100

    document.add-event-listener \keydown, ({ which }) ~>
      if keycode is which then @set on

    document.add-event-listener \keyup, ({ which }) ~>
      if keycode is which then @set off

  set-mode: (mode) ->
    log mode

