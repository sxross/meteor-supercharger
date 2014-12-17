Template.updates.helpers
  updated_at: ->
    u = Updates.findOne()
    if u?
      update_date = new Date(u.updated_at)
      # moment(update_date).format('L LT')
      moment(update_date).fromNow()
    else
      'never'

  updated_by: ->
    u = Updates.findOne()
    if u?
      u.updated_by
    else
      'nobody'

  update_class: ->
    if Router.current().url.match /about/
      'updates-hidden'
    else
      'updates-visible'
