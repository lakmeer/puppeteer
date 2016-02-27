
{ id, log } = require \std

{ Trigger } = require \./triggers/base
{ Representation } = require \./representations/base


export class PokeShim extends Trigger

  input-spec = [ { type: SIGNAL_TYPE_POKE, on-push: id } ]

  ->
    super ...
    @generate-ports { input-spec }


export class NumericShim extends Trigger

  input-spec = [ { type: SIGNAL_TYPE_NUMBER, on-push: id } ]

  ->
    super ...
    @generate-ports { input-spec }


export class GraphicShim extends Trigger

  input-spec = [ { type: SIGNAL_TYPE_GRAPHIC, on-push: id } ]

  ->
    super ...
    @generate-ports { input-spec }


export class ShimRep extends Representation
  ->
    super ...

