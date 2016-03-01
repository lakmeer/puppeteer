
{ id, log } = require \std


export class SceneLibrary

  ({ @socket }) ->

    @load-callback = id

    @socket.on \save-complete, (name) ->
      console.info "GlobalServices.SceneLibrary::save - Scene '#name' saved."

    @socket.on \load-complete, (name, data) ~>
      console.info "GlobalServices.SceneLibrary::load - Scene '#name' loaded."
      @load-callback JSON.parse data
      @load-callback = id

  save: (name, scene-data) ->
    compressed-scene = scene-data.replace /[\s\n]/g, ''
    console.info 'Persisting scene graph:', compressed-scene
    @socket.emit \save, name, compressed-scene

  load: (name, λ) ->
    @socket.emit \load, name
    @load-callback = λ

