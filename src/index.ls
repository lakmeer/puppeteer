
{ id, log, raf, mash, random-from, v2 } = require \std

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

class Representation

  (@target) ->
    @size = 100
    @state = mode: INTERACTION_MODE_IDLE
    @canvas = document.create-element \canvas
    @canvas.width = @canvas.height = @size
    @ctx = @canvas.get-context \2d
    @ctx.fill-style = \lightgrey
    @ctx.fill-rect 0, 0, @size, @size

  draw: ->
    @ctx.fill-style = @border-color!
    @ctx.fill-rect 0, 0, @canvas.width, @canvas.height
    @ctx.fill-style = \white
    @ctx.fill-rect 10, 10, @size - 20, @size - 20

  border-color: ->
    if @target.state
      COLOR_BRIGHT_GREEN
    else
      @mode-color @state.mode

  mode-color: (mode) ->
    switch mode
    | INTERACTION_MODE_IDLE   => \darkred
    | INTERACTION_MODE_HOT    => \orange
    | INTERACTION_MODE_ACTIVE => \red

  set-mode: (mode) ->
    @state.mode = mode


class KeyRep extends Representation

  ->
    super ...

class PuppetRep extends Representation

  ->
    super ...

  draw: ->
    @size = @target.get-size!
    @canvas.width = @canvas.height = @size
    super ...
    @target.draw ctx: @ctx, size: @size - 20, offset: v2 10 10


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
nodes.push z-node = new Node content: z, rep: (new KeyRep z), size: 100, pos: v2 200 100
nodes.push x-node = new Node content: x, rep: (new KeyRep z), size: 100, pos: v2 200 205
nodes.push c-node = new Node content: c, rep: (new KeyRep z), size: 100, pos: v2 200 310
nodes.push v-node = new Node content: v, rep: (new KeyRep z), size: 100, pos: v2 200 415
nodes.push t-node = new Node content: t, rep: (new KeyRep z), size: 100, pos: v2  75 260

nodes.push puppet-node = new Node content: puppet, rep: (new PuppetRep puppet), inputs: 5, size: 180, pos: v2 450 260

# Create links between them
links.push new Link z-node.outputs.next, puppet-node.inputs.next
links.push new Link x-node.outputs.next, puppet-node.inputs.next
links.push new Link c-node.outputs.next, puppet-node.inputs.next
links.push new Link v-node.outputs.next, puppet-node.inputs.next
links.push new Link t-node.outputs.next, puppet-node.inputs.next


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

