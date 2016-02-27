
{ id, log } = require \std

{ Trigger } = require \./base


export class GraphicTrigger extends Trigger

  input-spec  = [ { type: SIGNAL_TYPE_POKE,    on-push: -> @set on } ]
  output-spec = [ { type: SIGNAL_TYPE_GRAPHIC, on-pull: -> @on-pull! } ]

  ({ @sprite }) ->
    super ...

    @generate-ports { input-spec, output-spec }

  on-pull: ->
    @set @inputs.0.pull!
    if @state then @sprite else null

