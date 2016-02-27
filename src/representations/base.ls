
{ id, log } = require \std

export class Representation

  bw = 10

  (@target) ->
    @size ?= 100
    @state = mode: INTERACTION_MODE_IDLE
    @canvas = document.create-element \canvas
    @canvas.width = @canvas.height = @size
    @ctx = @canvas.get-context \2d

  draw: ->
    @draw-backing!
    @draw-border!

  draw-backing: ->
    @ctx.fill-style = \white
    @ctx.fill-rect 0, 0, @canvas.width, @canvas.height

  draw-border: ->
    @ctx.fill-style = @border-color!
    @ctx.fill-rect 0, 0, @size, bw
    @ctx.fill-rect 0, bw, bw, @size - bw
    @ctx.fill-rect @size - bw, bw, bw, @size - bw
    @ctx.fill-rect bw, @size - bw, @size - bw * 2, bw

  border-color: ->
    if @target.state
      COLOR_YELLOW
    else
      @mode-color @state.mode

  mode-color: (mode) ->
    switch mode
    | INTERACTION_MODE_IDLE   => \darkred
    | INTERACTION_MODE_HOT    => \orange
    | INTERACTION_MODE_ACTIVE => \red

  set-mode: (mode) ->
    @state.mode = mode

  @NullRepresentation = new Representation { state: off }

