
{ id, log, v2 } = require \std

{ Representation } = require \./representations/base
{ RectXYS }        = require \./rect
{ Link }           = require \./link
{ PortSetRep }     = require \./representations/port-set
{ LinkRep }        = require \./representations/link


export class VisualNode

  ({ @content, @pos, @size, @rep = Representation.NullRepresentation }) ->

    @state =
      mode: INTERACTION_MODE_IDLE
      signal: off

    @bounds  = new RectXYS   @pos, @size
    @inputs  = new PortSetRep @content.inputs,  { basis: (v2 @pos), height: @size, offset: @size/-2 - 3 }
    @outputs = new PortSetRep @content.outputs, { basis: (v2 @pos), height: @size, offset: @size/2 - 6 }

    # TODO: I shouldn't backreference like this. OR SHOULD I??
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
    log "Moved to:", @pos.x, @pos.y  # TODO: Render this to canvas instead
    @bounds.move-to @pos
    @inputs.move-to @pos
    @outputs.move-to @pos

  bounds-contains: (point) ->
    @bounds.contains point

  serialise: ->
    @rep.serialise!

  @link = (a, b) ->
    new LinkRep (new Link from: a.content.outputs.next, to: b.content.inputs.next)

  @chain = (...nodes) ->
    for i from 0 to nodes.length - 2
      @link nodes[i], nodes[i+1]

