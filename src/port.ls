
{ id, log, v2 } = require \std

class Port
  ({ @type, @owner, pos }) ->
    @pos = v2 0, 0
    @move-to pos

  assign-link: (@link) ->
  move-to: (pos) -> if pos then @pos.x = pos.x; @pos.y = pos.y
  push: -> @link?.push-to!
  pull: -> @link?.pull-from!

export class Input  extends Port
  ({ on-push }) ->
    super ...
    @push = on-push

export class Output extends Port
  ({ on-pull }) ->
    super ...
    @pull = on-pull

