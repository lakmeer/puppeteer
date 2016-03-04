
{ id, log } = require \std


export class Scene

  (scene-data) ->

    @links = []
    @nodes = []

    @puppet = pull: id

    if scene-data
      @import scene-data

  pull: -> @puppet.pull!

  import: ({ @puppet, @links, @nodes }) ->

  draw-onto: (workspace) ->
    @links.map (.draw workspace)
    @nodes.map (.draw workspace)

