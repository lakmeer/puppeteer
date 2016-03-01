
{ id, log } = require \std


# Socket.IO dependency comes from an html script tag. The IO client script
# is served automatically by the websocket server.

export class ServerInterface

  ->
    @socket = io(CONFIG_SOCKET_SERVER_ADDR)

  get-socket: ->
    @socket

  on:   (...args) -> @socket.on ...args
  emit: (...args) -> @socket.emit ...args

  emit-message: (msg, ...data) ->
    @socket.emit msg, ...data

