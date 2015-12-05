
{ Representation } = require \./base

export class KeyRep extends Representation

  ->
    super ...

  draw: ->
    super ...
    @ctx.fill-style = \black
    @ctx.font = "#{@size/2}px monospace"
    @ctx.text-align = \center
    @ctx.text-baseline = \middle
    @ctx.fill-text @target.keysym, @size/2, @size/2, @size, @size

