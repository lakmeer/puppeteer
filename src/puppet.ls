
{ id, log, mash } = require \std

{ Sprite } = require \./sprite
{ Input }  = require \./port
{ Node }   = require \./nodes/base

export class Puppet extends Node

  input-spec = [
    * type: SIGNAL_TYPE_GRAPHIC
    * type: SIGNAL_TYPE_GRAPHIC
    * type: SIGNAL_TYPE_GRAPHIC
    * type: SIGNAL_TYPE_GRAPHIC
    * type: SIGNAL_TYPE_GRAPHIC
    * type: SIGNAL_TYPE_GRAPHIC
    * type: SIGNAL_TYPE_GRAPHIC
    * type: SIGNAL_TYPE_GRAPHIC
  ]

  ->
    @generate-ports { input-spec }
    @chain = []

  pull: ->
    @chain = @inputs.map (.pull!) .filter id

  get-size: ->
    max = 0
    for sprite in @chain
      if sprite.width  > max then max = sprite.width
      if sprite.height > max then max = sprite.width
    return max

  get-winner: ->
    @chain[* - 1]

