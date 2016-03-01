
{ id, log, raf, mash, random-from, v2 } = require \std

require \global
require \config

{ DragMonitor } = require \./drag-monitor
{ Workspace }   = require \./workspace
{ VisualNode }  = require \./visual-node
{ Link }        = require \./link
{ Sprite }      = require \./sprite

{ Puppet } = require \./puppet

{ KeyTrigger }     = require \./triggers/key
{ MicTrigger }     = require \./triggers/mic
{ MouseTrigger }   = require \./triggers/mouse
{ TimerTrigger }   = require \./triggers/timer
{ GraphicTrigger } = require \./triggers/graphic

{ MicRep }     = require \./representations/mic
{ KeyRep }     = require \./representations/key
{ TimerRep }   = require \./representations/timer
{ PuppetRep }  = require \./representations/puppet
{ GraphicRep } = require \./representations/graphic
{ MouseRep }   = require \./representations/mouse

{ NumericShim, ShimRep } = require \./shim


# Init global services

GlobalServices.init!


# Setup

nodes = []
links = []
hot-node = null
workspace = new Workspace


# Create Triggers/Nodes

puppet = null

construct-test-scene = ->
  z = new KeyTrigger KEY_Z
  x = new KeyTrigger KEY_X
  c = new KeyTrigger KEY_C
  v = new KeyTrigger KEY_V
  #t = new TimerTrigger time: 1
  p = new TimerTrigger time: 10, duty: 0.1, offset: 7

  left = new MouseTrigger MOUSE_LEFT
  mic  = new MicTrigger

  puppet := new Puppet

  nodes.push mic-node  = new VisualNode content: mic,  rep: (new MicRep mic),    size: 70, pos: v2 50, 800
  nodes.push left-node = new VisualNode content: left, rep: (new MouseRep left), size: 70, pos: v2 50, 100

  # Assign logical nodes to representative nodes
  nodes.push z-node = new VisualNode content: z, rep: (new KeyRep z),   size: 70,  pos: v2 50 195
  nodes.push x-node = new VisualNode content: x, rep: (new KeyRep x),   size: 70,  pos: v2 50 275
  nodes.push c-node = new VisualNode content: c, rep: (new KeyRep c),   size: 70,  pos: v2 50 355
  nodes.push v-node = new VisualNode content: v, rep: (new KeyRep v),   size: 70,  pos: v2 50 435
  nodes.push p-node = new VisualNode content: p, rep: (new TimerRep p), size: 100, pos: v2  65 685
  #nodes.push t-node = new VisualNode content: t, rep: (new TimerRep t), size: 100, pos: v2  65 545

  nodes.push puppet-node = new VisualNode do
    content: puppet
    rep:     (new PuppetRep puppet)
    size:    180
    pos:     v2 600 450

  # Create sprite sources (full set: look draw choke drop frustrate sing study think trash drink)
  anim-nodes = mash do
    for name, i in <[ look draw drop frustrate choke sing ]>
      sprite  = new Sprite src: "assets/#{name}_01.png"
      graphic = new GraphicTrigger { sprite }
      nodes.push node = new VisualNode content: graphic, rep: (new GraphicRep graphic), size: 130, pos: v2 280 80 + 140 * i
      [ name, node ]

  # Create links
  links.push VisualNode.link anim-nodes.look, puppet-node
  links .= concat VisualNode.chain left-node, anim-nodes.draw, puppet-node
  links .= concat VisualNode.chain z-node,    anim-nodes.drop, puppet-node
  links .= concat VisualNode.chain x-node,    anim-nodes.frustrate, puppet-node
  links .= concat VisualNode.chain p-node,    anim-nodes.choke, puppet-node
  links .= concat VisualNode.chain mic-node,  anim-nodes.sing, puppet-node

  # Testing incorrect links
  #links.push new Link z-node.outputs.next, puppet-node.inputs.next

  # Shim links
  #nodes.push shim-node = new VisualNode do
    #content: (shim = new NumericShim)
    #rep: (new ShimRep shim)
    #size: 50
    #pos: v2 50, 900

  #links.push new Link mic-node.outputs.next, shim-node.inputs.next


deserialise-scene = (scene-data) ->


# Scene Walker

walk = (node) ->
  return do
    type: node@@display-name
    state: node.serialise-self!
    incoming:
      for input, i in node.inputs
        if input.link
          walk input.link.from.owner
        else
          null

#construct-test-scene!
#scene = JSON.stringify (walk puppet), null, 2
#GlobalServices.SceneLibrary.save \test-scene, scene

GlobalServices.SceneLibrary.load \test-scene, (data) ->
  log 'Load:', data
  console.warn 'TODO: Deserialise into node graph'


# Render when graph updates

draw = ->
  workspace.clear!
  links.map (.draw workspace)
  nodes.map (.draw workspace)

global.GlobalServices.Poke.on-poke ->
  puppet.pull!
  draw!


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

