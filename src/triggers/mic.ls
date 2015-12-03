
# Helpers

{ id, log, raf, keys, get-microphone } = require \std

{ Trigger } = require \./base


# Options

SMOOTHING = 50
THRESHOLD = 1.2


# Setup

export class MicTrigger extends Trigger

  ->
    @running = no
    @audio = new AudioContext

    @hist = []
    @avg  = 0

    # Init
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
    if @running
      raf this~monitor

  draw: ({ ctx }) ->

    @analyser.getByteTimeDomainData @data-array

    width  = 300
    height = 300

    max = 0

    # Draw mic input
    for i from 0 to @buffer-length
      sample = @data-array[i]

      if sample > max
        max = sample

    max /= 128
    @hist.push max

    if @hist.length >= SMOOTHING
      @hist.shift!

    threshold = THRESHOLD

    avg = 0
    for p in @hist => avg += p
    avg /= @hist.length

    # Draw average level
    ctx.global-composite-operation = 'source-over'
    ctx.global-alpha = 1

    if avg > THRESHOLD
      @set on
    else
      @set off

    ctx.fill-style = \blue
    ctx.fill-rect 0, height - avg * height/2, width, 2
    ctx.fill-style = \black
    ctx.fill-rect 0, height - threshold * height/2, width, 2

