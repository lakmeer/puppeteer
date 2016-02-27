
{ id, log, v2 } = require \std

{ Representation } = require \./base


export class GraphicRep extends Representation

  ->
    log 'new GraphicRep', @target

    super ...

