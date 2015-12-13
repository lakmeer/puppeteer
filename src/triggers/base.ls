
{ id, log } = require \std

export class Trigger

  ->
    @state    = off
    @callback = id

  set: (state) ->
    @state = state
    @callback state
    GlobalServices.Poke.poke!

  on-state-change: (λ) ->
    @callback = λ

  specify-inputs:  -> []
  specify-outputs: -> []

