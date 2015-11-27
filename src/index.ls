
{ id, log, raf, v2 } = require \std

{ } = require \config

{ DragMonitor } = require \./drag-monitor
{ Workspace }   = require \./workspace
{ Graphic }     = require \./graphic
{ Link }        = require \./link
{ InputSet }    = require \./input-set
{ RectXYS }     = require \./rect


class Node

  ({ type, @pos, @size }) ->

    @state =
      mode: INTERACTION_MODE_IDLE

    @content = new type
    @bounds  = new RectXYS @pos, @size
    @inputs  = new InputSet @size/-2, @pos
    @outputs = new InputSet @size/+2, @pos

  draw: ({ ctx }) ->
    ctx.draw-image @content.canvas, @pos.x - @size/2 , @pos.y - @size/2, @size, @size

  set-mode: (mode) ->
    @content.set-mode mode
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


# Setup

nodes = [
  new Node type: Graphic, size: 120, pos: v2 100, 100
  new Node type: Graphic, size: 160, pos: v2 350, 350
  new Node type: Graphic, size: 160, pos: v2 600, 600
  new Node type: Graphic, size:  80, pos: v2 850, 850
]

links = [
  new Link nodes.0.outputs.first, nodes.1.inputs.first
  new Link nodes.1.outputs.first, nodes.2.inputs.first
  new Link nodes.2.outputs.first, nodes.3.inputs.first
]

workspace = new Workspace

hot-node = null

draw = ->
  workspace.clear!
  links.map (.draw workspace)
  nodes.map (.draw workspace)


# Dragger

dragger = new DragMonitor
dragger.on-pointer-release draw
dragger.on-pointer-drag (Δx, Δy) ->
  hot-node?.move-by v2 Δx, Δy
  draw!


# Fake triggers

class KeyTrigger

  (keycode) ->
    @state    = off
    @callback = id

    document.add-event-listener \keydown, ({ which }) ~>
      if keycode is which
        @state = on
        @callback on

    document.add-event-listener \keyup, ({ which }) ~>
      if keycode is which
        @state = off
        @callback off

  on-state-change: (λ) ->
    @callback = λ


# Puppet

class Puppet
  ->
    @frames =
      idle  : null
      draw  : null
      study : null
      frust : null
      trash : null
      drop  : null
      think : null
      drink : null
      choke : null
      cat   : null
      sing  : null

puppet = new Puppet


z = new KeyTrigger KEY_Z
x = new KeyTrigger KEY_X
c = new KeyTrigger KEY_C
v = new KeyTrigger KEY_V

z.on-state-change -> log "Z!", it
x.on-state-change -> log "X!", it
c.on-state-change -> log "C!", it
v.on-state-change -> log "V!", it






# Listeners

document.add-event-listener \mousemove, ({ pageX, pageY }) ->

  if hot-node?.state.mode is INTERACTION_MODE_ACTIVE
    return

  hot-found = no

  for node in nodes

    if node.bounds-contains v2 pageX, pageY
      node.set-mode INTERACTION_MODE_HOT
      hot-found := yes
      hot-node := node

    else
      node.set-mode INTERACTION_MODE_IDLE

  if not hot-found
    hot-node := null

  draw!


document.add-event-listener \mousedown, ->
  hot-node?.set-mode INTERACTION_MODE_ACTIVE
  draw!

document.add-event-listener \mouseup, ->
  hot-node?.set-mode INTERACTION_MODE_HOT
  draw!


# Init

workspace.install document.body
draw!

