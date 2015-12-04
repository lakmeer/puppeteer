
{ id, log, hyp, random-from } = require \std

COLOR_DARK_GREEN = \green
COLOR_BRIGHT_GREEN = \#0e3

export class Link

  bend-strength = 150

  (@from, @to) ->

  draw: ({ ctx }) ->
    state = @from.pull!
    d = hyp @to.pos, @from.pos
    b = if d <= bend-strength then bend-strength * (d/bend-strength)**2 else bend-strength
    ctx.stroke-style = if state then COLOR_DARK_GREEN else COLOR_BRIGHT_GREEN
    ctx.line-width = 5
    ctx.begin-path!
    ctx.move-to @from.pos.x, @from.pos.y
    ctx.bezier-curve-to @from.pos.x + b, @from.pos.y, @to.pos.x - b, @to.pos.y, @to.pos.x, @to.pos.y
    ctx.stroke!
    ctx.close-path!

