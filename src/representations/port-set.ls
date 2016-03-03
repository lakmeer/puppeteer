
{ id, log, v2 } = require \std


port-color = ({ type }) ->
  switch type
  | SIGNAL_TYPE_NUMBER => COLOR_MAGENTA
  | SIGNAL_TYPE_GRAPHIC => COLOR_BRIGHT_BLUE
  | otherwise =>  COLOR_BRIGHT_GREEN


export class PortSetRep

  PORT_WIDTH = 20

  (@target, { @offset = 0, @height = 100, pos = v2 0 0 }:config) ->
    @pos = v2 0, 0
    @move-to pos

  get-port-vertical-pos: (i) ->
    space = (@height - 20 * @length) / if @length is 1 then 1 else @length - 1
    start = @pos.y + PORT_WIDTH/2 - @height/2
    start + i * (PORT_WIDTH + space)

  move-to: ({ x, y }) ->
    @pos.x = x + @offset
    @pos.y = y

    for port, i in @target.ports
      port.move-to do
        x: @pos.x,
        y: @get-port-vertical-pos i

  draw: ({ ctx }) ->
    for port, i in @target.ports
      ctx.fill-style = port-color port
      ctx.fill-rect @pos.x - 3, @pos.y - 10, 8, 20


