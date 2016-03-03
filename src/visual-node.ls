
{ id, log, v2 } = require \std

{ Representation } = require \./representations/base
{ RectXYS }        = require \./rect
{ Link }           = require \./link
{ InputSet, OutputSet } = require \./port-set
{ PortSetRep } = require \./representations/port-set


export class VisualNode

  ({ @content, @pos, @size, @rep = Representation.NullRepresentation }) ->

    @state =
      mode: INTERACTION_MODE_IDLE
      signal: off

    @bounds  = new RectXYS   @pos, @size
    @inputs  = new PortSetRep @content.inputs,  { pos: @pos, offset: @rep.size/-2 }
    @outputs = new PortSetRep @content.outputs, { pos: @pos, offset: @rep.size/2 }

    # TODO: Don't do this
    @content.rep = this

  pull: ->
    @state.signal = @content.state

  draw: ({ ctx }) ->

    @rep.draw @content

    ctx.draw-image @rep.canvas, @pos.x - @size/2 , @pos.y - @size/2, @size, @size

    @inputs.draw { ctx }
    @outputs.draw { ctx }

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
    log "Moved to:", @pos.x, @pos.y
    @bounds.move-to @pos
    @inputs.move-to @pos
    @outputs.move-to @pos

  bounds-contains: (point) ->
    @bounds.contains point

  @link = (a, b) ->
    new Link a.content.outputs.next, b.content.inputs.next

  @chain = (...nodes) ->
    for i from 0 to nodes.length - 2
      a = nodes[i]
      b = nodes[i+1]
      new Link a.content.outputs.next, b.content.inputs.next

