
# Require

{ Puppet }      = require \./puppet
{ KeyNode }     = require \./nodes/key
{ MicNode }     = require \./nodes/mic
{ MouseNode }   = require \./nodes/mouse
{ TimerNode }   = require \./nodes/timer
{ GraphicNode } = require \./nodes/graphic

{ MicRep }     = require \./representations/mic
{ KeyRep }     = require \./representations/key
{ TimerRep }   = require \./representations/timer
{ PuppetRep }  = require \./representations/puppet
{ GraphicRep } = require \./representations/graphic
{ MouseRep }   = require \./representations/mouse
{ LinkRep }    = require \./representations/link


# Turn string-based requests for node types into their actual class with associated Rep class

export NodeProvider = (node-type) ->
  switch node-type
  | \Puppet => [ Puppet, PuppetRep ]
  | \KeyNode => [ KeyNode, KeyRep ]
  | \GraphicNode => [ GraphicNode, GraphicRep ]
  | \MouseNode => [ MouseNode, MouseRep ]
  | \TimerNode => [ TimerNode, TimerRep ]
  | \MicNode => [ MicNode, MicRep ]
  | otherwise => console.warn "NodeProvider - can't get node for type '#node-type'"

