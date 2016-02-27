
{ id, log, mash } = require \std

{ Sprite } = require \./sprite
{ Input }  = require \./port
{ Trigger } = require \./triggers/base

export class Puppet extends Trigger

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
    @inputs =
      for { type, on-pull } in input-spec
        new Input { type }

  pull: ->
    @chain = @inputs.map (.pull!) .filter id

  get-size: ->
    max = 0
    for sprite in @chain
      if sprite.width  > max then max = sprite.width
      if sprite.height > max then max = sprite.width
    return max

  draw: ({ ctx, size, offset = v2 0 0 }) ->
    if winner = @chain[* - 1]
      winner.blit-to ctx, offset.x, offset.y + size - winner.height

