
# Require

{ id, log, mash, v2 } = require \std

{ Link }        = require \./link
{ Sprite }      = require \./sprite
{ VisualNode }  = require \./visual-node

{ Puppet }      = require \./puppet
{ KeyNode }     = require \./nodes/key
{ MicNode }     = require \./nodes/mic
{ MouseNode }   = require \./nodes/mouse
{ TimerNode }   = require \./nodes/timer
{ GraphicNode } = require \./nodes/graphic

{ MicRep }      = require \./representations/mic
{ KeyRep }      = require \./representations/key
{ TimerRep }    = require \./representations/timer
{ PuppetRep }   = require \./representations/puppet
{ GraphicRep }  = require \./representations/graphic
{ MouseRep }    = require \./representations/mouse
{ LinkRep }     = require \./representations/link

{ NumericShim, NumericShimRep } = require \./shim


# Construct default test scene manually

export construct-test-scene = ->

  # Export

  output =
    nodes: []
    links: []
    puppet: null


  # Core nodes

  puppet = new Puppet

  z-key = new KeyNode keycode: KEY_Z
  x-key = new KeyNode keycode: KEY_X
  c-key = new KeyNode keycode: KEY_C
  v-key = new KeyNode keycode: KEY_V

  timer = new TimerNode time: 10, duty: 0.1, offset: 7
  left  = new MouseNode button-index: MOUSE_LEFT
  mic   = new MicNode threshold: 1.1

  output.nodes.push mic-node   = new VisualNode content: mic,   rep: (new MicRep mic),     size: 70, pos: v2 50, 800
  output.nodes.push left-node  = new VisualNode content: left,  rep: (new MouseRep left),  size: 70, pos: v2 50, 100
  output.nodes.push timer-node = new VisualNode content: timer, rep: (new TimerRep timer), size: 100, pos: v2  65 685

  # Assign logical nodes to representative nodes
  output.nodes.push z-node = new VisualNode content: z-key, rep: (new KeyRep z-key), size: 70,  pos: v2 50 195
  output.nodes.push x-node = new VisualNode content: x-key, rep: (new KeyRep x-key), size: 70,  pos: v2 50 275
  output.nodes.push c-node = new VisualNode content: c-key, rep: (new KeyRep c-key), size: 70,  pos: v2 50 355
  output.nodes.push v-node = new VisualNode content: v-key, rep: (new KeyRep v-key), size: 70,  pos: v2 50 435

  output.nodes.push puppet-node = new VisualNode do
    content: puppet
    rep:     (new PuppetRep puppet)
    size:    180
    pos:     v2 550 450

  # Create sprite sources (full set: look draw choke drop frustrate sing study think trash drink)
  anim-nodes = mash do
    for name, i in <[ look draw drop frustrate choke sing ]>
      sprite  = new Sprite src: "assets/#{name}_01.png"
      graphic = new GraphicNode { sprite }
      output.nodes.push node = new VisualNode content: graphic, rep: (new GraphicRep graphic), size: 130, pos: v2 260 80 + 140 * i
      [ name, node ]

  # Create links
  output.links.push VisualNode.link anim-nodes.look,  puppet-node
  output.links .= concat VisualNode.chain left-node,  anim-nodes.draw, puppet-node
  output.links .= concat VisualNode.chain z-node,     anim-nodes.drop, puppet-node
  output.links .= concat VisualNode.chain x-node,     anim-nodes.frustrate, puppet-node
  output.links .= concat VisualNode.chain timer-node, anim-nodes.choke, puppet-node
  output.links .= concat VisualNode.chain mic-node,   anim-nodes.sing, puppet-node

  # Testing incorrect links
  #output.links.push new LinkRep new Link from: z-node.content.outputs.next, to: puppet-node.content.inputs.next

  # Shim links
  output.nodes.push shim-node = new VisualNode do
    content: (shim = new NumericShim)
    rep: (new NumericShimRep shim)
    size: 50
    pos: v2 140, 840

  output.links.push new LinkRep new Link from: mic-node.content.outputs.next, to: shim-node.content.inputs.next

  output.puppet = puppet

  return output

