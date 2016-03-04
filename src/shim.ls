
{ id, log } = require \std

{ Node } = require \./nodes/base
{ Representation } = require \./representations/base


export class PokeShim extends Node

  input-spec = [ { type: SIGNAL_TYPE_POKE, on-push: id } ]

  ->
    super ...
    @generate-ports { input-spec }

  serialise: -> {}


export class NumericShim extends Node

  input-spec = [ { type: SIGNAL_TYPE_NUMBER, on-push: id } ]

  ->
    super ...
    @generate-ports { input-spec }

  serialise: -> {}


export class GraphicShim extends Node

  input-spec = [ { type: SIGNAL_TYPE_GRAPHIC, on-push: id } ]

  ->
    super ...
    @generate-ports { input-spec }

  serialise: -> {}


export class ShimRep extends Representation

export class AbstractShimRep extends Representation

  draw: ->
    @draw-backing COLOR_PURPLE
    @ctx.global-alpha = @target.inputs.get(0).pull!
    @ctx.fill-rect 0, 0, @size, @size
    @ctx.global-alpha = 1
    @ctx
    @draw-border COLOR_PURPLE

export class NumericShimRep extends Representation

  draw: ->
    super ...

    value = @target.inputs.get(0).pull!
      |> (100 *)
      |> Math.round
      |> (0.01 *)
      |> -> String it
      |> (.replace /^0/, '')
      |> (.substr 0, 3)

    @ctx.fill-style = \black
    @ctx.font = "#{@size/3}px monospace"
    @ctx.text-align = \center
    @ctx.text-baseline = \middle
    @ctx.fill-text value, @size/2, @size/2 , @size, @size

