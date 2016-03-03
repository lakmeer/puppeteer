
{ id, log } = require \std

export class Blitter

  idx = do (i = 0) -> -> i++

  ({ @size }) ->

    @canvas = document.create-element \canvas
    @canvas.width = @canvas.height = @size
    @ctx = @canvas.get-context \2d
    @id = idx!

  clear: ->
    @ctx.clear-rect 0, 0, @size, @size

  blit-to: (ctx, x, y, w, h) ->
    if w? and h?
      ctx.draw-image @canvas, x, y, w, h
    else
      ctx.draw-image @canvas, x, y

