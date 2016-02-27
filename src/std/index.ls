
export id = -> it

export log = -> console.log.apply console, &; &0

export flip = (λ) -> (a, b) --> λ b, a

export delay = flip set-timeout

export defer = delay 0

export v2 = (x, y) -> if y? then { x, y } else { x: x.x, y: x.y }

export floor = Math.floor

export rand = (* Math.random!)

export random-from = (xs) -> xs[floor rand xs.length]

export sqrt = Math.sqrt

export hyp = (a, b) ->
  Δx = b.x - a.x
  Δy = b.y - a.y
  sqrt Δx * Δx + Δy * Δy

export raf = request-animation-frame

export mash = (xs) -> { [ k, v ] for [ k, v ] in xs }

export log-error = -> log @, &

export get-microphone = (λ) ->
  navigator.webkit-get-user-media { audio: true }, λ, log-error

export keys = -> for k,v of it => k

export load-image = (src, λ = id) ->
  image = new Image
  image.src = src
  image.onload = λ
  return image

export abs = Math.abs

