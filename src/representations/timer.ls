
{ Representation } = require \./base

export class TimerRep extends Representation
  ->
    super ...

  draw: ->
    super ...
    @ctx.fill-style = \black
    @ctx.font = "#{@size/4}px monospace"
    @ctx.text-align = \center
    @ctx.text-baseline = \middle
    @ctx.begin-path!
    @ctx.move-to 0, @size/2
    @ctx.line-to @size, @size/2
    @ctx.close-path!
    @ctx.stroke!
    @ctx.fill-text @target.time, @size/2, @size/2 - @size/5, @size, @size
    @ctx.fill-text @target.duty, @size/2, @size/2 + @size/5, @size, @size

