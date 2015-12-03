
{ Blitter } = require \./blitter

export class Sprite extends Blitter

  ({ src }) ->
    super ...

    @img = new Image

    @img.onload = ~>
      @canvas.width = @img.width
      @canvas.height = @img.height
      @ctx.draw-image @img, 0, 0

    @img.src = src

    @active = no

