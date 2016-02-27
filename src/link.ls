
{ id, log, abs, hyp, random-from } = require \std

determine-status = (a, b) ->
  if a.type isnt b.type
    console.warn "Link::new - can't join ports of disparate types! - FROM:", a.type, "| TO:", b.type
    LINK_STATUS_MISMATCH
  else
    LINK_STATUS_OK


export class Link

  bend-strength = 50

  (@from, @to) ->
    @from.assign-link this
    @to.assign-link this
    @status = determine-status @from, @to
    @signal-strength = 0

  push-to:   -> if @status is LINK_STATUS_OK then @to.push!   else null
  pull-from: -> if @status is LINK_STATUS_OK then @from.pull! else null

  get-status-colors: ->
    switch @status
    | LINK_STATUS_OK =>
      switch @to.type
      | SIGNAL_TYPE_NUMBER  => [ COLOR_PURPLE, COLOR_MAGENTA ]
      | SIGNAL_TYPE_GRAPHIC => [ COLOR_DARK_BLUE, COLOR_BRIGHT_BLUE ]
      | otherwise           => [ COLOR_DARK_GREEN, COLOR_BRIGHT_GREEN ]
    | otherwise => [ COLOR_RED, COLOR_BRIGHT_RED ]

  infer-signal-strength: ->
    @signal-strength =
      switch @from.type
      | SIGNAL_TYPE_POKE    => (if @from.pull! then 1 else 0)
      | SIGNAL_TYPE_GRAPHIC => (if @from.pull! then 1 else 0)
      | SIGNAL_TYPE_NUMBER  => @from.pull!
      | otherwise => 1

  draw: ({ ctx }) ->
    d = hyp @to.pos, @from.pos
    d = @to.pos.x - @from.pos.x
    b = if d <= bend-strength then bend-strength * ((abs d)/bend-strength)**1.4 else bend-strength
    @infer-signal-strength!

    [ base-color, power-color ] = @get-status-colors!

    ctx.line-width = 5
    ctx.stroke-style = base-color

    ctx.begin-path!
    ctx.move-to @from.pos.x, @from.pos.y
    ctx.bezier-curve-to @from.pos.x + b, @from.pos.y, @to.pos.x - b, @to.pos.y, @to.pos.x, @to.pos.y
    ctx.stroke!

    ctx.global-alpha = @signal-strength
    ctx.stroke-style = power-color

    ctx.begin-path!
    ctx.move-to @from.pos.x, @from.pos.y
    ctx.bezier-curve-to @from.pos.x + b, @from.pos.y, @to.pos.x - b, @to.pos.y, @to.pos.x, @to.pos.y
    ctx.stroke!

    ctx.global-alpha = 1

