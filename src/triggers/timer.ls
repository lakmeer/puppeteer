
{ id, log } = require \std

{ Trigger } = require \./base
{ Output } = require \../port

export class TimerTrigger extends Trigger

  output-spec = [ { type: SIGNAL_TYPE_POKE, on-pull: ~> log \active; @active } ]

  ({ @time, @duty = 0.5 }) ->
    super ...

    @active = yes

    @outputs =
      for { type, on-pull } in output-spec
        new Output { type, on-pull.bind this }

    set-off = ~> @set off

    fn = ~>
      @set on
      set-timeout set-off, @time * 1000 * @duty
      if @active then set-timeout fn, @time * 1000

    fn!

  stop: ->
    @active = no

