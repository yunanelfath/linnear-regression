{EventEmitter} = fbemitter

KeyGenerator = new KeyGenerator()

CHANGE_EVENT = 'change'
ITEM_CHANGE_EVENT = 'change:item'

window.GlobalStore = _.assign(new EventEmitter(), {
  form:
    alpha: 0.0001
    teta0: 0.00
    teta1: 0.00
    tempTeta0: 0.00
    tempTeta1: 0.00
    finalTeta0: 0.00
    finalTeta1: 0.00
    regressions: [
      [0,0]
      [0,0]
    ]

  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)

  emitItemChange: -> @emit(ITEM_CHANGE_EVENT)
  addItemChangeListener: (callback) -> @addListener(ITEM_CHANGE_EVENT, callback)
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'attributes-setter'
      _.assign(GlobalStore, payload.attributes)
      # debugger
      GlobalStore.emitChange()
    when 'parent-attributes-setter'
      # debugger
      _.assign(GlobalStore.form, payload.attributes)
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
