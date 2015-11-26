
{ Blitter } = require \./blitter

export class Workspace extends Blitter

  ->
    super size: 1000

  install: (host) ->
    host.append-child @canvas

