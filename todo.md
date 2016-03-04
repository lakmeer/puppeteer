
# Twitchie

## TODO

- Instead of Links with 'incomplete' status, have constructor return NullLink?
- Subclass Node into Triggers and other types. Triggers are allowed to
  automatically Poke. Other classes aren't.
- Totally separate the actual graph from it's graphical management
- Give registration concept to Sprites
- Implement loss-of-event-source messaging
- Serialising:
  - Track all nodes created
  - Start serialisation walk for every node with no outputs (this includes Puppet)
- Write node serialisation functions
- Finish deserialise function
- Adopt strict policy of named arguments


### Server

- Work out (/ask sreeram) how to statically link libwebsockets
- OS Hooks as node extension?

