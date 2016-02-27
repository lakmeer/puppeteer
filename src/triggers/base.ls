
{ id, log } = require \std

{ Input, Output } = require \../port

export class Trigger

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
    @inputs =
      for { type, on-push } in input-spec
        new Input { type, on-push: on-push.bind this }

    @outputs =
      for { type, on-pull } in output-spec
        new Output { type, on-pull: on-pull.bind this }

  specify-inputs:  -> []
  specify-outputs: -> []

