
{ id, log, v2, raf } = require \std

require \global
require \config

{ Link }         = require \./link
{ LinkRep }      = require \./representations/link
{ Scene }        = require \./scene
{ Workspace }    = require \./workspace
{ VisualNode }   = require \./visual-node
{ DragMonitor }  = require \./drag-monitor
{ NodeProvider } = require \./node-provider

{ construct-test-scene } = require \./test-data


# Init global services

GlobalServices.init!


# Setup

hot-node = null
workspace = new Workspace

scene =
  if yes
    new Scene construct-test-scene!
  else
    new Scene


# Scene Walker

walk = (node) ->
  return do
    type: node@@display-name
    view: node.rep.serialise!
    self: node.serialise!
    incoming:
      for input, i in node.inputs.all
        if input.link
          node: walk input.link.from.owner
          output-index: input.link.from.index
        else
          null

#GlobalServices.SceneLibrary.save \test-scene, JSON.stringify (walk scene.puppet), null, 2


GlobalServices.SceneLibrary.load \test-scene, (data) ->

  return

  output =
    puppet: null
    links: []
    nodes: []

  console.info "Scene:", JSON.stringify data, null, 2

  traverse = (node-data, parent) ->
    [ NodeClass, RepClass ] = NodeProvider node-data.type
    node = NodeClass.deserialise node-data.state
    output.nodes.push visual-node = new VisualNode content: node, rep: (new RepClass node), pos: v2 0 0

    if node-data.type is \Puppet
      output.puppet := node

    for v, i in node-data.incoming when v?
      child = traverse v.node
      output.links.push new LinkRep new Link from: (child.outputs.get v.output-index), to: node.inputs.get i

    return node

  traverse data


# Render when graph updates

draw = ->
  workspace.clear!
  scene.draw-onto workspace

global.GlobalServices.Poke.on-poke ->
  scene.pull!
  draw!


# Init

workspace.install document.body
draw!




#
# Editor interactions
#


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

  for node in scene.nodes
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

