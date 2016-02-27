
{ id, log, v2 } = require \std


class PortSet

  PORT_WIDTH = 20

  (@ports = [], { @offset = 0, @height = 100, pos = v2 0 0 }:config) ->
    @pos = v2 0, 0
    @move-to pos

  get-port-vertical-pos: (i) ->
    space = (@height - 20 * @length) / if @length is 1 then 1 else @length - 1
    start = @pos.y + PORT_WIDTH/2 - @height/2
    start + i * (PORT_WIDTH + space)

  move-to: ({ x, y }) ->
    @pos.x = x + @offset
    @pos.y = y

    for port, i in @ports
      port.move-to do
        x: @pos.x,
        y: @get-port-vertical-pos i

  next:~ ->
    for port in @ports
      if not port.link?
        return port

  length:~ ->
    @ports.length

  pull: ->
    @owner.pull!


export class InputSet  extends PortSet
export class OutputSet extends PortSet

