
{ id, log, hyp, random-from } = require \std

export class Link

  bend-strength = 50

  (@from, @to) ->
    @from.assign-link this
    @to.assign-link this

    if @from.type isnt @to.type
      console.error "Link::new - can't join ports of disparate types! - FROM:", @from.type, "| TO:", @to.type

  draw: ({ ctx }) ->
    state = @from.pull!
    d = hyp @to.pos, @from.pos
    d = @to.pos.x - @from.pos.x
    b = if d <= bend-strength then bend-strength * (d/bend-strength)**1.4 else bend-strength
    ctx.stroke-style = if state then COLOR_BRIGHT_GREEN else COLOR_DARK_GREEN
    ctx.line-width = 5
    ctx.begin-path!
    ctx.move-to @from.pos.x, @from.pos.y
    ctx.bezier-curve-to @from.pos.x + b, @from.pos.y, @to.pos.x - b, @to.pos.y, @to.pos.x, @to.pos.y
    ctx.stroke!
    ctx.close-path!

