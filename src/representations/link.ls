
{ id, log, hyp, abs, v2 } = require \std

i = 0

export class LinkRep

  bend-strength = 50

  (@target) ->
    @i = i++

  get-status-colors: ->
    switch @target.status
    | LINK_STATUS_OK =>
      switch @target.to.type
      | SIGNAL_TYPE_NUMBER  => [ COLOR_PURPLE, COLOR_MAGENTA ]
      | SIGNAL_TYPE_GRAPHIC => [ COLOR_DARK_BLUE, COLOR_BRIGHT_BLUE ]
      | otherwise           => [ COLOR_DARK_GREEN, COLOR_BRIGHT_GREEN ]
    | otherwise => [ COLOR_RED, COLOR_BRIGHT_RED ]


  draw: ({ ctx }) ->

    fp = @target.from.owner.rep.outputs.get-pos @target.from.index
    tp = @target.to.owner.rep.inputs.get-pos @target.to.index
    ss = @target.infer-signal-strength!

    d = hyp tp, fp
    d = tp.x - fp.x
    b = if d <= bend-strength then bend-strength * ((abs d)/bend-strength)**1.4 else bend-strength

    [ base-color, power-color ] = @get-status-colors!

    ctx.line-width = 5
    ctx.stroke-style = base-color

    ctx.begin-path!
    ctx.move-to fp.x, fp.y
    ctx.bezier-curve-to fp.x + b, fp.y, tp.x - b, tp.y, tp.x, tp.y
    ctx.stroke!

    ctx.global-alpha = ss
    ctx.stroke-style = power-color

    ctx.begin-path!
    ctx.move-to fp.x, fp.y
    ctx.bezier-curve-to fp.x + b, fp.y, tp.x - b, tp.y, tp.x, tp.y
    ctx.stroke!

    ctx.global-alpha = 1

