
{ id, log } = require \std

{ Representation } = require \./base


export class MicRep extends Representation

  size = 70

  ->
    super ...

    @ctx.fill-style = \grey
    @ctx.fill-rect 0, 0, @size, @size

    @ctx.fill-style = \lightgrey
    @ctx.fill-rect 0 , 0, @size, @size

    @ctx.fill-style = \darkgrey
    @ctx.fill-rect 0, @size/2, @size, @size/2

  draw: (target) ->

    w = @size/5
    v = target.value/2
    t = target.threshold/2

    @ctx.fill-style = \white
    @ctx.fill-rect @size/2 - w/2, 0, w, @size
    @ctx.fill-style = if target.state then \red else \blue
    @ctx.fill-rect @size/2 - w/2, @size - 10 - @size * v, w, @size * v
    @ctx.global-alpha = 1

    @draw-border!

