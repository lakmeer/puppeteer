
{ id, log, v2 } = require \std

export class InputSet

  (@source, @offset, pos) ->
    @pos = v2 0, 0
    @move-to pos
    @state = off

  pull: ->
    @source.state.signal

  move-to: ({ x, y }) ->
    @pos.x = x + @offset
    @pos.y = y

  first:~ -> this

