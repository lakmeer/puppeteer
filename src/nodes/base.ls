
{ id, log } = require \std

{ InputSet, OutputSet } = require \../port-set

export class Node

  ->
    @state    = off
    @callback = id
    @inputs   = []
    @outputs  = []

  set: (state) ->
    @state = state
    @callback state

    # DONT automatically poke upon state change. REAL 'Triggers' are allowed
    # to do this, but while the naming is still screwed up, 'Trigger' is still
    # the generic type. It can be subclassed later if necessary. For now, sub-
    # classes of Trigger that are ACTUALLY triggers should do this manually.
    #
    # GlobalServices.Poke.poke!

  on-state-change: (λ) ->
    @callback = λ

  generate-ports: ({ input-spec = [], output-spec = [] }) ->
    @inputs  = new InputSet { spec: input-spec, owner: this }
    @outputs = new OutputSet { spec: output-spec, owner: this }

  serialise: ->
    console.warn this@@display-name, 'should implement serialise'

  @deserialise = (config) -> new this config

