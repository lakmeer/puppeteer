
{ id, log, v2 } = require \std

{ VowelWorm } = require \../vowelworm.js

{ Node } = require \./base.ls



export class VowelNode extends Node

  minHz             = 0
  maxHz             = 8000
  num-filterbanks   = 25
  silence-threshold = -70

  ->
    super ...
    log "New VowelNode"

    @worm = void

  listen: ->
    navigator.webkitGetUserMedia { audio: true }, this~on-mic-available, this~on-mic-failed

  on-mic-available: (stream) ->
    @worm = new VowelWorm.instance stream

  on-mic-failed: (err) ->
    console.error "Couldn't obtain microphone:", err

  is-silent: (buffer) ->
    for i from 0 to buffer.length
      if buffer[i] > silence-threshold
        return false
    return true

  update: ->

    return if not @worm?

    buffer = @worm.getFFT!
    pos = v2 0, 0

    return pos if is-silent buffer

    mfccs = worm.get-MFCCs min-freq: 0, max-freq: 8000, filter-banks: num-filterbanks, fft: buffer

    if mfccs.length
      selection = mfccs.slice 0, num-filterbanks
      coords = VowelWorm.normalize selection, VowelWorm.Normalization.regression

      if coords.length
        pos.x = coords.0
        pos.y = coords.1

    return pos

