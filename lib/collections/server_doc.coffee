class @ChargerServerDoc
  constructor: (@working_document, @retrieved_document) ->

    # If an empty document on our side, it's fine. Just create as empty
    if _.isEmpty(@working_document) then @data = {} else @data = @working_document

    @pick_list = [
      'id'
      'name'
      'status'
      'stallCount'
      ]

    @default_list =
      teslaCount: 0
      iceCount: 0
      lineCount: 0
      offlineCount: 0

  set_defaults: ->
    _.defaults(@data, @default_list)

    @data.dateOpened = new Date(@data.dateOpened) if @data.dateOpened
    @data.dateModified = new Date(@data.dateModified) if @data.dateModified
    @

  merge: ->
    _.extend(@data, @retrieved_document)
    @

  needs_update: (callbacks = null) ->

    if callbacks is null
      return true unless @is_equal(@working_document, @retrieved_document)
      return false
    else
      # console.log """
      # callbacks not null:
      # insert: #{inspect callbacks['insert']}
      # update: #{inspect callbacks['update']}
      # """
      if @is_equal(@working_document, @retrieved_document)
        throw 'requires update callback' unless _.isFunction(callbacks.update)
        return callbacks.update.call(null, @data._id, _.omit(@data, '_id'))
      else
        throw 'require insert callback' unless _.isFunction(callbacks.insert)
        return callbacks.insert.call(null, _.omit(@data, '_id'))


  get: ->
    @data

  is_equal: ->
    return false if _.isEmpty(@working_document) || _.isEmpty(@retrieved_document)
    _.isEqual(
      _.pick(@working_document, @pick_list),
      _.pick(@retrieved_document, @pick_list)
      )
