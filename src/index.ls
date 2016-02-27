
{ id, log, raf, mash, random-from, v2 } = require \std

{ } = require \config

{ DragMonitor } = require \./drag-monitor
{ Workspace }   = require \./workspace
{ Node }        = require \./node
{ Link }        = require \./link
{ Sprite }      = require \./sprite

{ Puppet } = require \./puppet

{ KeyTrigger }     = require \./triggers/key
{ MicTrigger }     = require \./triggers/mic
{ MouseTrigger }   = require \./triggers/mouse
{ TimerTrigger }   = require \./triggers/timer
{ GraphicTrigger } = require \./triggers/graphic

{ KeyRep }     = require \./representations/key
{ TimerRep }   = require \./representations/timer
{ PuppetRep }  = require \./representations/puppet
{ GraphicRep } = require \./representations/graphic


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

#left  = new MouseTrigger MOUSE_LEFT
#audio = new MicTrigger

#left.on-state-change  -> puppet.set \draw it
#audio.on-state-change -> puppet.set \sing it

# Assign logical nodes to representative nodes
nodes.push z-node = new Node content: z, rep: (new KeyRep z),   size: 70,  pos: v2 50 100
nodes.push x-node = new Node content: x, rep: (new KeyRep x),   size: 70,  pos: v2 50 180
nodes.push c-node = new Node content: c, rep: (new KeyRep c),   size: 70,  pos: v2 50 260
nodes.push v-node = new Node content: v, rep: (new KeyRep v),   size: 70,  pos: v2 50 340
nodes.push t-node = new Node content: t, rep: (new TimerRep t), size: 100, pos: v2  65 475
nodes.push p-node = new Node content: p, rep: (new TimerRep p), size: 100, pos: v2  65 615

# Create sprite sources (full set: look draw choke drop frustrate sing study think trash drink)
anim-nodes = mash do
  for name, i in <[ look draw choke drop frustrate sing ]>
    sprite  = new Sprite src: "assets/#{name}_01.png"
    graphic = new GraphicTrigger { sprite }
    nodes.push node = new Node content: graphic, rep: (new GraphicRep graphic), size: 130, pos: v2 250 70 + 140 * i
    [ name, node ]

# Create Puppet
puppet = new Puppet
nodes.push puppet-node = new Node content: puppet, rep: (new PuppetRep puppet), size: 180, pos: v2 515 860

# Create links between them
#links.push new Link z-node.outputs.next, anim-nodes.look.inputs.next
links.push new Link x-node.outputs.next, anim-nodes.draw.inputs.next
links.push new Link c-node.outputs.next, anim-nodes.choke.inputs.next
links.push new Link t-node.outputs.next, anim-nodes.drop.inputs.next
links.push new Link p-node.outputs.next, anim-nodes.frustrate.inputs.next
links.push new Link v-node.outputs.next, anim-nodes.sing.inputs.next

links.push new Link anim-nodes.look.outputs.next,      puppet-node.inputs.next
links.push new Link anim-nodes.draw.outputs.next,      puppet-node.inputs.next
links.push new Link anim-nodes.choke.outputs.next,     puppet-node.inputs.next
links.push new Link anim-nodes.drop.outputs.next,      puppet-node.inputs.next
links.push new Link anim-nodes.frustrate.outputs.next, puppet-node.inputs.next
links.push new Link anim-nodes.sing.outputs.next,      puppet-node.inputs.next


# Testing incorrect links

links.push new Link z-node.outputs.next, puppet-node.inputs.next


# Rendering

draw = ->
  puppet.pull!
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

