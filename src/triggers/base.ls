
{ id, log } = require \std

export class Trigger

  ->
    @state    = off
    @callback = id

  set: (state) ->
    @state = state
    @callback state

  on-state-change: (λ) ->
    @callback = λ

