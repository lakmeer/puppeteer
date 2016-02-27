
{ id, log, v2 } = require \std

{ Representation } = require \./base

export class PuppetRep extends Representation

  ->
    super ...

  draw: ->
    @size = @target.get-size!
    @canvas.width = @canvas.height = @size
    @draw-border!
    @target.draw ctx: @ctx, size: @size - 20, offset: v2 10 10

