
{ id, log, delay } = require \std

{ Trigger } = require \./base
{ Output } = require \../port

export class TimerTrigger extends Trigger

  output-spec = [ { type: SIGNAL_TYPE_POKE, on-pull: -> @state } ]

  ({ @time, @duty = 0.5 }) ->
    super ...
    @generate-ports { output-spec }
    @state = off
    @active = no
    @start!

  tick: ~>
    @set on
    delay @time * 1000 * @duty, this~set-off,
    if @active then delay @time * 1000, @tick

  set-off: ->
    @set off

  start: ->
    @active = yes
    @tick!

  stop: ->
    @active = no

