
{ EventSource } = require \./event-source

export class WebsocketEventSource extends EventSource

  ->
    @socket = GlobalServices.Server.get-socket!
    super ...
    @socket.on \connect,    -> console.info \connect
    @socket.on \disconnect, -> console.warn \disconnect

  dispatch: (event-name, value) ~~>
    @callbacks[event-name].map -> it value

