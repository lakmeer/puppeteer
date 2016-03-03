
{ id, log, v2 } = require \std

{ Input, Output } = require \./port


#
# Port Set
#

class PortSet

  ({ spec, @owner }) ->
    @ports = @generate-ports spec
    @map = @ports~map

  get: (ix) ->
    @ports[ix]

  all:~ ->
    @ports

  next:~ ->
    for port in @ports
      if not port.link?
        return port

  length:~ ->
    @ports.length



#
# Specialisations
#

export class InputSet extends PortSet
  generate-ports: (spec) ->
    for { type, on-push = id } in spec
      new Input { type, owner: @owner, on-push: on-push.bind @owner }

export class OutputSet extends PortSet
  generate-ports: (spec) ->
    for { type, on-pull = id } in spec
      new Output { type, owner: @owner, on-pull: on-pull.bind @owner }

