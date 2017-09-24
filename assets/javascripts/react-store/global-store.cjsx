{EventEmitter} = fbemitter

KeyGenerator = new KeyGenerator()

CHANGE_EVENT = 'change'
ITEM_CHANGE_EVENT = 'change:item'

window.GlobalStore = _.assign(new EventEmitter(), {
  quickPollingEmbedEditor: {}
  quickEmbedItems: []

  addUniqueItem: ->
    {id: KeyGenerator.getUniqueKey(), value: null}

  addQuickPollingItem: (id) ->
    {
      id: id
      answerType: null
      question: null
      overlayBackground: null
      answerItems: []
    }

  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)

  emitItemChange: -> @emit(ITEM_CHANGE_EVENT)
  addItemChangeListener: (callback) -> @addListener(ITEM_CHANGE_EVENT, callback)
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'attributes-setter'
      _.assign(GlobalStore, payload.attributes)
      GlobalStore.emitChange()
    when 'new-quickpolling-setter'
      quickEmbedItems = GlobalStore.quickEmbedItems
      newItem = GlobalStore.addQuickPollingItem(payload.attributes.id)
      # add default answer items
      newAnswerItem = GlobalStore.addUniqueItem()
      newItem.answerItems.push(GlobalStore.addUniqueItem())
      quickEmbedItems[payload.attributes.id] = newItem
      GlobalStore.emitChange()
    when 'children-attributes-setter'
      _.assign(GlobalStore.quickEmbedItems[payload.assign.id][payload.assign.type], payload.attributes)
      GlobalStore.emitChange()
    when 'parent-attributes-setter'
      _.assign(GlobalStore.quickEmbedItems[payload.assign.id], payload.attributes)
      GlobalStore.emitChange()
    when 'items-attributes-setter'
      items = GlobalStore.quickEmbedItems[payload.assign.id][payload.assign.type]
      item = _.find(items, (e) -> e.id == payload.attributes.id)
      _.assign(item, payload.attributes)
      GlobalStore.emitItemChange()
      GlobalStore.emitChange()
    when 'items-attributes-remover'
      items = GlobalStore.quickEmbedItems[payload.assign.id][payload.assign.type]
      item = _.remove(items, (e) -> e.id == payload.attributes.id)
      GlobalStore.emitItemChange()
      GlobalStore.emitChange()
    when 'quickpolling-attributes-remover'
      delete GlobalStore.quickEmbedItems[payload.assign.id]
      GlobalStore.emitChange()
