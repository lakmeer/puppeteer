
export class RectXYWH

  ({ @x, @y }, { @w, @h }) ->
    @update!

  update: ->
    @left   = @x - @w/2
    @right  = @x + @w/2
    @top    = @y - @h/2
    @bottom = @y + @h/2

  contains: ({ x, y }) ->
    @left < x < @right and @top < y < @bottom


export class RectXYS extends RectXYWH

  (pos, size) ->
    super pos, { w: size, h: size }

  move-to: ({ x, y }) ->
    @x = x
    @y = y
    @update!


