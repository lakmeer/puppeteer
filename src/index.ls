
{ id, log, raf, mash, v2 } = require \std

{ } = require \config

{ DragMonitor } = require \./drag-monitor
{ Workspace }   = require \./workspace
{ Graphic }     = require \./graphic
{ Link }        = require \./link
{ InputSet }    = require \./input-set
{ RectXYS }     = require \./rect
{ Sprite }      = require \./sprite

{ Blitter } = require \./blitter

{ KeyTrigger }   = require \./triggers/key
{ MicTrigger }   = require \./triggers/mic
{ MouseTrigger } = require \./triggers/mouse

{ Puppet } = require \./puppet


load-image = (src, λ = id) ->
  image = new Image
  image.src = src
  image.onload = λ
  return image


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
  new Node type: Graphic, size:  80, pos: v2 50, 50
  new Node type: Graphic, size: 100, pos: v2 200, 200
  new Node type: Graphic, size: 120, pos: v2 350, 350
  new Node type: Graphic, size:  40, pos: v2 500, 500
]

links = [
  new Link nodes.0.outputs.first, nodes.1.inputs.first
  new Link nodes.1.outputs.first, nodes.2.inputs.first
  new Link nodes.2.outputs.first, nodes.3.inputs.first
]

workspace = new Workspace

hot-node = null

draw = ->
  #raf draw
  workspace.clear!
  #avatar.draw workspace
  links.map (.draw workspace)
  nodes.map (.draw workspace)
  #audio.draw workspace

global.GlobalServices.Poke.poke = -> draw!


# Dragger

dragger = new DragMonitor
dragger.on-pointer-release draw
dragger.on-pointer-drag (Δx, Δy) ->
  hot-node?.move-by v2 Δx, Δy
  draw!


# Trigger/Puppet Tests

z = new KeyTrigger KEY_Z
x = new KeyTrigger KEY_X
c = new KeyTrigger KEY_C
v = new KeyTrigger KEY_V

left  = new MouseTrigger MOUSE_LEFT
right = new MouseTrigger MOUSE_RIGHT
#audio = new MicTrigger

avatar = new Puppet

z.on-state-change -> avatar.set \choke it
x.on-state-change -> avatar.set \drop it
c.on-state-change -> avatar.set \frustrate it
v.on-state-change -> avatar.set \trash it

left.on-state-change  -> avatar.set \draw it
right.on-state-change -> avatar.set \drink it

#audio.on-state-change -> avatar.set \sing it


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

