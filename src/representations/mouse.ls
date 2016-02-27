
{ id, log } = require \std

{ Representation } = require \./base

keysymbols =
  0: \◀
  1: \■
  2: \▶


export class MouseRep extends Representation

  ->
    super ...
    @symbol = keysymbols[@target.button-index]

  draw: ->
    super ...
    @ctx.fill-style = \black
    @ctx.font = "#{@size/2}px monospace"
    @ctx.text-align = \center
    @ctx.text-baseline = \middle
    @ctx.fill-text @symbol, @size/2, @size/2, @size, @size

