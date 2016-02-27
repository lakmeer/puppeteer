
{ id, log, mash } = require \std

{ Sprite } = require \./sprite
{ Input }  = require \./port

export class Puppet

  input-spec = [
    * type: SIGNAL_TYPE_POKE
    * type: SIGNAL_TYPE_POKE
    * type: SIGNAL_TYPE_POKE
    * type: SIGNAL_TYPE_POKE
    * type: SIGNAL_TYPE_POKE
    * type: SIGNAL_TYPE_POKE
    * type: SIGNAL_TYPE_POKE
    * type: SIGNAL_TYPE_POKE
  ]

  ({ @chain }) ->
    @inputs =
      for { type, on-pull } in input-spec
        new Input { type }

    @animations = { [ k, true ] for k, v of @chain }

    log @animations, @chain

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

  set: (sprite-name, state) ->
    @animations[sprite-name]?.active = state

  draw: ({ ctx, size, offset = v2 0 0 }) ->
    winner = @get-winning-sprite!
    winner.blit-to ctx, offset.x, offset.y + size - winner.height

