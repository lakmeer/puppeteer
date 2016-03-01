
# Twitch Theatre / Twitchie

## TODO

- 'Node' class is responsible for the collaboration with a trigger, it's
  representation, and the workspace. It should have a better name, and 'Node'
  should go to the abstract version currently called 'Trigger'. Trigger then
  becomes just the subtype of Nodes which have no inputs. They probably dont
  event need to be distinct in code, maybe just in the way they're organised.

  - The ACTUAL reason triggers are different - they are allowed to Poke on
  state change. Other types of nodes should not poke for internal reasons.
  If this doesn't work out, move to a 'poke next frame' flag for global pokes,
  delaying the reaction by a from but preventing loops.

- Do correct aspect scaling inside GraphicRep
- Totally separate the actual graph from it's graphical management
- Promote PortSet to the trigger itself
- Allow Link representation to respond to state
- Implement loss-of-event-source messaging
- Pull Link view out of logical class


### Server

- Work out (/ask sreeram) how to statically link libwebsockets

