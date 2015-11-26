
{ Blitter } = require \./blitter

export class Graphic extends Blitter

  ->
    super size: 200
    @state = mode: INTERACTION_MODE_IDLE
    @fill-self!

  set-mode: (mode) ->
    @state.mode = mode
    @fill-self!

  mode-color: (mode) ->
    switch mode
    | INTERACTION_MODE_IDLE   => \red
    | INTERACTION_MODE_HOT    => \orange
    | INTERACTION_MODE_ACTIVE => \yellow

  fill-self: ->
    @ctx.fill-style = @mode-color @state.mode
    @ctx.fill-rect 0, 0, 200, 200
    @ctx.fill-style = \black
    @ctx.fill-rect 20, 20, 160, 160

