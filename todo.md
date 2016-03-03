
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

- Totally separate the actual graph from it's graphical management
- Give registration concept to Sprites
- Implement loss-of-event-source messaging
- Serialising:
  - Track all nodes created
  - Start serialisation walk for every node with no outputs (this includes Puppet)
- Write node serialisation functions
- Finish deserialise function


### Server

- Work out (/ask sreeram) how to statically link libwebsockets
- OS Hooks as node extension?

