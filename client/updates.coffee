Template.updates.helpers
  updated_at: ->
    u = Updates.findOne()
    if u?
      update_date = new Date(u.updated_at)
      console.log "update date: #{update_date}"
      console.log "       type: #{typeof update_date}"
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
