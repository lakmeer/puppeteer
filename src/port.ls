
{ id, log, v2 } = require \std

class Port
  ({ @type, @on-pull, pos }) ->
    log 'new Port', @type, @on-pull
    @pos = v2 0, 0
    @move-to pos

  assign-link: (@link) ->
  push: -> @on-pull!
  pull: -> 
    log @on-pull!
  move-to: (pos) -> if pos then @pos.x = pos.x; @pos.y = pos.y

export class Input  extends Port; -> super ...
export class Output extends Port; -> super ...

