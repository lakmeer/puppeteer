
{ Blitter } = require \./blitter

export class Workspace extends Blitter

  ->
    super size: 550

  install: (host) ->
    host.append-child @canvas

