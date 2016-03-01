
{ EventSource } = require \./event-source

export class BrowserEventSource extends EventSource

  listener: (event-name, processor) ->
    document.add-event-listener event-name, processor >> @dispatch event-name

