
{ id, log, raf, mash, random-from, v2 } = require \std

{ } = require \config

{ DragMonitor } = require \./drag-monitor
{ Workspace }   = require \./workspace
{ Node }        = require \./node
{ Link }        = require \./link
{ InputSet }    = require \./input-set
{ Sprite }      = require \./sprite

{ Blitter } = require \./blitter

{ Puppet } = require \./puppet

{ KeyTrigger }   = require \./triggers/key
{ MicTrigger }   = require \./triggers/mic
{ MouseTrigger } = require \./triggers/mouse
{ TimerTrigger } = require \./triggers/timer

{ KeyRep }    = require \./representations/key
{ TimerRep }  = require \./representations/timer
{ PuppetRep } = require \./representations/puppet



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
p = new TimerTrigger time: 1.5, duty: 0.1

left  = new MouseTrigger MOUSE_LEFT
#audio = new MicTrigger

puppet = new Puppet

left.on-state-change  -> puppet.set \draw it
#audio.on-state-change -> puppet.set \sing it

# Assign logical nodes to representative nodes
nodes.push z-node = new Node content: z, rep: (new KeyRep z),   size: 70,  pos: v2 230 100
nodes.push x-node = new Node content: x, rep: (new KeyRep x),   size: 70,  pos: v2 230 180
nodes.push c-node = new Node content: c, rep: (new KeyRep c),   size: 70,  pos: v2 230 260
nodes.push v-node = new Node content: v, rep: (new KeyRep v),   size: 70,  pos: v2 230 340
nodes.push t-node = new Node content: t, rep: (new TimerRep t), size: 100, pos: v2  80 280
nodes.push p-node = new Node content: p, rep: (new TimerRep p), size: 100, pos: v2  80 400

nodes.push puppet-node = new Node content: puppet, rep: (new PuppetRep puppet), inputs: 6, size: 180, pos: v2 450 260

# Create links between them
links.push new Link z-node.outputs.next, puppet-node.inputs.next
links.push new Link x-node.outputs.next, puppet-node.inputs.next
links.push new Link c-node.outputs.next, puppet-node.inputs.next
links.push new Link t-node.outputs.next, puppet-node.inputs.next
links.push new Link v-node.outputs.next, puppet-node.inputs.next
links.push new Link p-node.outputs.next, puppet-node.inputs.next


# Rendering

draw = ->
  #raf draw
  workspace.clear!
  #puppet.draw workspace
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

