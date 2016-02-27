
{ id, log, v2 } = require \std

{ Representation } = require \./representations/base
{ RectXYS } = require \./rect
{ InputSet, OutputSet } = require \./port-set
{ Link }        = require \./link

port-color = ({ type }) ->
  switch type
  | SIGNAL_TYPE_NUMBER => COLOR_PURPLE
  | SIGNAL_TYPE_GRAPHIC => COLOR_BRIGHT_BLUE
  | otherwise =>  COLOR_BRIGHT_GREEN

export class VisualNode

  ({ @content, @pos, @size, @rep = Representation.NullRepresentation }) ->

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

    for input, i in @inputs.ports
      ctx.fill-style = port-color input
      ctx.fill-rect input.pos.x - 3, input.pos.y - 10, 13, 20

    for output, j in @outputs.ports
      ctx.fill-style = port-color output
      ctx.fill-rect output.pos.x - 10, output.pos.y - 10, 13, 20

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
    log @pos.x, @pos.y
    @bounds.move-to @pos
    @inputs.move-to @pos
    @outputs.move-to @pos

  bounds-contains: (point) ->
    @bounds.contains point

  @link = (a, b) ->
    new Link a.outputs.next, b.inputs.next

  @chain = (...nodes) ->
    for i from 0 to nodes.length - 2
      a = nodes[i]
      b = nodes[i+1]
      new Link a.outputs.next, b.inputs.next


