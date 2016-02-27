
{ id, log } = require \std

{ Trigger } = require \./base


# Graphic
#
# Provides a SIGNAL_TYPE_GRAPHIC to later nodes.
# When input is not connected, defaults to on.

export class GraphicTrigger extends Trigger

  input-spec  = [ { type: SIGNAL_TYPE_POKE,    on-push: -> @set on } ]
  output-spec = [ { type: SIGNAL_TYPE_GRAPHIC, on-pull: -> @on-pull! } ]

  ({ @sprite }) ->
    super ...

    @generate-ports { input-spec, output-spec }
    @set on

  on-pull: ->
    if @inputs.0.link?
      @set @inputs.0.pull!
    if @state then @sprite else null

