
{ id, log, v2 } = require \std

{ Graphic }  = require \./graphic
{ RectXYS }  = require \./rect
{ InputSet } = require \./input-set

export class Node

  ({ @content, @pos, @size, @rep = new Graphic }) ->

    @state =
      mode: INTERACTION_MODE_IDLE
      signal: off

    @bounds  = new RectXYS @pos, @size
    @inputs  = new InputSet this, @size/-2, @pos
    @outputs = new InputSet this, @size/+2, @pos

  draw: ({ ctx }) ->
    @state.signal = @content.state
    @rep.set-mode if @content.state then INTERACTION_MODE_ACTIVE else INTERACTION_MODE_IDLE
    ctx.draw-image @rep.canvas, @pos.x - @size/2 , @pos.y - @size/2, @size, @size

  set-mode: (mode) ->
    @rep.set-mode mode
    @state.mode = mode

  move-to: ({ x, y }) ->
    @pos.x = x
    @pos.y = y
    @bounds.mvoe-to @pos
    @inputs.move-to @pos
    @outputs.move-to @pos

  move-by: ({ x, y }) ->
    @pos.x += x
    @pos.y += y
    @bounds.move-to @pos
    @inputs.move-to @pos
    @outputs.move-to @pos

  bounds-contains: (point) ->
    @bounds.contains point


