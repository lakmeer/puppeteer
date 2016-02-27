
{ id, log, v2 } = require \std

{ Representation } = require \./base


export class GraphicRep extends Representation

  ->
    @size = 130
    super ...
    log 'new GraphicRep', @target

  draw: (target) ->
    @ctx.fill-style = \black
    @ctx.fill-rect 0, 0, @size, @size
    @ctx.global-alpha = 0.3
    super ...
    @ctx.global-alpha = 1
    @ctx.draw-image target.sprite.canvas, 10, 10, @size - 20, (target.sprite.size.y / target.sprite.size.x) * (@size - 20)

