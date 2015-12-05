
{ id, log, mash } = require \std

{ Sprite } = require \./sprite

export class Puppet

  ->
    @animations = mash do
      for name in <[ choke draw drink drop frustrate look sing study think trash ]>
        [ name, new Sprite src: "assets/#{name}_01.png" ]

    @chain = [
      @animations.look
      @animations.draw
      @animations.choke
      @animations.drop
      @animations.frustrate
      @animations.sing
      @animations.study
      @animations.think
      @animations.trash
      @animations.drink
    ]

    @state =
      current-sprite: @animations.look

  get-size: ->
    max = 0
    for sprite in @chain
      if sprite.width  > max then max = sprite.width
      if sprite.height > max then max = sprite.width
    return max

  get-winning-sprite: ->
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

