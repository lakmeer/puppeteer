
{ id, log, v2 } = require \std

{ Blitter } = require \./blitter

export class Sprite extends Blitter

  ({ src }) ->
    super ...

    @img = new Image

    @size = v2 0 0

    @img.onload = ~>
      @width  = @canvas.width  = @img.width
      @height = @canvas.height = @img.height
      @size = v2 @width, @height
      @ctx.draw-image @img, 0, 0
      GlobalServices.Poke.poke!

    @img.src = src

    @active = no

