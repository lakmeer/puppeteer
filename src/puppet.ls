
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
    @inputs.map (.pull!)

  get-size: ->
    return 200
    max = 0
    for sprite in @chain
      if sprite.width  > max then max = sprite.width
      if sprite.height > max then max = sprite.width
    return max

  get-winning-sprite: ->
    return blit-to: id
    winner = @chain.0
    for sprite, i in @chain when i > 0
      if sprite.active
        winner = sprite
    return winner

  draw: ({ ctx, size, offset = v2 0 0 }) ->
    winner = @get-winning-sprite!
    winner.blit-to ctx, offset.x, offset.y + size - winner.height

