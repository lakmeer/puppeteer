
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
    GlobalServices.Poke.poke!

  on-state-change: (λ) ->
    @callback = λ

  generate-ports: ({ input-spec = [], output-spec = [] }) ->
    @inputs =
      for { type, on-pull } in input-spec
        new Input { type, on-pull: on-pull.bind this }

    @outputs =
      for { type, on-pull } in output-spec
        new Output { type, on-pull: on-pull.bind this }

  specify-inputs:  -> []
  specify-outputs: -> []

