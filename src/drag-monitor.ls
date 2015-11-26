
{ id, log, defer } = require \std


export class DragMonitor

  normalise-mouse = (λ) -> ({ pageX, pageY }) -> λ pageX, pageY
  normalise-touch = id

  ->
    @state =
      enabled: yes
      dragging: no
      released: no
      down: no
      Δx: 0
      Δy: 0
      last: [0 0]

    @callbacks =
      drag: id
      done: id

    # Listeners

    document.add-event-listener \keydown, ({ which }) ~>
      if which is 16
        @pointer-engage!

    document.add-event-listener \keyup, ({ which }) ~>
      if which is 16
        @pointer-release!

    document.add-event-listener \mousedown, normalise-mouse @pointer-engage
    document.add-event-listener \mousemove, normalise-mouse @pointer-move
    document.add-event-listener \mouseup,   normalise-mouse @pointer-release

    document.add-event-listener \touchstart, normalise-touch @pointer-engage
    document.add-event-listener \touchmove,  normalise-touch @pointer-move
    document.add-event-listener \touchend,   normalise-touch @pointer-release


  dispatch: (event, ...args) ->
    if @state.enabled
      @callbacks[event] ...args

  pointer-move: (x, y) ~>
    if @state.down or @state.dragging # Only upgrade to dragging when it actually moves
      @state.dragging = yes
      @state.Δx = Δx = x - @state.last.0
      @state.Δy = Δy = y - @state.last.1
      @state.last = [x, y]
      @dispatch \drag, Δx, Δy

  pointer-engage: (x, y) ~>
    @state.down = yes
    @state.last = [x, y]

  pointer-release: (x = @state.last.0, y = @state.last.1) ~>
    defer ~> @state.dragging = no  # So that any clicks can tell they were supposed to be a drag
    @state.released = yes
    @state.last = [x, y]
    @state.down = no
    @dispatch \drag, 0, 0
    @dispatch \done, @state


  # Helpers

  on-pointer-drag:    (λ) -> @callbacks.drag = λ
  on-pointer-release: (λ) -> @callbacks.done = λ

  toggle-event-listening: (state) ->
    @state.enabled = state


