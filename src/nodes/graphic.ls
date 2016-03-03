
{ id, log } = require \std

{ Node } = require \./base


# Graphic
#
# Provides a SIGNAL_TYPE_GRAPHIC to later nodes.
# When input is not connected, defaults to on.

export class GraphicNode extends Node

  input-spec  = [ { type: SIGNAL_TYPE_POKE,    on-push: -> @set on } ]
  output-spec = [ { type: SIGNAL_TYPE_GRAPHIC, on-pull: -> @on-pull! } ]

  ({ @sprite }) ->
    super ...

    @generate-ports { input-spec, output-spec }
    @set on

  on-pull: ->
    if @inputs.get(0).link?
      @set @inputs.get(0).pull!
    if @state then @sprite else null

