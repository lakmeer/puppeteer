
{ id, log, mash } = require \std

{ Sprite } = require \./sprite
{ Input }  = require \./port

export class Puppet

  input-spec = [
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \a
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \b
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \c
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \d
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \e
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \f
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \g
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \h
  ]

  ->
    @inputs =
      for { type, on-pull } in input-spec
        new Input { type, on-pull }

  pull: ->

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
    #log \set sprite-name, state
    @animations[sprite-name].active = state

  draw: ({ ctx, size, offset = v2 0 0 }) ->
    winner = @get-winning-sprite!
    winner.blit-to ctx, offset.x, offset.y + size - winner.height

