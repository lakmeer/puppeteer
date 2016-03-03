
{ id, log, v2 } = require \std

class Port
  ({ @type, @owner, @index }) ->

  assign-link: (@link) ->

  push: ->
    @link?.push-to!

  pull: ->
    @link?.pull-from!

export class Input  extends Port
  ({ on-push }) ->
    super ...
    @push = on-push

export class Output extends Port
  ({ on-pull }) ->
    super ...
    @pull = on-pull

