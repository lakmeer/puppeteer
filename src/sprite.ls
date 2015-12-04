
{ Blitter } = require \./blitter

export class Sprite extends Blitter

  ({ src }) ->
    super ...

    @img = new Image

    @img.onload = ~>
      @width  = @canvas.width  = @img.width
      @height = @canvas.height = @img.height
      @ctx.draw-image @img, 0, 0
      GlobalServices.Poke.poke!

    @img.src = src

    @active = no

