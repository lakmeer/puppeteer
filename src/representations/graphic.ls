
{ id, log, v2 } = require \std

{ Representation } = require \./base


export class GraphicRep extends Representation

  ->
    @size = 130
    super ...
    log 'new GraphicRep', @target

  draw: (target) ->
    super ...
    @ctx.global-alpha = if target.state then 1 else 0.3
    @ctx.draw-image target.sprite.canvas, 10, 10, @size - 20, (target.sprite.size.y / target.sprite.size.x) * (@size - 20)
    @ctx.global-alpha = 1

