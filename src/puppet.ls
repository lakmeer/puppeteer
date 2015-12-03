
{ id, log, mash } = require \std

{ Sprite } = require \./sprite

export class Puppet

  ->
    @animations = mash do
      for name in <[ choke draw drink drop frustrate look sing study think trash ]>
        [ name, new Sprite src: "assets/#{name}_01.png" ]

    @chain = [
      @animations.look
      @animations.choke
      @animations.draw
      @animations.drink
      @animations.drop
      @animations.frustrate
      @animations.sing
      @animations.study
      @animations.think
      @animations.trash
    ]

    @state =
      current-sprite: @animations.look

  set: (sprite-name, state) ->
    #log \set sprite-name, state
    @animations[sprite-name].active = state

  draw: ({ ctx, size }) ->
    winner = @chain.0

    for sprite, i in @chain when i > 0
      if sprite.active
        winner = sprite

    winner.blit-to ctx, 0, size - winner.height

