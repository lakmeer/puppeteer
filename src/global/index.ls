
# Require

{ id, log } = require \std

require \./const

{ PokeService }          = require \./poke
{ SceneLibrary }         = require \./scene-library
{ ServerInterface }      = require \./server-interface
{ BrowserEventSource }   = require \./browser-event-source
{ WebsocketEventSource } = require \./websocket-event-source


# Globally-available Service Locators

global.GlobalServices =

  init: ->

    GlobalServices.Server = new ServerInterface

    GlobalServices.Poke = new PokeService

    GlobalServices.SceneLibrary = new SceneLibrary socket: GlobalServices.Server

    GlobalServices.EventSource =
      switch CONFIG_EVENT_SOURCE
      | EVENT_SOURCE_WEBSOCKETS => new WebsocketEventSource
      | EVENT_SOURCE_BROWSER    => new BrowserEventSource

