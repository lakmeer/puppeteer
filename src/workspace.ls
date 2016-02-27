
{ Blitter } = require \./blitter

export class Workspace extends Blitter

  ->
    super size: 950

  install: (host) ->
    host.append-child @canvas

