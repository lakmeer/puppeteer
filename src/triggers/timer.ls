
{ id, log } = require \std

{ Trigger } = require \./base

export class TimerTrigger extends Trigger

  ({ @time, @duty = 0.5 }) ->
    super ...

    @active = yes

    set-off = ~> @set off

    fn = ~>
      @set on
      set-timeout set-off, @time * 1000 * @duty
      if @active then set-timeout fn, @time * 1000

    fn!

  stop: ->
    @active = no

