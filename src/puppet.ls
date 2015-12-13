
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

  specify-inputs: -> [
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \a
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \b
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \c
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \d
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \e
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \f
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \g
    * type: SIGNAL_TYPE_GRAPHIC, on-pull: -> log \h
  ]

  specify-outputs: -> []

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

