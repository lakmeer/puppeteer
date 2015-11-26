
export id = -> it

export log = -> console.log.apply console, &; &0

export flip = (λ) -> (a, b) --> λ b, a

export delay = flip set-timeout

export defer = delay 0

export v2 = (x, y) -> { x, y }

export floor = Math.floor

export rand = (* Math.random!)

export random-from = (xs) -> xs[floor rand xs.length]

export sqrt = Math.sqrt

export hyp = (a, b) ->
  Δx = b.x - a.x
  Δy = b.y - a.y
  sqrt Δx * Δx + Δy * Δy

