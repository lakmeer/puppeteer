
{ id, log, raf, keys, get-microphone } = require \std

{ Trigger } = require \./base


export class MicTrigger extends Trigger

  SMOOTHING = 5
  THRESHOLD = 1.1

  ->
    @running = no
    @audio   = new AudioContext
    @hist    = []
    @avg     = 0

    @analyser = @audio.create-analyser!
    @analyser.fft-size = 2048
    @buffer-length = @analyser.frequency-bin-count
    @data-array    = new Uint8Array @buffer-length

    get-microphone (mic-stream) ~>
      @mic = @audio.create-media-stream-source mic-stream
      @mic.connect @analyser
      @running = yes
      @monitor!

  monitor: ->
    if @running then raf this~monitor
    @analyser.getByteTimeDomainData @data-array
    avg = 0
    max = 0

    for i from 0 to @buffer-length
      sample = @data-array[i]
      if sample > max then
        max = sample

    @hist.push max / 128
    if @hist.length >= SMOOTHING
      @hist.shift!

    for p in @hist => avg += p
    avg /= SMOOTHING
    @set avg > THRESHOLD
    @avg = avg

  draw: ({ ctx, size }) ->
    ctx.fill-style = \grey
    ctx.fill-rect 0 0 size, 5
    ctx.fill-style = \lightgrey
    ctx.fill-rect 0 0 size/2 * THRESHOLD, 5
    ctx.fill-style = if @state then \red else \blue
    ctx.fill-rect 0 0 size/2 * @avg, 5
    ctx.global-alpha = 1

