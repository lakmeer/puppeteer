
{ id, log, raf, keys, get-microphone } = require \std

{ Node } = require \./base


export class MicNode extends Node

  SMOOTHING = 2

  output-spec = [
    { type: SIGNAL_TYPE_POKE,   on-pull: -> @state }
    { type: SIGNAL_TYPE_NUMBER, on-pull: -> @value }
  ]

  ->
    super ...

    @running = no
    @audio   = new AudioContext
    @hist    = []
    @avg     = 0
    @threshold = 1.1

    @generate-ports { output-spec }

    @analyser = @audio.create-analyser!
    @analyser.fft-size = 2048
    @buffer-length = @analyser.frequency-bin-count
    @data-array    = new Uint8Array @buffer-length

  start: ->
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
    @set avg > @threshold
    @avg = avg
    @value = @avg / @threshold

    GlobalServices.Poke.poke!

