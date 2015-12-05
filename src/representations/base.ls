
{ id, log } = require \std

export class Representation

  (@target) ->
    @size = 100
    @state = mode: INTERACTION_MODE_IDLE
    @canvas = document.create-element \canvas
    @canvas.width = @canvas.height = @size
    @ctx = @canvas.get-context \2d
    @ctx.fill-style = \lightgrey
    @ctx.fill-rect 0, 0, @size, @size

  draw: ->
    @ctx.fill-style = @border-color!
    @ctx.fill-rect 0, 0, @canvas.width, @canvas.height
    @ctx.fill-style = \white
    @ctx.fill-rect 10, 10, @size - 20, @size - 20

  border-color: ->
    if @target.state
      COLOR_BRIGHT_GREEN
    else
      @mode-color @state.mode

  mode-color: (mode) ->
    switch mode
    | INTERACTION_MODE_IDLE   => \darkred
    | INTERACTION_MODE_HOT    => \orange
    | INTERACTION_MODE_ACTIVE => \red

  set-mode: (mode) ->
    @state.mode = mode


