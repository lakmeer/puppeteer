
{ id, log, abs, hyp, random-from } = require \std

determine-status = (a, b) ->
  if a.type isnt b.type
    console.error "Link::new - can't join ports of disparate types! - FROM:", a.type, "| TO:", b.type
    LINK_STATUS_MISMATCH
  else
    LINK_STATUS_OK


export class Link

  bend-strength = 50

  (@from, @to) ->
    @from.assign-link this
    @to.assign-link this
    @status = determine-status @from, @to

  get-color: ->
    if @status isnt LINK_STATUS_OK
      COLOR_RED
    else if @state
      COLOR_BRIGHT_GREEN
    else
      COLOR_DARK_GREEN

  draw: ({ ctx }) ->
    state = @from.pull!
    d = hyp @to.pos, @from.pos
    d = @to.pos.x - @from.pos.x
    b = if d <= bend-strength then bend-strength * ((abs d)/bend-strength)**1.4 else bend-strength
    ctx.stroke-style = @get-color!
    ctx.line-width = 5
    ctx.begin-path!
    ctx.move-to @from.pos.x, @from.pos.y
    ctx.bezier-curve-to @from.pos.x + b, @from.pos.y, @to.pos.x - b, @to.pos.y, @to.pos.x, @to.pos.y
    ctx.stroke!
    ctx.close-path!

