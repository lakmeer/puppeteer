
{ id, log, delay } = require \std

{ Node } = require \./base
{ Output } = require \../port

export class TimerNode extends Node

  output-spec = [ { type: SIGNAL_TYPE_POKE, on-pull: -> @state } ]

  ({ @time, @duty = 0.5, @offset = 0 }) ->
    super ...
    @generate-ports { output-spec }
    @state = off
    @active = no
    @start!

  tick: ~>
    @set on
    delay @time * 1000 * @duty, this~set-off,
    if @active then delay @time * 1000, @tick

  set: ->
    GlobalServices.Poke.poke!
    super ...

  set-off: ->
    @set off

  start: ->
    @active = yes
    delay (@time - @offset) * 1000, ~>
      this~tick!

  stop: ->
    @active = no
    @set off

