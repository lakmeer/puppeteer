
{ id, log, v2 } = require \std

{ Graphic }  = require \./graphic
{ RectXYS }  = require \./rect
{ InputSet, OutputSet } = require \./input-set


export class Node

  ({ @content, @pos, @size, inputs = 1, outputs = 1, @rep = new Graphic }) ->

    @state =
      mode: INTERACTION_MODE_IDLE
      signal: off

    @bounds  = new RectXYS   @pos, @size
    @inputs  = new InputSet  @content.inputs,  offset: @size/-2, pos: @pos, height: @size
    @outputs = new OutputSet @content.outputs, offset: @size/+2, pos: @pos, height: @size

  pull: ->
    @state.signal = @content.state

  draw: ({ ctx }) ->

    @rep.draw @content

    ctx.draw-image @rep.canvas, @pos.x - @size/2 , @pos.y - @size/2, @size, @size

    ctx.fill-style = \blue
    for input, i in @inputs.ports
      ctx.fill-rect input.pos.x, input.pos.y - 10, 20, 20

    ctx.fill-style = \magenta
    for output, j in @outputs.ports
      ctx.fill-rect output.pos.x - 20, output.pos.y - 10, 20, 20

  set-mode: (mode) ->
    @rep.set-mode mode
    @state.mode = mode

  move-to: ({ x, y }) ->
    @pos.x = x
    @pos.y = y
    @update-child-pos!

  move-by: ({ x, y }) ->
    @pos.x += x
    @pos.y += y
    @update-child-pos!

  update-child-pos: ->
    @bounds.move-to @pos
    @inputs.move-to @pos
    @outputs.move-to @pos

  bounds-contains: (point) ->
    @bounds.contains point

