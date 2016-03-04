
{ id, log, abs, hyp, random-from } = require \std

determine-status = (a, b) ->
  if not a
    console.warn "Link::new - 'from' end is unavailable"
    LINK_STATUS_INCOMPLETE
  else if not b
    console.warn "Link::new - 'to' end is unavailable"
    LINK_STATUS_INCOMPLETE
  else if a.type isnt b.type
    console.warn "Link::new - can't join ports of disparate types! - FROM:", a.type, "| TO:", b.type
    LINK_STATUS_MISMATCH
  else
    LINK_STATUS_OK


export class Link

  ({ @from, @to }) ->
    # log \Link @from, @to
    @from?.assign-link this
    @to?.assign-link this
    @status = determine-status @from, @to
    @signal-strength = 0

  push-to:   -> if @status is LINK_STATUS_OK then @to.push!   else null
  pull-from: -> if @status is LINK_STATUS_OK then @from.pull! else null

  infer-signal-strength: ->
    @signal-strength =
      switch @from.type
      | SIGNAL_TYPE_POKE    => (if @from.pull! then 1 else 0)
      | SIGNAL_TYPE_GRAPHIC => (if @from.pull! then 1 else 0)
      | SIGNAL_TYPE_NUMBER  => @from.pull!
      | otherwise => 1

