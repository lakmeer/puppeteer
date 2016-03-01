
{ id, log, invoke, raf } = require \std

export class PokeService

  ->
    @callbacks = []
    @poke-scheduled = false

  on-poke: (λ) ->
    @callbacks.push λ

  dispatch: ->
    @callbacks.map invoke
    @poke-scheduled = false

  poke: ->
    @schedule-poke!

  schedule-poke: ->
    if not @poke-scheduled
      @poke-scheduled = true
      raf this~dispatch

