
{ id, log, hyp, random-from } = require \std


export class Link

  bend-strength = 150
  colors = <[ red #0e3 blue black ]>

  (@from, @to) ->
    @color = random-from colors

  draw: ({ ctx }) ->
    d = hyp @to.pos, @from.pos
    b = if d <= bend-strength then bend-strength * (d/bend-strength)**2 else bend-strength
    ctx.stroke-style = @color
    ctx.line-width = 5
    ctx.begin-path!
    ctx.move-to @from.pos.x, @from.pos.y
    ctx.bezier-curve-to @from.pos.x + b, @from.pos.y, @to.pos.x - b, @to.pos.y, @to.pos.x, @to.pos.y
    ctx.stroke!
    ctx.close-path!

