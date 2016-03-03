
{ id, log, v2 } = require \std

{ Representation } = require \./base

export class PuppetRep extends Representation

  offset = v2 10 10

  ->
    super ...

  draw: ({ ctx }) ->
    @size = @target.get-size!
    @canvas.width = @canvas.height = @size
    @draw-border!

    if sprite = @target.get-winner!
      sprite.blit-to @ctx, offset.x, offset.y + @size - 20 - sprite.height

