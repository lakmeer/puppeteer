
{ id, log, raf, mash, v2 } = require \std

{ } = require \config

{ DragMonitor } = require \./drag-monitor
{ Workspace }   = require \./workspace
{ Node }        = require \./node
{ Link }        = require \./link
{ InputSet }    = require \./input-set
{ Sprite }      = require \./sprite

{ Blitter } = require \./blitter

{ KeyTrigger }   = require \./triggers/key
{ MicTrigger }   = require \./triggers/mic
{ MouseTrigger } = require \./triggers/mouse
{ TimerTrigger } = require \./triggers/timer

{ Puppet } = require \./puppet


# Setup

nodes = []
links = []
hot-node = null
workspace = new Workspace


# Create Triggers/Nodes

z = new KeyTrigger KEY_Z
x = new KeyTrigger KEY_X
c = new KeyTrigger KEY_C
v = new KeyTrigger KEY_V
t = new TimerTrigger time: 1

left  = new MouseTrigger MOUSE_LEFT
right = new MouseTrigger MOUSE_RIGHT
#audio = new MicTrigger

puppet = new Puppet

z.on-state-change -> puppet.set \choke it
x.on-state-change -> puppet.set \drop it
c.on-state-change -> puppet.set \frustrate it
v.on-state-change -> puppet.set \trash it
t.on-state-change -> puppet.set \study it

left.on-state-change  -> puppet.set \draw it
right.on-state-change -> puppet.set \drink it
#audio.on-state-change -> puppet.set \sing it

# Assign logical nodes to representative nodes
nodes.push z-node = new Node content: z, size: 100, pos: v2 200 100
nodes.push x-node = new Node content: x, size: 100, pos: v2 200 200
nodes.push c-node = new Node content: c, size: 100, pos: v2 200 300
nodes.push v-node = new Node content: v, size: 100, pos: v2 200 400
nodes.push t-node = new Node content: t, size: 100, pos: v2  75 250

nodes.push puppet-node = new Node content: puppet, size: 200, pos: v2 450 250

# Create links between them
links.push new Link z-node.outputs.first, puppet-node.inputs.first
links.push new Link x-node.outputs.first, puppet-node.inputs.first
links.push new Link c-node.outputs.first, puppet-node.inputs.first
links.push new Link v-node.outputs.first, puppet-node.inputs.first
links.push new Link t-node.outputs.first, puppet-node.inputs.first


# Rendering

draw = ->
  #raf draw
  workspace.clear!
  puppet.draw workspace
  links.map (.draw workspace)
  nodes.map (.draw workspace)
  #audio.draw workspace

global.GlobalServices.Poke.poke = ->
  set-timeout draw, 0


# Dragger

dragger = new DragMonitor
dragger.on-pointer-release draw
dragger.on-pointer-drag (Δx, Δy) ->
  hot-node?.move-by v2 Δx, Δy
  draw!


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

