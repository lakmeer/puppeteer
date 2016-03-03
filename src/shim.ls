
{ id, log } = require \std

{ Node } = require \./nodes/base
{ Representation } = require \./representations/base


export class PokeShim extends Node

  input-spec = [ { type: SIGNAL_TYPE_POKE, on-push: id } ]

  ->
    super ...
    @generate-ports { input-spec }


export class NumericShim extends Node

  input-spec = [ { type: SIGNAL_TYPE_NUMBER, on-push: id } ]

  ->
    super ...
    @generate-ports { input-spec }


export class GraphicShim extends Node

  input-spec = [ { type: SIGNAL_TYPE_GRAPHIC, on-push: id } ]

  ->
    super ...
    @generate-ports { input-spec }


export class ShimRep extends Representation
  ->
    super ...

