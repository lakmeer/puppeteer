
{ id, log, v2 } = require \std


port-color = ({ type }) ->
  switch type
  | SIGNAL_TYPE_NUMBER => COLOR_MAGENTA
  | SIGNAL_TYPE_GRAPHIC => COLOR_BRIGHT_BLUE
  | otherwise =>  COLOR_BRIGHT_GREEN


export class PortSetRep

  PORT_WIDTH = 20

  (@target, { @offset = 0, @height = 100, @basis = v2 0 0 }) ->
    @port-positions = [ v2 0, 0 for i in @target.ports ]
    @length = @port-positions.length
    @move-to @basis

  get-pos: (ix) ->
    @port-positions[ix]

  get-port-vertical-pos: (i) ->
    space = (@height - 20 * @length) / if @length is 1 then 1 else @length - 1
    start = PORT_WIDTH/2 - @height/2
    y-pos = start + i * (PORT_WIDTH + space)

  move-to: ({ x, y }) ->
    @basis.x = x + @offset
    @basis.y = y

    for pos, i in @port-positions
      pos.x = @basis.x
      pos.y = @basis.y + @get-port-vertical-pos i

  draw: ({ ctx }) ->
    for port, i in @target.ports
      ctx.fill-style = port-color port
      ctx.fill-rect @port-positions[i].x, @port-positions[i].y - 10, 8, 20

