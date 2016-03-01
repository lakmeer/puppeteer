
{ id, log } = require \std


export class SceneLibrary

  ({ @socket }) ->

  save: (name, scene-data) ->
    compressed-scene = scene-data.replace /[\s\n]/g, ''
    console.info 'Persisting scene graph:', compressed-scene
    @socket.emit \save, name, compressed-scene

