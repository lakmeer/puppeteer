
{ id, log } = require \std

{ Representation } = require \./base

keysymbols =
  90: \Z
  88: \X
  67: \C
  86: \V

export class KeyRep extends Representation

  ->
    super ...
    @symbol = keysymbols[@target.keycode]

  draw: ->
    super ...
    @ctx.fill-style = \black
    @ctx.font = "#{@size/2}px monospace"
    @ctx.text-align = \center
    @ctx.text-baseline = \middle
    @ctx.fill-text @symbol, @size/2, @size/2, @size, @size

