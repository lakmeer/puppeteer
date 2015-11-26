
{ id, log, v2 } = require \std

export class InputSet

  (@offset, pos) ->
    @pos = v2 0, 0
    @move-to pos

  pull: ->
    log \pull!, this

  move-to: ({ x, y }) ->
    @pos.x = x + @offset
    @pos.y = y

  first:~ -> this

